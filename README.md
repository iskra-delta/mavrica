![status.badge] [![language.badge]][language.url] [![standard.badge]][standard.url] [![license.badge]][license.url]

# mavrica

A JIT-based ZX Spectrum emulator for the Iskra Delta Partner.

![Mavrica](docs/img/mavrica.jpg)

## Current state

The emulator loads a Z80 program at a configurable address and begins execution from a specified entry point. It uses a just-in-time technique that identifies basic blocks of code and replaces branch-related instructions (e.g. `JP`, `RET`, `JR`, etc.) with `RST 38h`.

When `RST 38h` is hit, a handler restores the original instruction, records the block boundaries, and transfers control to the next block.

Each block is decoded and stored along with:
- the start and end address
- the original instruction replaced by `RST`
- any metadata used for block tracking

Instruction decoding is done using a compact lookup table that returns instruction length and type (e.g., branch, call, port access).

All compiled blocks are stored in a table that enables quick detection of jumps into already decoded regions. Blocks are extended or merged when possible to reduce memory use.

This implementation is written entirely in Z80 assembly and is intended to run on real hardware.

## JIT runtime API

The core runtime now lives in `src/jitty/jit.s` and provides:

- `jit_init` - clears block metadata
- `jit_compile_block` - decodes one block and patches its exit to `RST 38h`
- `jit_run` - compiles the entry block and transfers execution to guest code
- `jit_trap` - `RST 38h` trap handler that emulates patched exits (`JP/JR/CALL/RET/RST`, including conditional forms), compiles the next block, and dispatches to it

`src/main.s` also installs a jump at address `0x0038` so `RST 38h` reaches `jit_trap`.

---

[language.url]:   https://en.wikipedia.org/wiki/ANSI_C
[language.badge]: https://img.shields.io/badge/language-C-blue.svg

[standard.url]:   https://en.wikipedia.org/wiki/C89/
[standard.badge]: https://img.shields.io/badge/standard-C89-blue.svg

[license.url]:    https://github.com/tstih/libcpm3-z80/blob/main/LICENSE
[license.badge]:  https://img.shields.io/badge/license-MIT-blue.svg

[status.badge]:  https://img.shields.io/badge/status-development-red.svg
