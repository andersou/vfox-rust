# vfox-rust

rust plugin for [vfox](https://vfox.dev/) .

## Install

After installing [vfox](https://vfox.dev/), install the plugin by running:

```
vfox add --source https://github.com/andersou/vfox-rust/releases/download/manifest/manifest.json rust
```

## Fork notice

This repository is a fork of [XZzYassin/vfox-rust](https://github.com/XZzYassin/vfox-rust), which appears to be no
longer maintained. Many thanks to [@XZzYassin](https://github.com/XZzYassin) for the original plugin — this fork only
exists because of that work.

Changes in this fork:

- macOS support: `RUNTIME.osType` `"darwin"` is mapped to the `apple-darwin` targets.
- `rust-std` is installed into the `rustc` sysroot, and Rust dylibs are exposed to the other components.
- Available versions are fetched dynamically from [releases.rs](https://releases.rs/docs/).

## License

Apache 2.0, inherited from the original project.
