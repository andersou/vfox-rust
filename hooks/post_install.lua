local utils = require("utils")

--- Post-installation hook, called after the SDK archive has been unpacked.
--- The plugin keeps every component (cargo, rustc, rust-std, llvm-tools, ...)
--- in its own prefix (see env_keys.lua), but a rustup-style toolchain expects
--- them merged into a single sysroot: rustc resolves the standard library at
--- <sysroot>/lib/rustlib/<target>/lib, and the helper binaries shipped in
--- <sysroot>/lib/rustlib/<target>/bin are linked against @loader_path/../lib.
---
--- Keeping the components split therefore breaks two things:
---   * every compilation fails with E0463 "can't find crate for `core`"
---     (rust-std payload missing from the rustc prefix);
---   * `rust-objcopy` (used by cargo's `strip`) aborts with
---     "Library not loaded: @rpath/libLLVM.dylib", because libLLVM lives in
---     the llvm-tools-preview prefix instead of next to the sysroot binaries.
---
--- So merge the lib/rustlib/<target> payload of every component into the rustc
--- prefix, which reproduces the rustup layout.
--- @param ctx table
--- @field ctx.sdkInfo table SDK information; ctx.sdkInfo['rust'].path is the install directory
function PLUGIN:PostInstall(ctx)
    if RUNTIME.osType:lower() == "windows" then
        -- The Windows archive layout/installer differs; only handle unix-style tarballs.
        return
    end

    local path = ctx.sdkInfo["rust"].path
    local triple = utils:getTargetTriple(RUNTIME.osType, RUNTIME.archType)

    local dst = path .. "/rustc/lib/rustlib/" .. triple

    local cmd = string.format(
        'set -e; mkdir -p "%s"; ' ..
        'for src in "%s"/*/lib/rustlib/"%s"; do ' ..
        'if [ -d "$src" ] && [ "$src" != "%s" ]; then cp -R "$src"/. "%s"/; fi; ' ..
        'done',
        dst, path, triple, dst, dst
    )
    if os.execute(cmd) ~= 0 then
        error("failed to merge rust components into the rustc sysroot")
    end
end
