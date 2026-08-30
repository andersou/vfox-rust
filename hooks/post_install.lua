local utils = require("utils")

--- Post-installation hook, called after the SDK archive has been unpacked.
--- The plugin keeps every component (cargo, rustc, rust-std, ...) in its own
--- prefix (see env_keys.lua), but rustc locates the standard library relative
--- to its own binary at <sysroot>/lib/rustlib/<target>/lib. The extracted
--- rust-std payload must therefore be merged into the rustc prefix, otherwise
--- every compilation fails with E0463 "can't find crate for `core`".
--- @param ctx table
--- @field ctx.sdkInfo table SDK information; ctx.sdkInfo['rust'].path is the install directory
function PLUGIN:PostInstall(ctx)
    if RUNTIME.osType:lower() == "windows" then
        -- The Windows archive layout/installer differs; only handle unix-style tarballs.
        return
    end

    local path = ctx.sdkInfo["rust"].path
    local triple = utils:getTargetTriple(RUNTIME.osType, RUNTIME.archType)

    local src = path .. "/rust-std-" .. triple .. "/lib/rustlib/" .. triple
    local dst = path .. "/rustc/lib/rustlib/" .. triple

    local cmd = string.format('mkdir -p "%s" && cp -R "%s"/. "%s"/', dst, src, dst)
    if os.execute(cmd) ~= 0 then
        error("failed to install rust-std component into rustc sysroot")
    end
end
