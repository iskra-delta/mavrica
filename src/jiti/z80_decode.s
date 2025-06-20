        ;; decode instruction size and type based on
        ;; Z80 instruction set tables.
        ;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
        ;; 20.06.2025   tstih
        .module z80_decode

        .globl  decode

        .include "z80_consts.inc"

        .area	_CODE
        ;; -----------------------------------------------------------
        ;; decode - returns instruction type and length
        ;; -----------------------------------------------------------
        ;; input(s):
        ;;      hl ... address of instruction to decode
        ;; output(s)      
        ;;      a ... instruction type/length byte
        ;; destroys:
        ;;      flags, a, hl, de
decode:
        ld      a, (hl)
        inc     hl
        cp      #0xcb
        jr      z, is_cb
        cp      #0xed
        jr      z, is_ed
        cp      #0xdd
        jr      z, is_dd
        cp      #0xfd
        jr      z, is_fd
        ; unprefixed instruction
        ld      e, a
        ld      d, 0
        ld      hl, z80_table
        add     hl, de
        ld      a, (hl)
        ret
is_cb:
        ld      a, (hl)                 ; fetch CB opcode
        ld      e, a
        ld      d, 0
        ld      hl, z80_cb_table
        add     hl, de
        ld      a, (hl)
        ret
is_ed:
        ld      a, (hl)                 ; fetch ED opcode
        ld      e, a
        ld      d, 0
        ld      hl, z80_ed_table
        add     hl, de
        ld      a, (hl)
        ret
is_dd:
        ld      a, (hl)
        cp      #0xcb                   ; check for DD CB opcode 
        jr      z, is_ddcb
        ld      e, a
        ld      d, 0
        ld      hl, z80_dd_table
        add     hl, de
        ld      a, (hl)
        ret
is_fd:
        ld      a, (hl)
        cp      #0xcb                   ; check for FD CB opcode
        jr      z, is_fdcb
        ld      e, a
        ld      d, 0
        ld      hl, z80_fd_table
        add     hl, de
        ld      a, (hl)
        ret
is_ddcb:
        inc     hl                      ; skip displacement byte
        ld      a, (hl)                 ; CB opcode after DD CB d
        ld      e, a
        ld      d, 0
        ld      hl, z80_ddcb_table
        add     hl, de
        ld      a, (hl)
        ret
is_fdcb:
        inc     hl                      ; skip displacement byte
        ld      a, (hl)                 ; CB opcode after FD CB d
        ld      e, a
        ld      d, 0
        ld      hl, z80_fdcb_table
        add     hl, de
        ld      a, (hl)
        ret