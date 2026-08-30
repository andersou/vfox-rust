# vfox-rust

rust plugin for [vfox](https://vfox.dev/) .

## Install

After installing [vfox](https://vfox.dev/), install this plugin from the latest release:

```
vfox add --source https://github.com/andersou/vfox-rust/releases/download/v1.1.2/vfox-rust-1.1.2.zip rust
```

`vfox add rust` pulls the plugin from the public registry, which currently still points at the unmaintained upstream
repository; a PR to retarget it at this fork is open.

## Fork notice

This repository is a fork of [XZzYassin/vfox-rust](https://github.com/XZzYassin/vfox-rust), which appears to be no
longer maintained. Many thanks to [@XZzYassin](https://github.com/XZzYassin) for the original plugin — this fork only
exists because of that work.

Changes in this fork:

- macOS support: `RUNTIME.osType` `"darwin"` is mapped to the `apple-darwin` targets.
- Every component payload (`rust-std`, `llvm-tools`, `rust-analysis`, ...) is merged into the `rustc` sysroot, so
  `rustc` finds `core` and the sysroot helpers (`rust-objcopy`, `llvm-cov`, ...) find `libLLVM`.
- Every component prefix with binaries (`rustfmt`, `clippy`, `rust-analyzer`, ...) gets a `lib` symlink to the
  `rustc` libraries, so their `@loader_path/../lib` lookup for `librustc_driver`/`libLLVM` resolves without
  `DYLD_LIBRARY_PATH`.
- Available versions are fetched dynamically from [releases.rs](https://releases.rs/docs/).

## License

Apache 2.0, inherited from the original project.
