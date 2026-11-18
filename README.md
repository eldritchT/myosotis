# ✿  myosotis
A basic customisable Linux environment based on [Buildroot](https://buildroot.org), initially targeted for handheld consoles and other embedded systems.

## Note
This is an experimental project that I started mainly to learn how Buildroot works (starting with little to no knowledge) and create a simple environment for *personal use*. It is very, **very** far from being somewhat usable and stable, let alone being ready for any sort of production.

## Usage
`myosotis` works as an external tree wrapper that downloads a copy of Buildroot and applies your changes on top of it, without touching the copy itself. By default, it's as barebones as possible - it just runs [sway](https://github.com/swaywm/sway) with a minimal config.

### Compiling and running
At the moment, `myosotis` was not tested on any real hardware, so by default it only compiles for QEMU.
```shell
# This command compiles everything, generates an image and runs it in QEMU. Took ~0.9h on my machine.
# Same can be done by doing `make && ./scripts/run-qemu.sh`
make run
```

## Credits
- [Buildroot](https//buildroot.org)
- [R36S board config](https://github.com/haoict/buildroot-r36s/tree/develop/board/r36s) by [haoict](https://github.com/haoict)