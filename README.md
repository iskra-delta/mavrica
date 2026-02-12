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

## Build and run

Build from project root:

```bash
make all
```

This uses the Docker image defined in `Makefile` and produces:

- `build/mavrica.ihx`
- `build/mavrica.bin`

Clean:

```bash
make clean
```

## JIT setup flow

Current JIT flow is:

1. Initialize runtime metadata via `jit_init`.
2. Choose guest entry address (`HL`).
3. Call `jit_run` (or `jit_compile_block` + `jp (hl)` manually).
4. First basic block is scanned and its exit is patched to `RST 38h`.
5. On exit, `jit_trap` emulates control flow, compiles next block, dispatches.

`src/main.s` currently initializes and loops; to run guest code you need to load it and call `jit_run`.

## Running your own guest program

### Minimal integration example

Use a fixed guest load area (example `0x8000`) and a known entry point:

```asm
        .globl  jit_init
        .globl  jit_run

GUEST_ENTRY      .equ 0x8000

start:
        di
        call    jit_init

        ;; TODO: copy/decompress guest bytes to GUEST_ENTRY.
        ;; Example: LDIR from embedded image to 0x8000.

        ld      hl, #GUEST_ENTRY
        call    jit_run
hang:   jr      hang
```

### Tiny guest sample (for smoke test)

Guest code idea:

```asm
        org 0x8000
loop:
        xor a
        out (0xfe),a
        jr loop
```

This verifies block compilation + trap looping. To make `OUT` visible to emulator logic, use I/O trapping (section below).

## Trapping `IN`/`OUT` for keyboard and devices

Your decoder already tags these instructions with `I_IO`. To trap them:

1. Extend `jit_is_exit` in `src/jitty/jit.s` to treat `I_IO` as an exit.
2. In `jit_trap`, add an `I_IO` dispatch branch.
3. Decode the trapped opcode bytes (`jit_op0..jit_op2`) and call host handlers:
   - `host_io_out(port, value)`
   - `host_io_in(port) -> A`
4. Set `jit_target_pc` to fall-through address and dispatch.

For ZX Spectrum keyboard, emulate matrix reads on port `0xFE` by returning bits in `A` according to row-select lines.

## Trapping writes to video memory

Z80 has no page protection, so writes must be trapped by instrumentation.

Recommended approach:

1. During block compile, detect memory-write instructions that can target screen RAM.
2. Patch those writes to call a tiny helper or force exit at that instruction.
3. Helper marks dirty region and mirrors write to host framebuffer model.

Pragmatic first step:

- Trap all writes in address window `0x4000-0x5AFF` (ZX pixel + attributes).
- Track dirty bytes/lines.
- Blit only dirty areas to Iskra display.

If full write trapping is too expensive, use block-end diffing of the screen window as a fallback.

## Relocation of calls, jumps, and memory references

If guest is not loaded at its original expected addresses, you need address translation.

Two practical models:

1. Identity guest map (recommended first)
- Reserve a RAM window where guest sees original ZX addresses.
- Keep opcode immediates unchanged.
- Translate only host-side peripherals (screen, keyboard, ROM hooks).

2. Relocated guest map
- Maintain `delta = host_base - guest_base`.
- Rewrite immediate absolute operands at JIT compile time:
  - `JP nn`, `CALL nn`, conditional forms
  - `LD (nn),A`, `LD A,(nn)`, `LD rr,(nn)`, `LD (nn),rr`
  - `ED` memory-indirect forms
- Keep relocation consistent for stack targets and trap-restored bytes.

Model 1 is simpler and less error-prone for initial bring-up.

## Interrupt emulation (important)

Because `RST 38h` is used by JIT and guest code executes natively, hardware interrupts must be virtualized carefully.

Recommended strategy:

1. Keep host IRQs disabled during guest execution.
2. Maintain a software interrupt scheduler (e.g. 50 Hz for Spectrum frame IRQ).
3. At safe points (each trap/block exit), check pending IRQ.
4. If IRQ is pending and guest interrupt state allows it, emulate interrupt entry:
   - push guest `PC` to guest stack
   - jump guest `PC` to vector according to emulated IM mode
5. Resume via normal JIT dispatch.

Also trap and virtualize guest interrupt-control instructions:

- `DI`, `EI`
- `IM 0/1/2`
- `RETI`, `RETN`

Do not forward these directly to host interrupt state.

## Suggested roadmap for ZX Spectrum on Partner

1. Wire guest loader + `jit_run` in `src/main.s`.
2. Add `I_IO` trap path for `IN/OUT` in `src/jitty/jit.s`.
3. Implement keyboard matrix emulation on port `0xFE`.
4. Add screen write tracking for `0x4000-0x5AFF`.
5. Add interrupt virtualization at trap boundaries.
6. Add block invalidation for self-modifying code.
7. Validate with small ROM tests, then full Spectrum ROM.

## Current limitations

- No guest loader in `main.s` yet.
- `IN/OUT` trapping path is not wired yet.
- Memory write trapping/invalidation is not implemented yet.
- Interrupt virtualization is not implemented yet.
- Timing contention/cycle-accuracy is not implemented.

---

[language.url]:   https://en.wikipedia.org/wiki/ANSI_C
[language.badge]: https://img.shields.io/badge/language-C-blue.svg

[standard.url]:   https://en.wikipedia.org/wiki/C89/
[standard.badge]: https://img.shields.io/badge/standard-C89-blue.svg

[license.url]:    https://github.com/tstih/libcpm3-z80/blob/main/LICENSE
[license.badge]:  https://img.shields.io/badge/license-MIT-blue.svg

[status.badge]:  https://img.shields.io/badge/status-development-red.svg
