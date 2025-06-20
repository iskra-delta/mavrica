        ;; Just in time constants to calculate instruction
        ;; length and type.
	;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
	;; 20.06.2025   tstih
        .modules z80_tables

        .globl  z80_table
        .globl  z80_ed_table 
        .globl  z80_cb_table
        .globl  z80_dd_table       
        .globl  z80_fd_table       
        .globl  z80_ddcb_table
        .globl  z80_fdcb_table

        .include "z80_consts.inc"

        .area   _CODE
        ;; table of basic opcodes for decoding 
        ;; instruction length and type.
z80_table:
        .db     B1                      ;0x00   NOP
        .db     B3                      ;0x01   LD BC, ^
        .db     B1                      ;0x02   LD BC, (A)
        .db     B1                      ;0x03   INC BC
        .db     B1                      ;0x04   INC B
        .db     B1                      ;0x05   DEC B
        .db     B2                      ;0x06   LD B, $
        .db     B1                      ;0x07   RLCA
        .db     B1                      ;0x08   EX AF, AF'
        .db     B1                      ;0x09   ADD HL, BC
        .db     B1                      ;0x0A   LD A, (BC)
        .db     B1                      ;0x0B   DEC BC
        .db     B1                      ;0x0C   INC C
        .db     B1                      ;0x0D   DEC C
        .db     B2                      ;0x0E   LD C, $
        .db     B1                      ;0x0F   RRCA
        .db     B2                      ;0x10   !!!!! DJNZ %
        .db     B3                      ;0x11   LD DE, ^
        .db     B1                      ;0x12   LD (DE), A
        .db     B1                      ;0x13   INC DE
        .db     B1                      ;0x14   INC D
        .db     B1                      ;0x15   DEC D
        .db     B2                      ;0x16   LD D, $
        .db     B1                      ;0x17   RLA
        .db     B2 + I_JR               ;0x18   JR %
        .db     B1                      ;0x19   ADD HL, DE
        .db     B1                      ;0x1A   LD A, (DE)
        .db     B1                      ;0x1B   DEC DE
        .db     B1                      ;0x1C   INC E
        .db     B1                      ;0x1D   DEC E
        .db     B2                      ;0x1E   LD E, $
        .db     B1                      ;0x1F   RRA
        .db     B2 + I_JRCC             ;0x20   JR NZ, %
        .db     B3                      ;0x21   LD HL, ^
        .db     B3                      ;0x22   LD (^), HL
        .db     B1                      ;0x23   INC HL
        .db     B1                      ;0x24   INC H
        .db     B1                      ;0x25   DEC H
        .db     B2                      ;0x26   LD H, $
        .db     B1                      ;0x27   DAA
        .db     B2 + I_JRCC             ;0x28   JR Z, %
        .db     B1                      ;0x29   ADD HL, HL
        .db     B3                      ;0x2A   LD HL, (^)
        .db     B1                      ;0x2B   DEC HL
        .db     B1                      ;0x2C   INC L
        .db     B1                      ;0x2D   DEC L
        .db     B2                      ;0x2E   LD L, $
        .db     B1                      ;0x2F   CPL
        .db     B2 + I_JRCC             ;0x30   JR NC, %
        .db     B3                      ;0x31   LD SP, ^
        .db     B3                      ;0x32   LD (^), A
        .db     B1                      ;0x33   INC SP
        .db     B1                      ;0x34   INC (HL)
        .db     B1                      ;0x35   DEC (HL)
        .db     B2                      ;0x36   LD (HL), $
        .db     B1                      ;0x37   SCF
        .db     B2 + I_JRCC             ;0x38   JR C, %
        .db     B1                      ;0x39   ADD HL, SP
        .db     B3                      ;0x3A   LD A, (^)
        .db     B1                      ;0x3B   DEC SP
        .db     B1                      ;0x3C   INC A
        .db     B1                      ;0x3D   DEC A
        .db     B2                      ;0x3E   LD A, $
        .db     B1                      ;0x3F   CCF
        .db     B1                      ;0x40   LD B, B
        .db     B1                      ;0x41   LD B, C
        .db     B1                      ;0x42   LD B, D
        .db     B1                      ;0x43   LD B, E
        .db     B1                      ;0x44   LD B, H
        .db     B1                      ;0x45   LD B, L
        .db     B1                      ;0x46   LD B, (HL)
        .db     B1                      ;0x47   LD B, A
        .db     B1                      ;0x48   LD C, B
        .db     B1                      ;0x49   LD C, C
        .db     B1                      ;0x4A   LD C, D
        .db     B1                      ;0x4B   LD C, E
        .db     B1                      ;0x4C   LD C, H
        .db     B1                      ;0x4D   LD C, L
        .db     B1                      ;0x4E   LD C, (HL)
        .db     B1                      ;0x4F   LD C, A
        .db     B1                      ;0x50   LD D, B
        .db     B1                      ;0x51   LD D, C
        .db     B1                      ;0x52   LD D, D
        .db     B1                      ;0x53   LD D, E
        .db     B1                      ;0x54   LD D, H
        .db     B1                      ;0x55   LD D, L
        .db     B1                      ;0x56   LD D, (HL)
        .db     B1                      ;0x57   LD D, A
        .db     B1                      ;0x58   LD E, B
        .db     B1                      ;0x59   LD E, C
        .db     B1                      ;0x5A   LD E, D
        .db     B1                      ;0x5B   LD E, E
        .db     B1                      ;0x5C   LD E, H
        .db     B1                      ;0x5D   LD E, L
        .db     B1                      ;0x5E   LD E, (HL)
        .db     B1                      ;0x5F   LD E, A
        .db     B1                      ;0x60   LD H, B
        .db     B1                      ;0x61   LD H, C
        .db     B1                      ;0x62   LD H, D
        .db     B1                      ;0x63   LD H, E
        .db     B1                      ;0x64   LD H, H
        .db     B1                      ;0x65   LD H, L
        .db     B1                      ;0x66   LD H, (HL)
        .db     B1                      ;0x67   LD H, A
        .db     B1                      ;0x68   LD L, B
        .db     B1                      ;0x69   LD L, C
        .db     B1                      ;0x6A   LD L, D
        .db     B1                      ;0x6B   LD L, E
        .db     B1                      ;0x6C   LD L, H
        .db     B1                      ;0x6D   LD L, L
        .db     B1                      ;0x6E   LD L, (HL)
        .db     B1                      ;0x6F   LD L, A
        .db     B1                      ;0x70   LD (HL), B
        .db     B1                      ;0x71   LD (HL), C
        .db     B1                      ;0x72   LD (HL), D
        .db     B1                      ;0x73   LD (HL), E
        .db     B1                      ;0x74   LD (HL), H
        .db     B1                      ;0x75   LD (HL), L
        .db     B1                      ;0x76   HALT
        .db     B1                      ;0x77   LD (HL), A
        .db     B1                      ;0x78   LD A, B
        .db     B1                      ;0x79   LD A, C
        .db     B1                      ;0x7A   LD A, D
        .db     B1                      ;0x7B   LD A, E
        .db     B1                      ;0x7C   LD A, H
        .db     B1                      ;0x7D   LD A, L
        .db     B1                      ;0x7E   LD A, (HL)
        .db     B1                      ;0x7F   LD A, A
        .db     B1                      ;0x80   ADD A, B
        .db     B1                      ;0x81   ADD A, C
        .db     B1                      ;0x82   ADD A, D
        .db     B1                      ;0x83   ADD A, E
        .db     B1                      ;0x84   ADD A, H
        .db     B1                      ;0x85   ADD A, L
        .db     B1                      ;0x86   ADD A, (HL)
        .db     B1                      ;0x87   ADD A, A
        .db     B1                      ;0x88   ADC A, B
        .db     B1                      ;0x89   ADC A, C
        .db     B1                      ;0x8A   ADC A, D
        .db     B1                      ;0x8B   ADC A, E
        .db     B1                      ;0x8C   ADC A, H
        .db     B1                      ;0x8D   ADC A, L
        .db     B1                      ;0x8E   ADC A, (HL)
        .db     B1                      ;0x8F   ADC A, A
        .db     B1                      ;0x90   SUB A, B
        .db     B1                      ;0x91   SUB A, C
        .db     B1                      ;0x92   SUB A, D
        .db     B1                      ;0x93   SUB A, E
        .db     B1                      ;0x94   SUB A, H
        .db     B1                      ;0x95   SUB A, L
        .db     B1                      ;0x96   SUB A, (HL)
        .db     B1                      ;0x97   SUB A, A
        .db     B1                      ;0x98   SBC A, B
        .db     B1                      ;0x99   SBC A, C
        .db     B1                      ;0x9A   SBC A, D
        .db     B1                      ;0x9B   SBC A, E
        .db     B1                      ;0x9C   SBC A, H
        .db     B1                      ;0x9D   SBC A, L
        .db     B1                      ;0x9E   SBC A, (HL)
        .db     B1                      ;0x9F   SBC A, A
        .db     B1                      ;0xA0   AND A, B
        .db     B1                      ;0xA1   AND A, C
        .db     B1                      ;0xA2   AND A, D
        .db     B1                      ;0xA3   AND A, E
        .db     B1                      ;0xA4   AND A, H
        .db     B1                      ;0xA5   AND A, L
        .db     B1                      ;0xA6   AND A, (HL)
        .db     B1                      ;0xA7   AND A, A
        .db     B1                      ;0xA8   XOR A, B
        .db     B1                      ;0xA9   XOR A, C
        .db     B1                      ;0xAA   XOR A, D
        .db     B1                      ;0xAB   XOR A, E
        .db     B1                      ;0xAC   XOR A, H
        .db     B1                      ;0xAD   XOR A, L
        .db     B1                      ;0xAE   XOR A, (HL)
        .db     B1                      ;0xAF   XOR A, A
        .db     B1                      ;0xB0   OR A, B
        .db     B1                      ;0xB1   OR A, C
        .db     B1                      ;0xB2   OR A, D
        .db     B1                      ;0xB3   OR A, E
        .db     B1                      ;0xB4   OR A, H
        .db     B1                      ;0xB5   OR A, L
        .db     B1                      ;0xB6   OR A, (HL)
        .db     B1                      ;0xB7   OR A, A
        .db     B1                      ;0xB8   CP B
        .db     B1                      ;0xB9   CP C
        .db     B1                      ;0xBA   CP D
        .db     B1                      ;0xBB   CP E
        .db     B1                      ;0xBC   CP H
        .db     B1                      ;0xBD   CP L
        .db     B1                      ;0xBE   CP (HL)
        .db     B1                      ;0xBF   CP A
        .db     B1 + I_RETCC            ;0xC0   RET NZ
        .db     B1                      ;0xC1   POP BC
        .db     B3 + I_JPCC             ;0xC2   JP NZ, ^
        .db     B3 + I_JP               ;0xC3   JP ^
        .db     B3 + I_CALLCC           ;0xC4   CALL NZ, ^
        .db     B1                      ;0xC5   PUSH BC
        .db     B2                      ;0xC6   ADD A, $
        .db     B1 + I_RST              ;0xC7   RST 00
        .db     B1 + I_RETCC            ;0xC8   RET Z
        .db     B1 + I_RET              ;0xC9   RET
        .db     B3 + I_JPCC             ;0xCA   JP Z, ^
        .db     B0 + I_CB               ;0xCB   00
        .db     B3 + I_CALLCC           ;0xCC   CALL Z, ^
        .db     B3 + I_CALL             ;0xCD   CALL ^
        .db     B2                      ;0xCE   ADC A, $
        .db     B1 + I_RST              ;0xCF   RST 08
        .db     B1 + I_RETCC            ;0xD0   RET NC
        .db     B1                      ;0xD1   POP DE
        .db     B3 + I_JPCC             ;0xD2   JP NC, ^
        .db     B2                      ;0xD3   OUT ($), A
        .db     B3 + I_CALLCC           ;0xD4   CALL NC, ^
        .db     B1                      ;0xD5   PUSH DE
        .db     B2                      ;0xD6   SUB $
        .db     B1 + I_RST              ;0xD7   RST 10
        .db     B1 + I_RETCC            ;0xD8   RET C
        .db     B1                      ;0xD9   EXX
        .db     B3 + I_JPCC             ;0xDA   JP C, ^
        .db     B2                      ;0xDB   IN A, ($)
        .db     B3 + I_CALLCC           ;0xDC   CALL C, ^
        .db     B0 + I_DD               ;0xDD   00
        .db     B2                      ;0xDE   SBC A, $
        .db     B1 + I_RST              ;0xDF   RST 18
        .db     B1 + I_RETCC            ;0xE0   RET PO
        .db     B1                      ;0xE1   POP HL
        .db     B3 + I_JPCC             ;0xE2   JP PO, ^
        .db     B1                      ;0xE3   EX (SP), HL
        .db     B3 + I_CALLCC           ;0xE4   CALL PO, ^
        .db     B1                      ;0xE5   PUSH HL
        .db     B2                      ;0xE6   AND $
        .db     B1 + I_RST              ;0xE7   RST 20
        .db     B1 + I_RETCC            ;0xE8   RET PE
        .db     B1 + I_JPRR             ;0xE9   JP HL
        .db     B3 + I_JPCC             ;0xEA   JP PE, ^
        .db     B1                      ;0xEB   EX DE, HL
        .db     B3 + I_CALLCC           ;0xEC   CALL PE, ^
        .db     B0 + I_ED               ;0xED   00
        .db     B2                      ;0xEE   XOR $
        .db     B1 + I_RST              ;0xEF   RST 28
        .db     B1 + I_RETCC            ;0xF0   RET P
        .db     B1                      ;0xF1   POP AF
        .db     B3 + I_JPCC             ;0xF2   JP P, ^
        .db     B1                      ;0xF3   DI
        .db     B3 + I_CALLCC           ;0xF4   CALL P, ^
        .db     B1                      ;0xF5   PUSH AF
        .db     B2                      ;0xF6   OR $
        .db     B1 + I_RST              ;0xF7   RST 30
        .db     B1 + I_RETCC            ;0xF8   RET M
        .db     B1                      ;0xF9   LD SP, HL
        .db     B3 + I_JPCC             ;0xFA   JP M, ^
        .db     B1                      ;0xFB   EI
        .db     B3 + I_CALLCC           ;0xFC   CALL M, ^
        .db     B0 + I_FD               ;0xFD   FDOP
        .db     B2                      ;0xFE   CP $
        .db     B1 + I_RST              ;0xFF   RST 38



        ;;  1. 0xED instructions
z80_ed_table: 
        .db     B1 + I_UNDOCUMENTED      ; 0x00   ED 00h
        .db     B1 + I_UNDOCUMENTED      ; 0x01   ED 01h
        .db     B1 + I_UNDOCUMENTED      ; 0x02   ED 02h
        .db     B1 + I_UNDOCUMENTED      ; 0x03   ED 03h
        .db     B1 + I_UNDOCUMENTED      ; 0x04   ED 04h
        .db     B1 + I_UNDOCUMENTED      ; 0x05   ED 05h
        .db     B1 + I_UNDOCUMENTED      ; 0x06   ED 06h
        .db     B1 + I_UNDOCUMENTED      ; 0x07   ED 07h
        .db     B1 + I_UNDOCUMENTED      ; 0x08   ED 08h
        .db     B1 + I_UNDOCUMENTED      ; 0x09   ED 09h
        .db     B1 + I_UNDOCUMENTED      ; 0x0A   ED 0Ah
        .db     B1 + I_UNDOCUMENTED      ; 0x0B   ED 0Bh
        .db     B1 + I_UNDOCUMENTED      ; 0x0C   ED 0Ch
        .db     B1 + I_UNDOCUMENTED      ; 0x0D   ED 0Dh
        .db     B1 + I_UNDOCUMENTED      ; 0x0E   ED 0Eh
        .db     B1 + I_UNDOCUMENTED      ; 0x0F   ED 0Fh
        .db     B1 + I_UNDOCUMENTED      ; 0x10   ED 10h
        .db     B1 + I_UNDOCUMENTED      ; 0x11   ED 11h
        .db     B1 + I_UNDOCUMENTED      ; 0x12   ED 12h
        .db     B1 + I_UNDOCUMENTED      ; 0x13   ED 13h
        .db     B1 + I_UNDOCUMENTED      ; 0x14   ED 14h
        .db     B1 + I_UNDOCUMENTED      ; 0x15   ED 15h
        .db     B1 + I_UNDOCUMENTED      ; 0x16   ED 16h
        .db     B1 + I_UNDOCUMENTED      ; 0x17   ED 17h
        .db     B1 + I_UNDOCUMENTED      ; 0x18   ED 18h
        .db     B1 + I_UNDOCUMENTED      ; 0x19   ED 19h
        .db     B1 + I_UNDOCUMENTED      ; 0x1A   ED 1Ah
        .db     B1 + I_UNDOCUMENTED      ; 0x1B   ED 1Bh
        .db     B1 + I_UNDOCUMENTED      ; 0x1C   ED 1Ch
        .db     B1 + I_UNDOCUMENTED      ; 0x1D   ED 1Dh
        .db     B1 + I_UNDOCUMENTED      ; 0x1E   ED 1Eh
        .db     B1 + I_UNDOCUMENTED      ; 0x1F   ED 1Fh
        .db     B1 + I_UNDOCUMENTED      ; 0x20   ED 20h
        .db     B1 + I_UNDOCUMENTED      ; 0x21   ED 21h
        .db     B1 + I_UNDOCUMENTED      ; 0x22   ED 22h
        .db     B1 + I_UNDOCUMENTED      ; 0x23   ED 23h
        .db     B1 + I_UNDOCUMENTED      ; 0x24   ED 24h
        .db     B1 + I_UNDOCUMENTED      ; 0x25   ED 25h
        .db     B1 + I_UNDOCUMENTED      ; 0x26   ED 26h
        .db     B1 + I_UNDOCUMENTED      ; 0x27   ED 27h
        .db     B1 + I_UNDOCUMENTED      ; 0x28   ED 28h
        .db     B1 + I_UNDOCUMENTED      ; 0x29   ED 29h
        .db     B1 + I_UNDOCUMENTED      ; 0x2A   ED 2Ah
        .db     B1 + I_UNDOCUMENTED      ; 0x2B   ED 2Bh
        .db     B1 + I_UNDOCUMENTED      ; 0x2C   ED 2Ch
        .db     B1 + I_UNDOCUMENTED      ; 0x2D   ED 2Dh
        .db     B1 + I_UNDOCUMENTED      ; 0x2E   ED 2Eh
        .db     B1 + I_UNDOCUMENTED      ; 0x2F   ED 2Fh
        .db     B1 + I_UNDOCUMENTED      ; 0x30   ED 30h
        .db     B1 + I_UNDOCUMENTED      ; 0x31   ED 31h
        .db     B1 + I_UNDOCUMENTED      ; 0x32   ED 32h
        .db     B1 + I_UNDOCUMENTED      ; 0x33   ED 33h
        .db     B1 + I_UNDOCUMENTED      ; 0x34   ED 34h
        .db     B1 + I_UNDOCUMENTED      ; 0x35   ED 35h
        .db     B1 + I_UNDOCUMENTED      ; 0x36   ED 36h
        .db     B1 + I_UNDOCUMENTED      ; 0x37   ED 37h
        .db     B1 + I_UNDOCUMENTED      ; 0x38   ED 38h
        .db     B1 + I_UNDOCUMENTED      ; 0x39   ED 39h
        .db     B1 + I_UNDOCUMENTED      ; 0x3A   ED 3Ah
        .db     B1 + I_UNDOCUMENTED      ; 0x3B   ED 3Bh
        .db     B1 + I_UNDOCUMENTED      ; 0x3C   ED 3Ch
        .db     B1 + I_UNDOCUMENTED      ; 0x3D   ED 3Dh
        .db     B1 + I_UNDOCUMENTED      ; 0x3E   ED 3Eh
        .db     B1 + I_UNDOCUMENTED      ; 0x3F   ED 3Fh
        .db     B1 + I_IO                ; 0x40   IN B, C
        .db     B1 + I_IO                ; 0x41   OUT C, B
        .db     B1                       ; 0x42   SBC HL, BC
        .db     B4 + I_MEMIND            ; 0x43   LD (nn), BC
        .db     B1                       ; 0x44   NEG
        .db     B1 + I_RET               ; 0x45   RETN
        .db     B1                       ; 0x46   IM 0
        .db     B1                       ; 0x47   LD I, A
        .db     B1 + I_IO                ; 0x48   IN C, C
        .db     B1 + I_IO                ; 0x49   OUT C, C
        .db     B1                       ; 0x4A   ADC HL, BC
        .db     B4 + I_MEMIND            ; 0x4B   LD BC, (nn)
        .db     B1                       ; 0x4C   NEG
        .db     B1 + I_RET               ; 0x4D   RETI
        .db     B1                       ; 0x4E   IM 0
        .db     B1                       ; 0x4F   LD R, A
        .db     B1 + I_UNDOCUMENTED      ; 0x50   ED 50h
        .db     B1 + I_UNDOCUMENTED      ; 0x51   ED 51h
        .db     B1 + I_UNDOCUMENTED      ; 0x52   ED 52h
        .db     B4 + I_MEMIND            ; 0x53   LD (nn), xx
        .db     B1 + I_UNDOCUMENTED      ; 0x54   ED 54h
        .db     B1 + I_UNDOCUMENTED      ; 0x55   ED 55h
        .db     B1 + I_UNDOCUMENTED      ; 0x56   ED 56h
        .db     B1                       ; 0x57   LD A, I
        .db     B1 + I_UNDOCUMENTED      ; 0x58   ED 58h
        .db     B1 + I_UNDOCUMENTED      ; 0x59   ED 59h
        .db     B1 + I_UNDOCUMENTED      ; 0x5A   ED 5Ah
        .db     B4 + I_MEMIND            ; 0x5B   LD (nn), xx
        .db     B1 + I_UNDOCUMENTED      ; 0x5C   ED 5Ch
        .db     B1 + I_UNDOCUMENTED      ; 0x5D   ED 5Dh
        .db     B1 + I_UNDOCUMENTED      ; 0x5E   ED 5Eh
        .db     B1                       ; 0x5F   LD A, R
        .db     B1 + I_UNDOCUMENTED      ; 0x60   ED 60h
        .db     B1 + I_UNDOCUMENTED      ; 0x61   ED 61h
        .db     B1 + I_UNDOCUMENTED      ; 0x62   ED 62h
        .db     B4 + I_MEMIND            ; 0x63   LD (nn), xx
        .db     B1 + I_UNDOCUMENTED      ; 0x64   ED 64h
        .db     B1 + I_UNDOCUMENTED      ; 0x65   ED 65h
        .db     B1 + I_UNDOCUMENTED      ; 0x66   ED 66h
        .db     B1                       ; 0x67   RRD
        .db     B1 + I_UNDOCUMENTED      ; 0x68   ED 68h
        .db     B1 + I_UNDOCUMENTED      ; 0x69   ED 69h
        .db     B1 + I_UNDOCUMENTED      ; 0x6A   ED 6Ah
        .db     B4 + I_MEMIND            ; 0x6B   LD (nn), xx
        .db     B1 + I_UNDOCUMENTED      ; 0x6C   ED 6Ch
        .db     B1 + I_UNDOCUMENTED      ; 0x6D   ED 6Dh
        .db     B1 + I_UNDOCUMENTED      ; 0x6E   ED 6Eh
        .db     B1                       ; 0x6F   RLD
        .db     B1 + I_UNDOCUMENTED      ; 0x70   ED 70h
        .db     B1 + I_UNDOCUMENTED      ; 0x71   ED 71h
        .db     B1 + I_UNDOCUMENTED      ; 0x72   ED 72h
        .db     B4 + I_MEMIND            ; 0x73   LD (nn), xx
        .db     B1 + I_UNDOCUMENTED      ; 0x74   ED 74h
        .db     B1 + I_UNDOCUMENTED      ; 0x75   ED 75h
        .db     B1 + I_UNDOCUMENTED      ; 0x76   ED 76h
        .db     B1 + I_UNDOCUMENTED      ; 0x77   ED 77h
        .db     B1 + I_UNDOCUMENTED      ; 0x78   ED 78h
        .db     B1 + I_UNDOCUMENTED      ; 0x79   ED 79h
        .db     B1 + I_UNDOCUMENTED      ; 0x7A   ED 7Ah
        .db     B4 + I_MEMIND            ; 0x7B   LD (nn), xx
        .db     B1 + I_UNDOCUMENTED      ; 0x7C   ED 7Ch
        .db     B1 + I_UNDOCUMENTED      ; 0x7D   ED 7Dh
        .db     B1 + I_UNDOCUMENTED      ; 0x7E   ED 7Eh
        .db     B1 + I_UNDOCUMENTED      ; 0x7F   ED 7Fh
        .db     B1 + I_UNDOCUMENTED      ; 0x80   ED 80h
        .db     B1 + I_UNDOCUMENTED      ; 0x81   ED 81h
        .db     B1 + I_UNDOCUMENTED      ; 0x82   ED 82h
        .db     B1 + I_UNDOCUMENTED      ; 0x83   ED 83h
        .db     B1 + I_UNDOCUMENTED      ; 0x84   ED 84h
        .db     B1 + I_UNDOCUMENTED      ; 0x85   ED 85h
        .db     B1 + I_UNDOCUMENTED      ; 0x86   ED 86h
        .db     B1 + I_UNDOCUMENTED      ; 0x87   ED 87h
        .db     B1 + I_UNDOCUMENTED      ; 0x88   ED 88h
        .db     B1 + I_UNDOCUMENTED      ; 0x89   ED 89h
        .db     B1 + I_UNDOCUMENTED      ; 0x8A   ED 8Ah
        .db     B1 + I_UNDOCUMENTED      ; 0x8B   ED 8Bh
        .db     B1 + I_UNDOCUMENTED      ; 0x8C   ED 8Ch
        .db     B1 + I_UNDOCUMENTED      ; 0x8D   ED 8Dh
        .db     B1 + I_UNDOCUMENTED      ; 0x8E   ED 8Eh
        .db     B1 + I_UNDOCUMENTED      ; 0x8F   ED 8Fh
        .db     B1 + I_UNDOCUMENTED      ; 0x90   ED 90h
        .db     B1 + I_UNDOCUMENTED      ; 0x91   ED 91h
        .db     B1 + I_UNDOCUMENTED      ; 0x92   ED 92h
        .db     B1 + I_UNDOCUMENTED      ; 0x93   ED 93h
        .db     B1 + I_UNDOCUMENTED      ; 0x94   ED 94h
        .db     B1 + I_UNDOCUMENTED      ; 0x95   ED 95h
        .db     B1 + I_UNDOCUMENTED      ; 0x96   ED 96h
        .db     B1 + I_UNDOCUMENTED      ; 0x97   ED 97h
        .db     B1 + I_UNDOCUMENTED      ; 0x98   ED 98h
        .db     B1 + I_UNDOCUMENTED      ; 0x99   ED 99h
        .db     B1 + I_UNDOCUMENTED      ; 0x9A   ED 9Ah
        .db     B1 + I_UNDOCUMENTED      ; 0x9B   ED 9Bh
        .db     B1 + I_UNDOCUMENTED      ; 0x9C   ED 9Ch
        .db     B1 + I_UNDOCUMENTED      ; 0x9D   ED 9Dh
        .db     B1 + I_UNDOCUMENTED      ; 0x9E   ED 9Eh
        .db     B1 + I_UNDOCUMENTED      ; 0x9F   ED 9Fh
        .db     B1 + I_MEMIND            ; 0xA0   LDI
        .db     B1 + I_MEMIND            ; 0xA1   CPI
        .db     B1 + I_IO                ; 0xA2   INI
        .db     B1 + I_IO                ; 0xA3   OUTI
        .db     B1 + I_UNDOCUMENTED      ; 0xA4   ED A4h
        .db     B1 + I_UNDOCUMENTED      ; 0xA5   ED A5h
        .db     B1 + I_UNDOCUMENTED      ; 0xA6   ED A6h
        .db     B1 + I_UNDOCUMENTED      ; 0xA7   ED A7h
        .db     B1 + I_MEMIND            ; 0xA8   LDD
        .db     B1 + I_MEMIND            ; 0xA9   CPD
        .db     B1 + I_IO                ; 0xAA   IND
        .db     B1 + I_IO                ; 0xAB   OUTD
        .db     B1 + I_UNDOCUMENTED      ; 0xAC   ED ACh
        .db     B1 + I_UNDOCUMENTED      ; 0xAD   ED ADh
        .db     B1 + I_UNDOCUMENTED      ; 0xAE   ED AEh
        .db     B1 + I_UNDOCUMENTED      ; 0xAF   ED AFh
        .db     B1 + I_MEMIND            ; 0xB0   LDIR
        .db     B1 + I_MEMIND            ; 0xB1   CPIR
        .db     B1 + I_IO                ; 0xB2   INIR
        .db     B1 + I_IO                ; 0xB3   OTIR
        .db     B1 + I_UNDOCUMENTED      ; 0xB4   ED B4h
        .db     B1 + I_UNDOCUMENTED      ; 0xB5   ED B5h
        .db     B1 + I_UNDOCUMENTED      ; 0xB6   ED B6h
        .db     B1 + I_UNDOCUMENTED      ; 0xB7   ED B7h
        .db     B1 + I_MEMIND            ; 0xB8   LDDR
        .db     B1 + I_MEMIND            ; 0xB9   CPDR
        .db     B1 + I_IO                ; 0xBA   INDR
        .db     B1 + I_IO                ; 0xBB   OTDR
        .db     B1 + I_UNDOCUMENTED      ; 0xBC   ED BCh
        .db     B1 + I_UNDOCUMENTED      ; 0xBD   ED BDh
        .db     B1 + I_UNDOCUMENTED      ; 0xBE   ED BEh
        .db     B1 + I_UNDOCUMENTED      ; 0xBF   ED BFh
        .db     B1 + I_UNDOCUMENTED      ; 0xC0   ED C0h
        .db     B1 + I_UNDOCUMENTED      ; 0xC1   ED C1h
        .db     B1 + I_UNDOCUMENTED      ; 0xC2   ED C2h
        .db     B1 + I_UNDOCUMENTED      ; 0xC3   ED C3h
        .db     B1 + I_UNDOCUMENTED      ; 0xC4   ED C4h
        .db     B1 + I_UNDOCUMENTED      ; 0xC5   ED C5h
        .db     B1 + I_UNDOCUMENTED      ; 0xC6   ED C6h
        .db     B1 + I_UNDOCUMENTED      ; 0xC7   ED C7h
        .db     B1 + I_UNDOCUMENTED      ; 0xC8   ED C8h
        .db     B1 + I_UNDOCUMENTED      ; 0xC9   ED C9h
        .db     B1 + I_UNDOCUMENTED      ; 0xCA   ED CAh
        .db     B1 + I_UNDOCUMENTED      ; 0xCB   ED CBh
        .db     B1 + I_UNDOCUMENTED      ; 0xCC   ED CCh
        .db     B1 + I_UNDOCUMENTED      ; 0xCD   ED CDh
        .db     B1 + I_UNDOCUMENTED      ; 0xCE   ED CEh
        .db     B1 + I_UNDOCUMENTED      ; 0xCF   ED CFh
        .db     B1 + I_UNDOCUMENTED      ; 0xD0   ED D0h
        .db     B1 + I_UNDOCUMENTED      ; 0xD1   ED D1h
        .db     B1 + I_UNDOCUMENTED      ; 0xD2   ED D2h
        .db     B2 + I_IO                ; 0xD3   OUT (n), A
        .db     B1 + I_UNDOCUMENTED      ; 0xD4   ED D4h
        .db     B1 + I_UNDOCUMENTED      ; 0xD5   ED D5h
        .db     B1 + I_UNDOCUMENTED      ; 0xD6   ED D6h
        .db     B1 + I_UNDOCUMENTED      ; 0xD7   ED D7h
        .db     B1 + I_UNDOCUMENTED      ; 0xD8   ED D8h
        .db     B1 + I_UNDOCUMENTED      ; 0xD9   ED D9h
        .db     B1 + I_UNDOCUMENTED      ; 0xDA   ED DAh
        .db     B2 + I_IO                ; 0xDB   IN A, (n)
        .db     B1 + I_UNDOCUMENTED      ; 0xDC   ED DCh
        .db     B1 + I_UNDOCUMENTED      ; 0xDD   ED DDh
        .db     B1 + I_UNDOCUMENTED      ; 0xDE   ED DEh
        .db     B1 + I_UNDOCUMENTED      ; 0xDF   ED DFh
        .db     B1 + I_UNDOCUMENTED      ; 0xE0   ED E0h
        .db     B1 + I_UNDOCUMENTED      ; 0xE1   ED E1h
        .db     B1 + I_UNDOCUMENTED      ; 0xE2   ED E2h
        .db     B1 + I_UNDOCUMENTED      ; 0xE3   ED E3h
        .db     B1 + I_UNDOCUMENTED      ; 0xE4   ED E4h
        .db     B1 + I_UNDOCUMENTED      ; 0xE5   ED E5h
        .db     B1 + I_UNDOCUMENTED      ; 0xE6   ED E6h
        .db     B1 + I_UNDOCUMENTED      ; 0xE7   ED E7h
        .db     B1 + I_UNDOCUMENTED      ; 0xE8   ED E8h
        .db     B1 + I_UNDOCUMENTED      ; 0xE9   ED E9h
        .db     B1 + I_UNDOCUMENTED      ; 0xEA   ED EAh
        .db     B1 + I_UNDOCUMENTED      ; 0xEB   ED EBh
        .db     B1 + I_UNDOCUMENTED      ; 0xEC   ED ECh
        .db     B1 + I_UNDOCUMENTED      ; 0xED   ED EDh
        .db     B1 + I_UNDOCUMENTED      ; 0xEE   ED EEh
        .db     B1 + I_UNDOCUMENTED      ; 0xEF   ED EFh
        .db     B1 + I_UNDOCUMENTED      ; 0xF0   ED F0h
        .db     B1 + I_UNDOCUMENTED      ; 0xF1   ED F1h
        .db     B1 + I_UNDOCUMENTED      ; 0xF2   ED F2h
        .db     B1 + I_UNDOCUMENTED      ; 0xF3   ED F3h
        .db     B1 + I_UNDOCUMENTED      ; 0xF4   ED F4h
        .db     B1 + I_UNDOCUMENTED      ; 0xF5   ED F5h
        .db     B1 + I_UNDOCUMENTED      ; 0xF6   ED F6h
        .db     B1 + I_UNDOCUMENTED      ; 0xF7   ED F7h
        .db     B1 + I_UNDOCUMENTED      ; 0xF8   ED F8h
        .db     B1 + I_UNDOCUMENTED      ; 0xF9   ED F9h
        .db     B1 + I_UNDOCUMENTED      ; 0xFA   ED FAh
        .db     B1 + I_UNDOCUMENTED      ; 0xFB   ED FBh
        .db     B1 + I_UNDOCUMENTED      ; 0xFC   ED FCh
        .db     B1 + I_UNDOCUMENTED      ; 0xFD   ED FDh
        .db     B1 + I_UNDOCUMENTED      ; 0xFE   ED FEh
        .db     B1 + I_UNDOCUMENTED      ; 0xFF   ED FFh



        ;;  2. 0xCB instructions
z80_cb_table: 
        .db     B2                     ; 0x00   RLC B
        .db     B2                     ; 0x01   RLC C
        .db     B2                     ; 0x02   RLC D
        .db     B2                     ; 0x03   RLC E
        .db     B2                     ; 0x04   RLC H
        .db     B2                     ; 0x05   RLC L
        .db     B2                     ; 0x06   RLC (HL)
        .db     B2                     ; 0x07   RLC A
        .db     B2                     ; 0x08   RRC B
        .db     B2                     ; 0x09   RRC C
        .db     B2                     ; 0x0A   RRC D
        .db     B2                     ; 0x0B   RRC E
        .db     B2                     ; 0x0C   RRC H
        .db     B2                     ; 0x0D   RRC L
        .db     B2                     ; 0x0E   RRC (HL)
        .db     B2                     ; 0x0F   RRC A
        .db     B2                     ; 0x10   RL B
        .db     B2                     ; 0x11   RL C
        .db     B2                     ; 0x12   RL D
        .db     B2                     ; 0x13   RL E
        .db     B2                     ; 0x14   RL H
        .db     B2                     ; 0x15   RL L
        .db     B2                     ; 0x16   RL (HL)
        .db     B2                     ; 0x17   RL A
        .db     B2                     ; 0x18   RR B
        .db     B2                     ; 0x19   RR C
        .db     B2                     ; 0x1A   RR D
        .db     B2                     ; 0x1B   RR E
        .db     B2                     ; 0x1C   RR H
        .db     B2                     ; 0x1D   RR L
        .db     B2                     ; 0x1E   RR (HL)
        .db     B2                     ; 0x1F   RR A
        .db     B2                     ; 0x20   SLA B
        .db     B2                     ; 0x21   SLA C
        .db     B2                     ; 0x22   SLA D
        .db     B2                     ; 0x23   SLA E
        .db     B2                     ; 0x24   SLA H
        .db     B2                     ; 0x25   SLA L
        .db     B2                     ; 0x26   SLA (HL)
        .db     B2                     ; 0x27   SLA A
        .db     B2                     ; 0x28   SRA B
        .db     B2                     ; 0x29   SRA C
        .db     B2                     ; 0x2A   SRA D
        .db     B2                     ; 0x2B   SRA E
        .db     B2                     ; 0x2C   SRA H
        .db     B2                     ; 0x2D   SRA L
        .db     B2                     ; 0x2E   SRA (HL)
        .db     B2                     ; 0x2F   SRA A
        .db     B2                     ; 0x30   SLL B
        .db     B2                     ; 0x31   SLL C
        .db     B2                     ; 0x32   SLL D
        .db     B2                     ; 0x33   SLL E
        .db     B2                     ; 0x34   SLL H
        .db     B2                     ; 0x35   SLL L
        .db     B2                     ; 0x36   SLL (HL)
        .db     B2                     ; 0x37   SLL A
        .db     B2                     ; 0x38   SRL B
        .db     B2                     ; 0x39   SRL C
        .db     B2                     ; 0x3A   SRL D
        .db     B2                     ; 0x3B   SRL E
        .db     B2                     ; 0x3C   SRL H
        .db     B2                     ; 0x3D   SRL L
        .db     B2                     ; 0x3E   SRL (HL)
        .db     B2                     ; 0x3F   SRL A
        .db     B2                     ; 0x40   RL 0, B
        .db     B2                     ; 0x41   RL 0, C
        .db     B2                     ; 0x42   RL 0, D
        .db     B2                     ; 0x43   RL 0, E
        .db     B2                     ; 0x44   RL 0, H
        .db     B2                     ; 0x45   RL 0, L
        .db     B2                     ; 0x46   RL 0, (HL)
        .db     B2                     ; 0x47   RL 0, A
        .db     B2                     ; 0x48   RL 1, B
        .db     B2                     ; 0x49   RL 1, C
        .db     B2                     ; 0x4A   RL 1, D
        .db     B2                     ; 0x4B   RL 1, E
        .db     B2                     ; 0x4C   RL 1, H
        .db     B2                     ; 0x4D   RL 1, L
        .db     B2                     ; 0x4E   RL 1, (HL)
        .db     B2                     ; 0x4F   RL 1, A
        .db     B2                     ; 0x50   RL 2, B
        .db     B2                     ; 0x51   RL 2, C
        .db     B2                     ; 0x52   RL 2, D
        .db     B2                     ; 0x53   RL 2, E
        .db     B2                     ; 0x54   RL 2, H
        .db     B2                     ; 0x55   RL 2, L
        .db     B2                     ; 0x56   RL 2, (HL)
        .db     B2                     ; 0x57   RL 2, A
        .db     B2                     ; 0x58   RL 3, B
        .db     B2                     ; 0x59   RL 3, C
        .db     B2                     ; 0x5A   RL 3, D
        .db     B2                     ; 0x5B   RL 3, E
        .db     B2                     ; 0x5C   RL 3, H
        .db     B2                     ; 0x5D   RL 3, L
        .db     B2                     ; 0x5E   RL 3, (HL)
        .db     B2                     ; 0x5F   RL 3, A
        .db     B2                     ; 0x60   RL 4, B
        .db     B2                     ; 0x61   RL 4, C
        .db     B2                     ; 0x62   RL 4, D
        .db     B2                     ; 0x63   RL 4, E
        .db     B2                     ; 0x64   RL 4, H
        .db     B2                     ; 0x65   RL 4, L
        .db     B2                     ; 0x66   RL 4, (HL)
        .db     B2                     ; 0x67   RL 4, A
        .db     B2                     ; 0x68   RL 5, B
        .db     B2                     ; 0x69   RL 5, C
        .db     B2                     ; 0x6A   RL 5, D
        .db     B2                     ; 0x6B   RL 5, E
        .db     B2                     ; 0x6C   RL 5, H
        .db     B2                     ; 0x6D   RL 5, L
        .db     B2                     ; 0x6E   RL 5, (HL)
        .db     B2                     ; 0x6F   RL 5, A
        .db     B2                     ; 0x70   RL 6, B
        .db     B2                     ; 0x71   RL 6, C
        .db     B2                     ; 0x72   RL 6, D
        .db     B2                     ; 0x73   RL 6, E
        .db     B2                     ; 0x74   RL 6, H
        .db     B2                     ; 0x75   RL 6, L
        .db     B2                     ; 0x76   RL 6, (HL)
        .db     B2                     ; 0x77   RL 6, A
        .db     B2                     ; 0x78   RL 7, B
        .db     B2                     ; 0x79   RL 7, C
        .db     B2                     ; 0x7A   RL 7, D
        .db     B2                     ; 0x7B   RL 7, E
        .db     B2                     ; 0x7C   RL 7, H
        .db     B2                     ; 0x7D   RL 7, L
        .db     B2                     ; 0x7E   RL 7, (HL)
        .db     B2                     ; 0x7F   RL 7, A
        .db     B2                     ; 0x80   RR 0, B
        .db     B2                     ; 0x81   RR 0, C
        .db     B2                     ; 0x82   RR 0, D
        .db     B2                     ; 0x83   RR 0, E
        .db     B2                     ; 0x84   RR 0, H
        .db     B2                     ; 0x85   RR 0, L
        .db     B2                     ; 0x86   RR 0, (HL)
        .db     B2                     ; 0x87   RR 0, A
        .db     B2                     ; 0x88   RR 1, B
        .db     B2                     ; 0x89   RR 1, C
        .db     B2                     ; 0x8A   RR 1, D
        .db     B2                     ; 0x8B   RR 1, E
        .db     B2                     ; 0x8C   RR 1, H
        .db     B2                     ; 0x8D   RR 1, L
        .db     B2                     ; 0x8E   RR 1, (HL)
        .db     B2                     ; 0x8F   RR 1, A
        .db     B2                     ; 0x90   RR 2, B
        .db     B2                     ; 0x91   RR 2, C
        .db     B2                     ; 0x92   RR 2, D
        .db     B2                     ; 0x93   RR 2, E
        .db     B2                     ; 0x94   RR 2, H
        .db     B2                     ; 0x95   RR 2, L
        .db     B2                     ; 0x96   RR 2, (HL)
        .db     B2                     ; 0x97   RR 2, A
        .db     B2                     ; 0x98   RR 3, B
        .db     B2                     ; 0x99   RR 3, C
        .db     B2                     ; 0x9A   RR 3, D
        .db     B2                     ; 0x9B   RR 3, E
        .db     B2                     ; 0x9C   RR 3, H
        .db     B2                     ; 0x9D   RR 3, L
        .db     B2                     ; 0x9E   RR 3, (HL)
        .db     B2                     ; 0x9F   RR 3, A
        .db     B2                     ; 0xA0   RR 4, B
        .db     B2                     ; 0xA1   RR 4, C
        .db     B2                     ; 0xA2   RR 4, D
        .db     B2                     ; 0xA3   RR 4, E
        .db     B2                     ; 0xA4   RR 4, H
        .db     B2                     ; 0xA5   RR 4, L
        .db     B2                     ; 0xA6   RR 4, (HL)
        .db     B2                     ; 0xA7   RR 4, A
        .db     B2                     ; 0xA8   RR 5, B
        .db     B2                     ; 0xA9   RR 5, C
        .db     B2                     ; 0xAA   RR 5, D
        .db     B2                     ; 0xAB   RR 5, E
        .db     B2                     ; 0xAC   RR 5, H
        .db     B2                     ; 0xAD   RR 5, L
        .db     B2                     ; 0xAE   RR 5, (HL)
        .db     B2                     ; 0xAF   RR 5, A
        .db     B2                     ; 0xB0   RR 6, B
        .db     B2                     ; 0xB1   RR 6, C
        .db     B2                     ; 0xB2   RR 6, D
        .db     B2                     ; 0xB3   RR 6, E
        .db     B2                     ; 0xB4   RR 6, H
        .db     B2                     ; 0xB5   RR 6, L
        .db     B2                     ; 0xB6   RR 6, (HL)
        .db     B2                     ; 0xB7   RR 6, A
        .db     B2                     ; 0xB8   RR 7, B
        .db     B2                     ; 0xB9   RR 7, C
        .db     B2                     ; 0xBA   RR 7, D
        .db     B2                     ; 0xBB   RR 7, E
        .db     B2                     ; 0xBC   RR 7, H
        .db     B2                     ; 0xBD   RR 7, L
        .db     B2                     ; 0xBE   RR 7, (HL)
        .db     B2                     ; 0xBF   RR 7, A
        .db     B2                     ; 0xC0   SLA 0, B
        .db     B2                     ; 0xC1   SLA 0, C
        .db     B2                     ; 0xC2   SLA 0, D
        .db     B2                     ; 0xC3   SLA 0, E
        .db     B2                     ; 0xC4   SLA 0, H
        .db     B2                     ; 0xC5   SLA 0, L
        .db     B2                     ; 0xC6   SLA 0, (HL)
        .db     B2                     ; 0xC7   SLA 0, A
        .db     B2                     ; 0xC8   SLA 1, B
        .db     B2                     ; 0xC9   SLA 1, C
        .db     B2                     ; 0xCA   SLA 1, D
        .db     B2                     ; 0xCB   SLA 1, E
        .db     B2                     ; 0xCC   SLA 1, H
        .db     B2                     ; 0xCD   SLA 1, L
        .db     B2                     ; 0xCE   SLA 1, (HL)
        .db     B2                     ; 0xCF   SLA 1, A
        .db     B2                     ; 0xD0   SLA 2, B
        .db     B2                     ; 0xD1   SLA 2, C
        .db     B2                     ; 0xD2   SLA 2, D
        .db     B2                     ; 0xD3   SLA 2, E
        .db     B2                     ; 0xD4   SLA 2, H
        .db     B2                     ; 0xD5   SLA 2, L
        .db     B2                     ; 0xD6   SLA 2, (HL)
        .db     B2                     ; 0xD7   SLA 2, A
        .db     B2                     ; 0xD8   SLA 3, B
        .db     B2                     ; 0xD9   SLA 3, C
        .db     B2                     ; 0xDA   SLA 3, D
        .db     B2                     ; 0xDB   SLA 3, E
        .db     B2                     ; 0xDC   SLA 3, H
        .db     B2                     ; 0xDD   SLA 3, L
        .db     B2                     ; 0xDE   SLA 3, (HL)
        .db     B2                     ; 0xDF   SLA 3, A
        .db     B2                     ; 0xE0   SLA 4, B
        .db     B2                     ; 0xE1   SLA 4, C
        .db     B2                     ; 0xE2   SLA 4, D
        .db     B2                     ; 0xE3   SLA 4, E
        .db     B2                     ; 0xE4   SLA 4, H
        .db     B2                     ; 0xE5   SLA 4, L
        .db     B2                     ; 0xE6   SLA 4, (HL)
        .db     B2                     ; 0xE7   SLA 4, A
        .db     B2                     ; 0xE8   SLA 5, B
        .db     B2                     ; 0xE9   SLA 5, C
        .db     B2                     ; 0xEA   SLA 5, D
        .db     B2                     ; 0xEB   SLA 5, E
        .db     B2                     ; 0xEC   SLA 5, H
        .db     B2                     ; 0xED   SLA 5, L
        .db     B2                     ; 0xEE   SLA 5, (HL)
        .db     B2                     ; 0xEF   SLA 5, A
        .db     B2                     ; 0xF0   SLA 6, B
        .db     B2                     ; 0xF1   SLA 6, C
        .db     B2                     ; 0xF2   SLA 6, D
        .db     B2                     ; 0xF3   SLA 6, E
        .db     B2                     ; 0xF4   SLA 6, H
        .db     B2                     ; 0xF5   SLA 6, L
        .db     B2                     ; 0xF6   SLA 6, (HL)
        .db     B2                     ; 0xF7   SLA 6, A
        .db     B2                     ; 0xF8   SLA 7, B
        .db     B2                     ; 0xF9   SLA 7, C
        .db     B2                     ; 0xFA   SLA 7, D
        .db     B2                     ; 0xFB   SLA 7, E
        .db     B2                     ; 0xFC   SLA 7, H
        .db     B2                     ; 0xFD   SLA 7, L
        .db     B2                     ; 0xFE   SLA 7, (HL)
        .db     B2                     ; 0xFF   SLA 7, A


        ;;  3. 0xDD instructions
z80_dd_table: 
        .db     B1 + I_UNDOCUMENTED    ; 0x00   DD 00h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x01   DD 01h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x02   DD 02h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x03   DD 03h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x04   DD 04h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x05   DD 05h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x06   DD 06h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x07   DD 07h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x08   DD 08h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x09   DD 09h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0A   DD 0Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0B   DD 0Bh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0C   DD 0Ch UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0D   DD 0Dh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0E   DD 0Eh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0F   DD 0Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x10   DD 10h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x11   DD 11h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x12   DD 12h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x13   DD 13h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x14   DD 14h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x15   DD 15h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x16   DD 16h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x17   DD 17h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x18   DD 18h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x19   DD 19h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1A   DD 1Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1B   DD 1Bh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1C   DD 1Ch UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1D   DD 1Dh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1E   DD 1Eh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1F   DD 1Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x20   DD 20h UNDOCUMENTED
        .db     B2                     ; 0x21   DD opcode 21h
        .db     B2                     ; 0x22   DD opcode 22h
        .db     B2                     ; 0x23   DD opcode 23h
        .db     B2                     ; 0x24   DD opcode 24h
        .db     B2                     ; 0x25   DD opcode 25h
        .db     B2                     ; 0x26   DD opcode 26h
        .db     B1 + I_UNDOCUMENTED    ; 0x27   DD 27h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x28   DD 28h UNDOCUMENTED
        .db     B2                     ; 0x29   DD opcode 29h
        .db     B2                     ; 0x2A   DD opcode 2Ah
        .db     B2                     ; 0x2B   DD opcode 2Bh
        .db     B2                     ; 0x2C   DD opcode 2Ch
        .db     B2                     ; 0x2D   DD opcode 2Dh
        .db     B2                     ; 0x2E   DD opcode 2Eh
        .db     B1 + I_UNDOCUMENTED    ; 0x2F   DD 2Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x30   DD 30h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x31   DD 31h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x32   DD 32h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x33   DD 33h UNDOCUMENTED
        .db     B2                     ; 0x34   DD opcode 34h
        .db     B2                     ; 0x35   DD opcode 35h
        .db     B2                     ; 0x36   DD opcode 36h
        .db     B1 + I_UNDOCUMENTED    ; 0x37   DD 37h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x38   DD 38h UNDOCUMENTED
        .db     B2                     ; 0x39   DD opcode 39h
        .db     B1 + I_UNDOCUMENTED    ; 0x3A   DD 3Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x3B   DD 3Bh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x3C   DD 3Ch UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x3D   DD 3Dh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x3E   DD 3Eh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x3F   DD 3Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x40   DD 40h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x41   DD 41h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x42   DD 42h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x43   DD 43h UNDOCUMENTED
        .db     B2                     ; 0x44   DD opcode 44h
        .db     B2                     ; 0x45   DD opcode 45h
        .db     B2                     ; 0x46   DD opcode 46h
        .db     B1 + I_UNDOCUMENTED    ; 0x47   DD 47h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x48   DD 48h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x49   DD 49h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x4A   DD 4Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x4B   DD 4Bh UNDOCUMENTED
        .db     B2                     ; 0x4C   DD opcode 4Ch
        .db     B2                     ; 0x4D   DD opcode 4Dh
        .db     B2                     ; 0x4E   DD opcode 4Eh
        .db     B1 + I_UNDOCUMENTED    ; 0x4F   DD 4Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x50   DD 50h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x51   DD 51h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x52   DD 52h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x53   DD 53h UNDOCUMENTED
        .db     B2                     ; 0x54   DD opcode 54h
        .db     B2                     ; 0x55   DD opcode 55h
        .db     B2                     ; 0x56   DD opcode 56h
        .db     B1 + I_UNDOCUMENTED    ; 0x57   DD 57h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x58   DD 58h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x59   DD 59h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x5A   DD 5Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x5B   DD 5Bh UNDOCUMENTED
        .db     B2                     ; 0x5C   DD opcode 5Ch
        .db     B2                     ; 0x5D   DD opcode 5Dh
        .db     B2                     ; 0x5E   DD opcode 5Eh
        .db     B1 + I_UNDOCUMENTED    ; 0x5F   DD 5Fh UNDOCUMENTED
        .db     B2                     ; 0x60   DD opcode 60h
        .db     B2                     ; 0x61   DD opcode 61h
        .db     B2                     ; 0x62   DD opcode 62h
        .db     B2                     ; 0x63   DD opcode 63h
        .db     B2                     ; 0x64   DD opcode 64h
        .db     B2                     ; 0x65   DD opcode 65h
        .db     B2                     ; 0x66   DD opcode 66h
        .db     B2                     ; 0x67   DD opcode 67h
        .db     B1 + I_UNDOCUMENTED    ; 0x68   DD 68h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x69   DD 69h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x6A   DD 6Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x6B   DD 6Bh UNDOCUMENTED
        .db     B2                     ; 0x6C   DD opcode 6Ch
        .db     B2                     ; 0x6D   DD opcode 6Dh
        .db     B2                     ; 0x6E   DD opcode 6Eh
        .db     B1 + I_UNDOCUMENTED    ; 0x6F   DD 6Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x70   DD 70h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x71   DD 71h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x72   DD 72h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x73   DD 73h UNDOCUMENTED
        .db     B2                     ; 0x74   DD opcode 74h
        .db     B2                     ; 0x75   DD opcode 75h
        .db     B2                     ; 0x76   DD opcode 76h
        .db     B1 + I_UNDOCUMENTED    ; 0x77   DD 77h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x78   DD 78h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x79   DD 79h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x7A   DD 7Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x7B   DD 7Bh UNDOCUMENTED
        .db     B2                     ; 0x7C   DD opcode 7Ch
        .db     B2                     ; 0x7D   DD opcode 7Dh
        .db     B2                     ; 0x7E   DD opcode 7Eh
        .db     B1 + I_UNDOCUMENTED    ; 0x7F   DD 7Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x80   DD 80h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x81   DD 81h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x82   DD 82h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x83   DD 83h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x84   DD 84h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x85   DD 85h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x86   DD 86h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x87   DD 87h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x88   DD 88h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x89   DD 89h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8A   DD 8Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8B   DD 8Bh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8C   DD 8Ch UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8D   DD 8Dh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8E   DD 8Eh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8F   DD 8Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x90   DD 90h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x91   DD 91h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x92   DD 92h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x93   DD 93h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x94   DD 94h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x95   DD 95h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x96   DD 96h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x97   DD 97h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x98   DD 98h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x99   DD 99h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9A   DD 9Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9B   DD 9Bh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9C   DD 9Ch UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9D   DD 9Dh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9E   DD 9Eh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9F   DD 9Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA0   DD A0h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA1   DD A1h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA2   DD A2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA3   DD A3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA4   DD A4h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA5   DD A5h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA6   DD A6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA7   DD A7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA8   DD A8h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA9   DD A9h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAA   DD AAh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAB   DD ABh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAC   DD ACh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAD   DD ADh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAE   DD AEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAF   DD AFh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB0   DD B0h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB1   DD B1h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB2   DD B2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB3   DD B3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB4   DD B4h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB5   DD B5h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB6   DD B6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB7   DD B7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB8   DD B8h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB9   DD B9h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBA   DD BAh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBB   DD BBh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBC   DD BCh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBD   DD BDh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBE   DD BEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBF   DD BFh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC0   DD C0h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC1   DD C1h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC2   DD C2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC3   DD C3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC4   DD C4h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC5   DD C5h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC6   DD C6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC7   DD C7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC8   DD C8h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC9   DD C9h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xCA   DD CAh UNDOCUMENTED
        .db     B0 + I_CB              ; 0xCB   DD CB prefix
        .db     B1 + I_UNDOCUMENTED    ; 0xCC   DD CCh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xCD   DD CDh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xCE   DD CEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xCF   DD CFh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD0   DD D0h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD1   DD D1h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD2   DD D2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD3   DD D3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD4   DD D4h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD5   DD D5h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD6   DD D6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD7   DD D7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD8   DD D8h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD9   DD D9h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDA   DD DAh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDB   DD DBh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDC   DD DCh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDD   DD DDh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDE   DD DEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDF   DD DFh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE0   DD E0h UNDOCUMENTED
        .db     B2                     ; 0xE1   DD opcode E1h
        .db     B1 + I_UNDOCUMENTED    ; 0xE2   DD E2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE3   DD E3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE4   DD E4h UNDOCUMENTED
        .db     B2                     ; 0xE5   DD opcode E5h
        .db     B1 + I_UNDOCUMENTED    ; 0xE6   DD E6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE7   DD E7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE8   DD E8h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE9   DD E9h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xEA   DD EAh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xEB   DD EBh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xEC   DD ECh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xED   DD EDh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xEE   DD EEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xEF   DD EFh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF0   DD F0h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF1   DD F1h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF2   DD F2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF3   DD F3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF4   DD F4h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF5   DD F5h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF6   DD F6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF7   DD F7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF8   DD F8h UNDOCUMENTED
        .db     B2                     ; 0xF9   DD opcode F9h
        .db     B1 + I_UNDOCUMENTED    ; 0xFA   DD FAh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xFB   DD FBh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xFC   DD FCh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xFD   DD FDh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xFE   DD FEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xFF   DD FFh UNDOCUMENTED


        ;;  4. 0xFD instructions
z80_fd_table: 
        .db     B1 + I_UNDOCUMENTED    ; 0x00   FD 00h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x01   FD 01h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x02   FD 02h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x03   FD 03h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x04   FD 04h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x05   FD 05h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x06   FD 06h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x07   FD 07h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x08   FD 08h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x09   FD 09h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0A   FD 0Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0B   FD 0Bh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0C   FD 0Ch UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0D   FD 0Dh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0E   FD 0Eh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x0F   FD 0Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x10   FD 10h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x11   FD 11h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x12   FD 12h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x13   FD 13h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x14   FD 14h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x15   FD 15h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x16   FD 16h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x17   FD 17h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x18   FD 18h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x19   FD 19h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1A   FD 1Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1B   FD 1Bh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1C   FD 1Ch UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1D   FD 1Dh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1E   FD 1Eh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x1F   FD 1Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x20   FD 20h UNDOCUMENTED
        .db     B2                     ; 0x21   FD opcode 21h
        .db     B2                     ; 0x22   FD opcode 22h
        .db     B2                     ; 0x23   FD opcode 23h
        .db     B2                     ; 0x24   FD opcode 24h
        .db     B2                     ; 0x25   FD opcode 25h
        .db     B2                     ; 0x26   FD opcode 26h
        .db     B1 + I_UNDOCUMENTED    ; 0x27   FD 27h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x28   FD 28h UNDOCUMENTED
        .db     B2                     ; 0x29   FD opcode 29h
        .db     B2                     ; 0x2A   FD opcode 2Ah
        .db     B2                     ; 0x2B   FD opcode 2Bh
        .db     B2                     ; 0x2C   FD opcode 2Ch
        .db     B2                     ; 0x2D   FD opcode 2Dh
        .db     B2                     ; 0x2E   FD opcode 2Eh
        .db     B1 + I_UNDOCUMENTED    ; 0x2F   FD 2Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x30   FD 30h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x31   FD 31h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x32   FD 32h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x33   FD 33h UNDOCUMENTED
        .db     B2                     ; 0x34   FD opcode 34h
        .db     B2                     ; 0x35   FD opcode 35h
        .db     B2                     ; 0x36   FD opcode 36h
        .db     B1 + I_UNDOCUMENTED    ; 0x37   FD 37h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x38   FD 38h UNDOCUMENTED
        .db     B2                     ; 0x39   FD opcode 39h
        .db     B1 + I_UNDOCUMENTED    ; 0x3A   FD 3Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x3B   FD 3Bh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x3C   FD 3Ch UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x3D   FD 3Dh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x3E   FD 3Eh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x3F   FD 3Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x40   FD 40h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x41   FD 41h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x42   FD 42h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x43   FD 43h UNDOCUMENTED
        .db     B2                     ; 0x44   FD opcode 44h
        .db     B2                     ; 0x45   FD opcode 45h
        .db     B2                     ; 0x46   FD opcode 46h
        .db     B1 + I_UNDOCUMENTED    ; 0x47   FD 47h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x48   FD 48h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x49   FD 49h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x4A   FD 4Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x4B   FD 4Bh UNDOCUMENTED
        .db     B2                     ; 0x4C   FD opcode 4Ch
        .db     B2                     ; 0x4D   FD opcode 4Dh
        .db     B2                     ; 0x4E   FD opcode 4Eh
        .db     B1 + I_UNDOCUMENTED    ; 0x4F   FD 4Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x50   FD 50h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x51   FD 51h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x52   FD 52h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x53   FD 53h UNDOCUMENTED
        .db     B2                     ; 0x54   FD opcode 54h
        .db     B2                     ; 0x55   FD opcode 55h
        .db     B2                     ; 0x56   FD opcode 56h
        .db     B1 + I_UNDOCUMENTED    ; 0x57   FD 57h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x58   FD 58h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x59   FD 59h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x5A   FD 5Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x5B   FD 5Bh UNDOCUMENTED
        .db     B2                     ; 0x5C   FD opcode 5Ch
        .db     B2                     ; 0x5D   FD opcode 5Dh
        .db     B2                     ; 0x5E   FD opcode 5Eh
        .db     B1 + I_UNDOCUMENTED    ; 0x5F   FD 5Fh UNDOCUMENTED
        .db     B2                     ; 0x60   FD opcode 60h
        .db     B2                     ; 0x61   FD opcode 61h
        .db     B2                     ; 0x62   FD opcode 62h
        .db     B2                     ; 0x63   FD opcode 63h
        .db     B2                     ; 0x64   FD opcode 64h
        .db     B2                     ; 0x65   FD opcode 65h
        .db     B2                     ; 0x66   FD opcode 66h
        .db     B2                     ; 0x67   FD opcode 67h
        .db     B1 + I_UNDOCUMENTED    ; 0x68   FD 68h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x69   FD 69h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x6A   FD 6Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x6B   FD 6Bh UNDOCUMENTED
        .db     B2                     ; 0x6C   FD opcode 6Ch
        .db     B2                     ; 0x6D   FD opcode 6Dh
        .db     B2                     ; 0x6E   FD opcode 6Eh
        .db     B1 + I_UNDOCUMENTED    ; 0x6F   FD 6Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x70   FD 70h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x71   FD 71h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x72   FD 72h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x73   FD 73h UNDOCUMENTED
        .db     B2                     ; 0x74   FD opcode 74h
        .db     B2                     ; 0x75   FD opcode 75h
        .db     B2                     ; 0x76   FD opcode 76h
        .db     B1 + I_UNDOCUMENTED    ; 0x77   FD 77h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x78   FD 78h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x79   FD 79h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x7A   FD 7Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x7B   FD 7Bh UNDOCUMENTED
        .db     B2                     ; 0x7C   FD opcode 7Ch
        .db     B2                     ; 0x7D   FD opcode 7Dh
        .db     B2                     ; 0x7E   FD opcode 7Eh
        .db     B1 + I_UNDOCUMENTED    ; 0x7F   FD 7Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x80   FD 80h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x81   FD 81h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x82   FD 82h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x83   FD 83h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x84   FD 84h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x85   FD 85h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x86   FD 86h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x87   FD 87h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x88   FD 88h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x89   FD 89h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8A   FD 8Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8B   FD 8Bh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8C   FD 8Ch UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8D   FD 8Dh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8E   FD 8Eh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x8F   FD 8Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x90   FD 90h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x91   FD 91h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x92   FD 92h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x93   FD 93h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x94   FD 94h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x95   FD 95h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x96   FD 96h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x97   FD 97h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x98   FD 98h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x99   FD 99h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9A   FD 9Ah UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9B   FD 9Bh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9C   FD 9Ch UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9D   FD 9Dh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9E   FD 9Eh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0x9F   FD 9Fh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA0   FD A0h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA1   FD A1h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA2   FD A2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA3   FD A3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA4   FD A4h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA5   FD A5h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA6   FD A6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA7   FD A7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA8   FD A8h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xA9   FD A9h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAA   FD AAh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAB   FD ABh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAC   FD ACh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAD   FD ADh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAE   FD AEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xAF   FD AFh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB0   FD B0h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB1   FD B1h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB2   FD B2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB3   FD B3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB4   FD B4h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB5   FD B5h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB6   FD B6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB7   FD B7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB8   FD B8h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xB9   FD B9h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBA   FD BAh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBB   FD BBh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBC   FD BCh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBD   FD BDh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBE   FD BEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xBF   FD BFh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC0   FD C0h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC1   FD C1h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC2   FD C2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC3   FD C3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC4   FD C4h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC5   FD C5h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC6   FD C6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC7   FD C7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC8   FD C8h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xC9   FD C9h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xCA   FD CAh UNDOCUMENTED
        .db     B0 + I_CB              ; 0xCB   FD CB prefix
        .db     B1 + I_UNDOCUMENTED    ; 0xCC   FD CCh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xCD   FD CDh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xCE   FD CEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xCF   FD CFh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD0   FD D0h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD1   FD D1h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD2   FD D2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD3   FD D3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD4   FD D4h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD5   FD D5h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD6   FD D6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD7   FD D7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD8   FD D8h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xD9   FD D9h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDA   FD DAh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDB   FD DBh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDC   FD DCh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDD   FD DDh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDE   FD DEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xDF   FD DFh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE0   FD E0h UNDOCUMENTED
        .db     B2                     ; 0xE1   FD opcode E1h
        .db     B1 + I_UNDOCUMENTED    ; 0xE2   FD E2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE3   FD E3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE4   FD E4h UNDOCUMENTED
        .db     B2                     ; 0xE5   FD opcode E5h
        .db     B1 + I_UNDOCUMENTED    ; 0xE6   FD E6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE7   FD E7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE8   FD E8h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xE9   FD E9h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xEA   FD EAh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xEB   FD EBh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xEC   FD ECh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xED   FD EDh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xEE   FD EEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xEF   FD EFh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF0   FD F0h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF1   FD F1h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF2   FD F2h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF3   FD F3h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF4   FD F4h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF5   FD F5h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF6   FD F6h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF7   FD F7h UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xF8   FD F8h UNDOCUMENTED
        .db     B2                     ; 0xF9   FD opcode F9h
        .db     B1 + I_UNDOCUMENTED    ; 0xFA   FD FAh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xFB   FD FBh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xFC   FD FCh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xFD   FD FDh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xFE   FD FEh UNDOCUMENTED
        .db     B1 + I_UNDOCUMENTED    ; 0xFF   FD FFh UNDOCUMENTED

z80_ddcb_table:
        .db     B4 + I_CB                ; 0x00   RLC (IX+d)
        .db     B4 + I_CB                ; 0x01   RLC (IX+d)
        .db     B4 + I_CB                ; 0x02   RLC (IX+d)
        .db     B4 + I_CB                ; 0x03   RLC (IX+d)
        .db     B4 + I_CB                ; 0x04   RLC (IX+d)
        .db     B4 + I_CB                ; 0x05   RLC (IX+d)
        .db     B4 + I_CB                ; 0x06   RLC (IX+d)
        .db     B4 + I_CB                ; 0x07   RLC (IX+d)
        .db     B4 + I_CB                ; 0x08   RRC (IX+d)
        .db     B4 + I_CB                ; 0x09   RRC (IX+d)
        .db     B4 + I_CB                ; 0x0A   RRC (IX+d)
        .db     B4 + I_CB                ; 0x0B   RRC (IX+d)
        .db     B4 + I_CB                ; 0x0C   RRC (IX+d)
        .db     B4 + I_CB                ; 0x0D   RRC (IX+d)
        .db     B4 + I_CB                ; 0x0E   RRC (IX+d)
        .db     B4 + I_CB                ; 0x0F   RRC (IX+d)
        .db     B4 + I_CB                ; 0x10   RL (IX+d)
        .db     B4 + I_CB                ; 0x11   RL (IX+d)
        .db     B4 + I_CB                ; 0x12   RL (IX+d)
        .db     B4 + I_CB                ; 0x13   RL (IX+d)
        .db     B4 + I_CB                ; 0x14   RL (IX+d)
        .db     B4 + I_CB                ; 0x15   RL (IX+d)
        .db     B4 + I_CB                ; 0x16   RL (IX+d)
        .db     B4 + I_CB                ; 0x17   RL (IX+d)
        .db     B4 + I_CB                ; 0x18   RR (IX+d)
        .db     B4 + I_CB                ; 0x19   RR (IX+d)
        .db     B4 + I_CB                ; 0x1A   RR (IX+d)
        .db     B4 + I_CB                ; 0x1B   RR (IX+d)
        .db     B4 + I_CB                ; 0x1C   RR (IX+d)
        .db     B4 + I_CB                ; 0x1D   RR (IX+d)
        .db     B4 + I_CB                ; 0x1E   RR (IX+d)
        .db     B4 + I_CB                ; 0x1F   RR (IX+d)
        .db     B4 + I_CB                ; 0x20   SLA (IX+d)
        .db     B4 + I_CB                ; 0x21   SLA (IX+d)
        .db     B4 + I_CB                ; 0x22   SLA (IX+d)
        .db     B4 + I_CB                ; 0x23   SLA (IX+d)
        .db     B4 + I_CB                ; 0x24   SLA (IX+d)
        .db     B4 + I_CB                ; 0x25   SLA (IX+d)
        .db     B4 + I_CB                ; 0x26   SLA (IX+d)
        .db     B4 + I_CB                ; 0x27   SLA (IX+d)
        .db     B4 + I_CB                ; 0x28   SRA (IX+d)
        .db     B4 + I_CB                ; 0x29   SRA (IX+d)
        .db     B4 + I_CB                ; 0x2A   SRA (IX+d)
        .db     B4 + I_CB                ; 0x2B   SRA (IX+d)
        .db     B4 + I_CB                ; 0x2C   SRA (IX+d)
        .db     B4 + I_CB                ; 0x2D   SRA (IX+d)
        .db     B4 + I_CB                ; 0x2E   SRA (IX+d)
        .db     B4 + I_CB                ; 0x2F   SRA (IX+d)
        .db     B4 + I_CB                ; 0x30   SLL (IX+d)
        .db     B4 + I_CB                ; 0x31   SLL (IX+d)
        .db     B4 + I_CB                ; 0x32   SLL (IX+d)
        .db     B4 + I_CB                ; 0x33   SLL (IX+d)
        .db     B4 + I_CB                ; 0x34   SLL (IX+d)
        .db     B4 + I_CB                ; 0x35   SLL (IX+d)
        .db     B4 + I_CB                ; 0x36   SLL (IX+d)
        .db     B4 + I_CB                ; 0x37   SLL (IX+d)
        .db     B4 + I_CB                ; 0x38   SRL (IX+d)
        .db     B4 + I_CB                ; 0x39   SRL (IX+d)
        .db     B4 + I_CB                ; 0x3A   SRL (IX+d)
        .db     B4 + I_CB                ; 0x3B   SRL (IX+d)
        .db     B4 + I_CB                ; 0x3C   SRL (IX+d)
        .db     B4 + I_CB                ; 0x3D   SRL (IX+d)
        .db     B4 + I_CB                ; 0x3E   SRL (IX+d)
        .db     B4 + I_CB                ; 0x3F   SRL (IX+d)
        .db     B4 + I_CB                ; 0x40   BIT 0, B
        .db     B4 + I_CB                ; 0x41   BIT 0, C
        .db     B4 + I_CB                ; 0x42   BIT 0, D
        .db     B4 + I_CB                ; 0x43   BIT 0, E
        .db     B4 + I_CB                ; 0x44   BIT 0, H
        .db     B4 + I_CB                ; 0x45   BIT 0, L
        .db     B4 + I_CB                ; 0x46   BIT 0, (IX+d)
        .db     B4 + I_CB                ; 0x47   BIT 0, A
        .db     B4 + I_CB                ; 0x48   BIT 1, B
        .db     B4 + I_CB                ; 0x49   BIT 1, C
        .db     B4 + I_CB                ; 0x4A   BIT 1, D
        .db     B4 + I_CB                ; 0x4B   BIT 1, E
        .db     B4 + I_CB                ; 0x4C   BIT 1, H
        .db     B4 + I_CB                ; 0x4D   BIT 1, L
        .db     B4 + I_CB                ; 0x4E   BIT 1, (IX+d)
        .db     B4 + I_CB                ; 0x4F   BIT 1, A
        .db     B4 + I_CB                ; 0x50   BIT 2, B
        .db     B4 + I_CB                ; 0x51   BIT 2, C
        .db     B4 + I_CB                ; 0x52   BIT 2, D
        .db     B4 + I_CB                ; 0x53   BIT 2, E
        .db     B4 + I_CB                ; 0x54   BIT 2, H
        .db     B4 + I_CB                ; 0x55   BIT 2, L
        .db     B4 + I_CB                ; 0x56   BIT 2, (IX+d)
        .db     B4 + I_CB                ; 0x57   BIT 2, A
        .db     B4 + I_CB                ; 0x58   BIT 3, B
        .db     B4 + I_CB                ; 0x59   BIT 3, C
        .db     B4 + I_CB                ; 0x5A   BIT 3, D
        .db     B4 + I_CB                ; 0x5B   BIT 3, E
        .db     B4 + I_CB                ; 0x5C   BIT 3, H
        .db     B4 + I_CB                ; 0x5D   BIT 3, L
        .db     B4 + I_CB                ; 0x5E   BIT 3, (IX+d)
        .db     B4 + I_CB                ; 0x5F   BIT 3, A
        .db     B4 + I_CB                ; 0x60   BIT 4, B
        .db     B4 + I_CB                ; 0x61   BIT 4, C
        .db     B4 + I_CB                ; 0x62   BIT 4, D
        .db     B4 + I_CB                ; 0x63   BIT 4, E
        .db     B4 + I_CB                ; 0x64   BIT 4, H
        .db     B4 + I_CB                ; 0x65   BIT 4, L
        .db     B4 + I_CB                ; 0x66   BIT 4, (IX+d)
        .db     B4 + I_CB                ; 0x67   BIT 4, A
        .db     B4 + I_CB                ; 0x68   BIT 5, B
        .db     B4 + I_CB                ; 0x69   BIT 5, C
        .db     B4 + I_CB                ; 0x6A   BIT 5, D
        .db     B4 + I_CB                ; 0x6B   BIT 5, E
        .db     B4 + I_CB                ; 0x6C   BIT 5, H
        .db     B4 + I_CB                ; 0x6D   BIT 5, L
        .db     B4 + I_CB                ; 0x6E   BIT 5, (IX+d)
        .db     B4 + I_CB                ; 0x6F   BIT 5, A
        .db     B4 + I_CB                ; 0x70   BIT 6, B
        .db     B4 + I_CB                ; 0x71   BIT 6, C
        .db     B4 + I_CB                ; 0x72   BIT 6, D
        .db     B4 + I_CB                ; 0x73   BIT 6, E
        .db     B4 + I_CB                ; 0x74   BIT 6, H
        .db     B4 + I_CB                ; 0x75   BIT 6, L
        .db     B4 + I_CB                ; 0x76   BIT 6, (IX+d)
        .db     B4 + I_CB                ; 0x77   BIT 6, A
        .db     B4 + I_CB                ; 0x78   BIT 7, B
        .db     B4 + I_CB                ; 0x79   BIT 7, C
        .db     B4 + I_CB                ; 0x7A   BIT 7, D
        .db     B4 + I_CB                ; 0x7B   BIT 7, E
        .db     B4 + I_CB                ; 0x7C   BIT 7, H
        .db     B4 + I_CB                ; 0x7D   BIT 7, L
        .db     B4 + I_CB                ; 0x7E   BIT 7, (IX+d)
        .db     B4 + I_CB                ; 0x7F   BIT 7, A
        .db     B4 + I_CB                ; 0x80   RES 0, B
        .db     B4 + I_CB                ; 0x81   RES 0, C
        .db     B4 + I_CB                ; 0x82   RES 0, D
        .db     B4 + I_CB                ; 0x83   RES 0, E
        .db     B4 + I_CB                ; 0x84   RES 0, H
        .db     B4 + I_CB                ; 0x85   RES 0, L
        .db     B4 + I_CB                ; 0x86   RES 0, (IX+d)
        .db     B4 + I_CB                ; 0x87   RES 0, A
        .db     B4 + I_CB                ; 0x88   RES 1, B
        .db     B4 + I_CB                ; 0x89   RES 1, C
        .db     B4 + I_CB                ; 0x8A   RES 1, D
        .db     B4 + I_CB                ; 0x8B   RES 1, E
        .db     B4 + I_CB                ; 0x8C   RES 1, H
        .db     B4 + I_CB                ; 0x8D   RES 1, L
        .db     B4 + I_CB                ; 0x8E   RES 1, (IX+d)
        .db     B4 + I_CB                ; 0x8F   RES 1, A
        .db     B4 + I_CB                ; 0x90   RES 2, B
        .db     B4 + I_CB                ; 0x91   RES 2, C
        .db     B4 + I_CB                ; 0x92   RES 2, D
        .db     B4 + I_CB                ; 0x93   RES 2, E
        .db     B4 + I_CB                ; 0x94   RES 2, H
        .db     B4 + I_CB                ; 0x95   RES 2, L
        .db     B4 + I_CB                ; 0x96   RES 2, (IX+d)
        .db     B4 + I_CB                ; 0x97   RES 2, A
        .db     B4 + I_CB                ; 0x98   RES 3, B
        .db     B4 + I_CB                ; 0x99   RES 3, C
        .db     B4 + I_CB                ; 0x9A   RES 3, D
        .db     B4 + I_CB                ; 0x9B   RES 3, E
        .db     B4 + I_CB                ; 0x9C   RES 3, H
        .db     B4 + I_CB                ; 0x9D   RES 3, L
        .db     B4 + I_CB                ; 0x9E   RES 3, (IX+d)
        .db     B4 + I_CB                ; 0x9F   RES 3, A
        .db     B4 + I_CB                ; 0xA0   RES 4, B
        .db     B4 + I_CB                ; 0xA1   RES 4, C
        .db     B4 + I_CB                ; 0xA2   RES 4, D
        .db     B4 + I_CB                ; 0xA3   RES 4, E
        .db     B4 + I_CB                ; 0xA4   RES 4, H
        .db     B4 + I_CB                ; 0xA5   RES 4, L
        .db     B4 + I_CB                ; 0xA6   RES 4, (IX+d)
        .db     B4 + I_CB                ; 0xA7   RES 4, A
        .db     B4 + I_CB                ; 0xA8   RES 5, B
        .db     B4 + I_CB                ; 0xA9   RES 5, C
        .db     B4 + I_CB                ; 0xAA   RES 5, D
        .db     B4 + I_CB                ; 0xAB   RES 5, E
        .db     B4 + I_CB                ; 0xAC   RES 5, H
        .db     B4 + I_CB                ; 0xAD   RES 5, L
        .db     B4 + I_CB                ; 0xAE   RES 5, (IX+d)
        .db     B4 + I_CB                ; 0xAF   RES 5, A
        .db     B4 + I_CB                ; 0xB0   RES 6, B
        .db     B4 + I_CB                ; 0xB1   RES 6, C
        .db     B4 + I_CB                ; 0xB2   RES 6, D
        .db     B4 + I_CB                ; 0xB3   RES 6, E
        .db     B4 + I_CB                ; 0xB4   RES 6, H
        .db     B4 + I_CB                ; 0xB5   RES 6, L
        .db     B4 + I_CB                ; 0xB6   RES 6, (IX+d)
        .db     B4 + I_CB                ; 0xB7   RES 6, A
        .db     B4 + I_CB                ; 0xB8   RES 7, B
        .db     B4 + I_CB                ; 0xB9   RES 7, C
        .db     B4 + I_CB                ; 0xBA   RES 7, D
        .db     B4 + I_CB                ; 0xBB   RES 7, E
        .db     B4 + I_CB                ; 0xBC   RES 7, H
        .db     B4 + I_CB                ; 0xBD   RES 7, L
        .db     B4 + I_CB                ; 0xBE   RES 7, (IX+d)
        .db     B4 + I_CB                ; 0xBF   RES 7, A
        .db     B4 + I_CB                ; 0xC0   SET 0, B
        .db     B4 + I_CB                ; 0xC1   SET 0, C
        .db     B4 + I_CB                ; 0xC2   SET 0, D
        .db     B4 + I_CB                ; 0xC3   SET 0, E
        .db     B4 + I_CB                ; 0xC4   SET 0, H
        .db     B4 + I_CB                ; 0xC5   SET 0, L
        .db     B4 + I_CB                ; 0xC6   SET 0, (IX+d)
        .db     B4 + I_CB                ; 0xC7   SET 0, A
        .db     B4 + I_CB                ; 0xC8   SET 1, B
        .db     B4 + I_CB                ; 0xC9   SET 1, C
        .db     B4 + I_CB                ; 0xCA   SET 1, D
        .db     B4 + I_CB                ; 0xCB   SET 1, E
        .db     B4 + I_CB                ; 0xCC   SET 1, H
        .db     B4 + I_CB                ; 0xCD   SET 1, L
        .db     B4 + I_CB                ; 0xCE   SET 1, (IX+d)
        .db     B4 + I_CB                ; 0xCF   SET 1, A
        .db     B4 + I_CB                ; 0xD0   SET 2, B
        .db     B4 + I_CB                ; 0xD1   SET 2, C
        .db     B4 + I_CB                ; 0xD2   SET 2, D
        .db     B4 + I_CB                ; 0xD3   SET 2, E
        .db     B4 + I_CB                ; 0xD4   SET 2, H
        .db     B4 + I_CB                ; 0xD5   SET 2, L
        .db     B4 + I_CB                ; 0xD6   SET 2, (IX+d)
        .db     B4 + I_CB                ; 0xD7   SET 2, A
        .db     B4 + I_CB                ; 0xD8   SET 3, B
        .db     B4 + I_CB                ; 0xD9   SET 3, C
        .db     B4 + I_CB                ; 0xDA   SET 3, D
        .db     B4 + I_CB                ; 0xDB   SET 3, E
        .db     B4 + I_CB                ; 0xDC   SET 3, H
        .db     B4 + I_CB                ; 0xDD   SET 3, L
        .db     B4 + I_CB                ; 0xDE   SET 3, (IX+d)
        .db     B4 + I_CB                ; 0xDF   SET 3, A
        .db     B4 + I_CB                ; 0xE0   SET 4, B
        .db     B4 + I_CB                ; 0xE1   SET 4, C
        .db     B4 + I_CB                ; 0xE2   SET 4, D
        .db     B4 + I_CB                ; 0xE3   SET 4, E
        .db     B4 + I_CB                ; 0xE4   SET 4, H
        .db     B4 + I_CB                ; 0xE5   SET 4, L
        .db     B4 + I_CB                ; 0xE6   SET 4, (IX+d)
        .db     B4 + I_CB                ; 0xE7   SET 4, A
        .db     B4 + I_CB                ; 0xE8   SET 5, B
        .db     B4 + I_CB                ; 0xE9   SET 5, C
        .db     B4 + I_CB                ; 0xEA   SET 5, D
        .db     B4 + I_CB                ; 0xEB   SET 5, E
        .db     B4 + I_CB                ; 0xEC   SET 5, H
        .db     B4 + I_CB                ; 0xED   SET 5, L
        .db     B4 + I_CB                ; 0xEE   SET 5, (IX+d)
        .db     B4 + I_CB                ; 0xEF   SET 5, A
        .db     B4 + I_CB                ; 0xF0   SET 6, B
        .db     B4 + I_CB                ; 0xF1   SET 6, C
        .db     B4 + I_CB                ; 0xF2   SET 6, D
        .db     B4 + I_CB                ; 0xF3   SET 6, E
        .db     B4 + I_CB                ; 0xF4   SET 6, H
        .db     B4 + I_CB                ; 0xF5   SET 6, L
        .db     B4 + I_CB                ; 0xF6   SET 6, (IX+d)
        .db     B4 + I_CB                ; 0xF7   SET 6, A
        .db     B4 + I_CB                ; 0xF8   SET 7, B
        .db     B4 + I_CB                ; 0xF9   SET 7, C
        .db     B4 + I_CB                ; 0xFA   SET 7, D
        .db     B4 + I_CB                ; 0xFB   SET 7, E
        .db     B4 + I_CB                ; 0xFC   SET 7, H
        .db     B4 + I_CB                ; 0xFD   SET 7, L
        .db     B4 + I_CB                ; 0xFE   SET 7, (IX+d)
        .db     B4 + I_CB                ; 0xFF   SET 7, A

z80_fdcb_table:
        .db     B4 + I_CB                ; 0x00   RLC (IY+d)
        .db     B4 + I_CB                ; 0x01   RLC (IY+d)
        .db     B4 + I_CB                ; 0x02   RLC (IY+d)
        .db     B4 + I_CB                ; 0x03   RLC (IY+d)
        .db     B4 + I_CB                ; 0x04   RLC (IY+d)
        .db     B4 + I_CB                ; 0x05   RLC (IY+d)
        .db     B4 + I_CB                ; 0x06   RLC (IY+d)
        .db     B4 + I_CB                ; 0x07   RLC (IY+d)
        .db     B4 + I_CB                ; 0x08   RRC (IY+d)
        .db     B4 + I_CB                ; 0x09   RRC (IY+d)
        .db     B4 + I_CB                ; 0x0A   RRC (IY+d)
        .db     B4 + I_CB                ; 0x0B   RRC (IY+d)
        .db     B4 + I_CB                ; 0x0C   RRC (IY+d)
        .db     B4 + I_CB                ; 0x0D   RRC (IY+d)
        .db     B4 + I_CB                ; 0x0E   RRC (IY+d)
        .db     B4 + I_CB                ; 0x0F   RRC (IY+d)
        .db     B4 + I_CB                ; 0x10   RL (IY+d)
        .db     B4 + I_CB                ; 0x11   RL (IY+d)
        .db     B4 + I_CB                ; 0x12   RL (IY+d)
        .db     B4 + I_CB                ; 0x13   RL (IY+d)
        .db     B4 + I_CB                ; 0x14   RL (IY+d)
        .db     B4 + I_CB                ; 0x15   RL (IY+d)
        .db     B4 + I_CB                ; 0x16   RL (IY+d)
        .db     B4 + I_CB                ; 0x17   RL (IY+d)
        .db     B4 + I_CB                ; 0x18   RR (IY+d)
        .db     B4 + I_CB                ; 0x19   RR (IY+d)
        .db     B4 + I_CB                ; 0x1A   RR (IY+d)
        .db     B4 + I_CB                ; 0x1B   RR (IY+d)
        .db     B4 + I_CB                ; 0x1C   RR (IY+d)
        .db     B4 + I_CB                ; 0x1D   RR (IY+d)
        .db     B4 + I_CB                ; 0x1E   RR (IY+d)
        .db     B4 + I_CB                ; 0x1F   RR (IY+d)
        .db     B4 + I_CB                ; 0x20   SLA (IY+d)
        .db     B4 + I_CB                ; 0x21   SLA (IY+d)
        .db     B4 + I_CB                ; 0x22   SLA (IY+d)
        .db     B4 + I_CB                ; 0x23   SLA (IY+d)
        .db     B4 + I_CB                ; 0x24   SLA (IY+d)
        .db     B4 + I_CB                ; 0x25   SLA (IY+d)
        .db     B4 + I_CB                ; 0x26   SLA (IY+d)
        .db     B4 + I_CB                ; 0x27   SLA (IY+d)
        .db     B4 + I_CB                ; 0x28   SRA (IY+d)
        .db     B4 + I_CB                ; 0x29   SRA (IY+d)
        .db     B4 + I_CB                ; 0x2A   SRA (IY+d)
        .db     B4 + I_CB                ; 0x2B   SRA (IY+d)
        .db     B4 + I_CB                ; 0x2C   SRA (IY+d)
        .db     B4 + I_CB                ; 0x2D   SRA (IY+d)
        .db     B4 + I_CB                ; 0x2E   SRA (IY+d)
        .db     B4 + I_CB                ; 0x2F   SRA (IY+d)
        .db     B4 + I_CB                ; 0x30   SLL (IY+d)
        .db     B4 + I_CB                ; 0x31   SLL (IY+d)
        .db     B4 + I_CB                ; 0x32   SLL (IY+d)
        .db     B4 + I_CB                ; 0x33   SLL (IY+d)
        .db     B4 + I_CB                ; 0x34   SLL (IY+d)
        .db     B4 + I_CB                ; 0x35   SLL (IY+d)
        .db     B4 + I_CB                ; 0x36   SLL (IY+d)
        .db     B4 + I_CB                ; 0x37   SLL (IY+d)
        .db     B4 + I_CB                ; 0x38   SRL (IY+d)
        .db     B4 + I_CB                ; 0x39   SRL (IY+d)
        .db     B4 + I_CB                ; 0x3A   SRL (IY+d)
        .db     B4 + I_CB                ; 0x3B   SRL (IY+d)
        .db     B4 + I_CB                ; 0x3C   SRL (IY+d)
        .db     B4 + I_CB                ; 0x3D   SRL (IY+d)
        .db     B4 + I_CB                ; 0x3E   SRL (IY+d)
        .db     B4 + I_CB                ; 0x3F   SRL (IY+d)
        .db     B4 + I_CB                ; 0x40   BIT 0, B
        .db     B4 + I_CB                ; 0x41   BIT 0, C
        .db     B4 + I_CB                ; 0x42   BIT 0, D
        .db     B4 + I_CB                ; 0x43   BIT 0, E
        .db     B4 + I_CB                ; 0x44   BIT 0, H
        .db     B4 + I_CB                ; 0x45   BIT 0, L
        .db     B4 + I_CB                ; 0x46   BIT 0, (IY+d)
        .db     B4 + I_CB                ; 0x47   BIT 0, A
        .db     B4 + I_CB                ; 0x48   BIT 1, B
        .db     B4 + I_CB                ; 0x49   BIT 1, C
        .db     B4 + I_CB                ; 0x4A   BIT 1, D
        .db     B4 + I_CB                ; 0x4B   BIT 1, E
        .db     B4 + I_CB                ; 0x4C   BIT 1, H
        .db     B4 + I_CB                ; 0x4D   BIT 1, L
        .db     B4 + I_CB                ; 0x4E   BIT 1, (IY+d)
        .db     B4 + I_CB                ; 0x4F   BIT 1, A
        .db     B4 + I_CB                ; 0x50   BIT 2, B
        .db     B4 + I_CB                ; 0x51   BIT 2, C
        .db     B4 + I_CB                ; 0x52   BIT 2, D
        .db     B4 + I_CB                ; 0x53   BIT 2, E
        .db     B4 + I_CB                ; 0x54   BIT 2, H
        .db     B4 + I_CB                ; 0x55   BIT 2, L
        .db     B4 + I_CB                ; 0x56   BIT 2, (IY+d)
        .db     B4 + I_CB                ; 0x57   BIT 2, A
        .db     B4 + I_CB                ; 0x58   BIT 3, B
        .db     B4 + I_CB                ; 0x59   BIT 3, C
        .db     B4 + I_CB                ; 0x5A   BIT 3, D
        .db     B4 + I_CB                ; 0x5B   BIT 3, E
        .db     B4 + I_CB                ; 0x5C   BIT 3, H
        .db     B4 + I_CB                ; 0x5D   BIT 3, L
        .db     B4 + I_CB                ; 0x5E   BIT 3, (IY+d)
        .db     B4 + I_CB                ; 0x5F   BIT 3, A
        .db     B4 + I_CB                ; 0x60   BIT 4, B
        .db     B4 + I_CB                ; 0x61   BIT 4, C
        .db     B4 + I_CB                ; 0x62   BIT 4, D
        .db     B4 + I_CB                ; 0x63   BIT 4, E
        .db     B4 + I_CB                ; 0x64   BIT 4, H
        .db     B4 + I_CB                ; 0x65   BIT 4, L
        .db     B4 + I_CB                ; 0x66   BIT 4, (IY+d)
        .db     B4 + I_CB                ; 0x67   BIT 4, A
        .db     B4 + I_CB                ; 0x68   BIT 5, B
        .db     B4 + I_CB                ; 0x69   BIT 5, C
        .db     B4 + I_CB                ; 0x6A   BIT 5, D
        .db     B4 + I_CB                ; 0x6B   BIT 5, E
        .db     B4 + I_CB                ; 0x6C   BIT 5, H
        .db     B4 + I_CB                ; 0x6D   BIT 5, L
        .db     B4 + I_CB                ; 0x6E   BIT 5, (IY+d)
        .db     B4 + I_CB                ; 0x6F   BIT 5, A
        .db     B4 + I_CB                ; 0x70   BIT 6, B
        .db     B4 + I_CB                ; 0x71   BIT 6, C
        .db     B4 + I_CB                ; 0x72   BIT 6, D
        .db     B4 + I_CB                ; 0x73   BIT 6, E
        .db     B4 + I_CB                ; 0x74   BIT 6, H
        .db     B4 + I_CB                ; 0x75   BIT 6, L
        .db     B4 + I_CB                ; 0x76   BIT 6, (IY+d)
        .db     B4 + I_CB                ; 0x77   BIT 6, A
        .db     B4 + I_CB                ; 0x78   BIT 7, B
        .db     B4 + I_CB                ; 0x79   BIT 7, C
        .db     B4 + I_CB                ; 0x7A   BIT 7, D
        .db     B4 + I_CB                ; 0x7B   BIT 7, E
        .db     B4 + I_CB                ; 0x7C   BIT 7, H
        .db     B4 + I_CB                ; 0x7D   BIT 7, L
        .db     B4 + I_CB                ; 0x7E   BIT 7, (IY+d)
        .db     B4 + I_CB                ; 0x7F   BIT 7, A
        .db     B4 + I_CB                ; 0x80   RES 0, B
        .db     B4 + I_CB                ; 0x81   RES 0, C
        .db     B4 + I_CB                ; 0x82   RES 0, D
        .db     B4 + I_CB                ; 0x83   RES 0, E
        .db     B4 + I_CB                ; 0x84   RES 0, H
        .db     B4 + I_CB                ; 0x85   RES 0, L
        .db     B4 + I_CB                ; 0x86   RES 0, (IY+d)
        .db     B4 + I_CB                ; 0x87   RES 0, A
        .db     B4 + I_CB                ; 0x88   RES 1, B
        .db     B4 + I_CB                ; 0x89   RES 1, C
        .db     B4 + I_CB                ; 0x8A   RES 1, D
        .db     B4 + I_CB                ; 0x8B   RES 1, E
        .db     B4 + I_CB                ; 0x8C   RES 1, H
        .db     B4 + I_CB                ; 0x8D   RES 1, L
        .db     B4 + I_CB                ; 0x8E   RES 1, (IY+d)
        .db     B4 + I_CB                ; 0x8F   RES 1, A
        .db     B4 + I_CB                ; 0x90   RES 2, B
        .db     B4 + I_CB                ; 0x91   RES 2, C
        .db     B4 + I_CB                ; 0x92   RES 2, D
        .db     B4 + I_CB                ; 0x93   RES 2, E
        .db     B4 + I_CB                ; 0x94   RES 2, H
        .db     B4 + I_CB                ; 0x95   RES 2, L
        .db     B4 + I_CB                ; 0x96   RES 2, (IY+d)
        .db     B4 + I_CB                ; 0x97   RES 2, A
        .db     B4 + I_CB                ; 0x98   RES 3, B
        .db     B4 + I_CB                ; 0x99   RES 3, C
        .db     B4 + I_CB                ; 0x9A   RES 3, D
        .db     B4 + I_CB                ; 0x9B   RES 3, E
        .db     B4 + I_CB                ; 0x9C   RES 3, H
        .db     B4 + I_CB                ; 0x9D   RES 3, L
        .db     B4 + I_CB                ; 0x9E   RES 3, (IY+d)
        .db     B4 + I_CB                ; 0x9F   RES 3, A
        .db     B4 + I_CB                ; 0xA0   RES 4, B
        .db     B4 + I_CB                ; 0xA1   RES 4, C
        .db     B4 + I_CB                ; 0xA2   RES 4, D
        .db     B4 + I_CB                ; 0xA3   RES 4, E
        .db     B4 + I_CB                ; 0xA4   RES 4, H
        .db     B4 + I_CB                ; 0xA5   RES 4, L
        .db     B4 + I_CB                ; 0xA6   RES 4, (IY+d)
        .db     B4 + I_CB                ; 0xA7   RES 4, A
        .db     B4 + I_CB                ; 0xA8   RES 5, B
        .db     B4 + I_CB                ; 0xA9   RES 5, C
        .db     B4 + I_CB                ; 0xAA   RES 5, D
        .db     B4 + I_CB                ; 0xAB   RES 5, E
        .db     B4 + I_CB                ; 0xAC   RES 5, H
        .db     B4 + I_CB                ; 0xAD   RES 5, L
        .db     B4 + I_CB                ; 0xAE   RES 5, (IY+d)
        .db     B4 + I_CB                ; 0xAF   RES 5, A
        .db     B4 + I_CB                ; 0xB0   RES 6, B
        .db     B4 + I_CB                ; 0xB1   RES 6, C
        .db     B4 + I_CB                ; 0xB2   RES 6, D
        .db     B4 + I_CB                ; 0xB3   RES 6, E
        .db     B4 + I_CB                ; 0xB4   RES 6, H
        .db     B4 + I_CB                ; 0xB5   RES 6, L
        .db     B4 + I_CB                ; 0xB6   RES 6, (IY+d)
        .db     B4 + I_CB                ; 0xB7   RES 6, A
        .db     B4 + I_CB                ; 0xB8   RES 7, B
        .db     B4 + I_CB                ; 0xB9   RES 7, C
        .db     B4 + I_CB                ; 0xBA   RES 7, D
        .db     B4 + I_CB                ; 0xBB   RES 7, E
        .db     B4 + I_CB                ; 0xBC   RES 7, H
        .db     B4 + I_CB                ; 0xBD   RES 7, L
        .db     B4 + I_CB                ; 0xBE   RES 7, (IY+d)
        .db     B4 + I_CB                ; 0xBF   RES 7, A
        .db     B4 + I_CB                ; 0xC0   SET 0, B
        .db     B4 + I_CB                ; 0xC1   SET 0, C
        .db     B4 + I_CB                ; 0xC2   SET 0, D
        .db     B4 + I_CB                ; 0xC3   SET 0, E
        .db     B4 + I_CB                ; 0xC4   SET 0, H
        .db     B4 + I_CB                ; 0xC5   SET 0, L
        .db     B4 + I_CB                ; 0xC6   SET 0, (IY+d)
        .db     B4 + I_CB                ; 0xC7   SET 0, A
        .db     B4 + I_CB                ; 0xC8   SET 1, B
        .db     B4 + I_CB                ; 0xC9   SET 1, C
        .db     B4 + I_CB                ; 0xCA   SET 1, D
        .db     B4 + I_CB                ; 0xCB   SET 1, E
        .db     B4 + I_CB                ; 0xCC   SET 1, H
        .db     B4 + I_CB                ; 0xCD   SET 1, L
        .db     B4 + I_CB                ; 0xCE   SET 1, (IY+d)
        .db     B4 + I_CB                ; 0xCF   SET 1, A
        .db     B4 + I_CB                ; 0xD0   SET 2, B
        .db     B4 + I_CB                ; 0xD1   SET 2, C
        .db     B4 + I_CB                ; 0xD2   SET 2, D
        .db     B4 + I_CB                ; 0xD3   SET 2, E
        .db     B4 + I_CB                ; 0xD4   SET 2, H
        .db     B4 + I_CB                ; 0xD5   SET 2, L
        .db     B4 + I_CB                ; 0xD6   SET 2, (IY+d)
        .db     B4 + I_CB                ; 0xD7   SET 2, A
        .db     B4 + I_CB                ; 0xD8   SET 3, B
        .db     B4 + I_CB                ; 0xD9   SET 3, C
        .db     B4 + I_CB                ; 0xDA   SET 3, D
        .db     B4 + I_CB                ; 0xDB   SET 3, E
        .db     B4 + I_CB                ; 0xDC   SET 3, H
        .db     B4 + I_CB                ; 0xDD   SET 3, L
        .db     B4 + I_CB                ; 0xDE   SET 3, (IY+d)
        .db     B4 + I_CB                ; 0xDF   SET 3, A
        .db     B4 + I_CB                ; 0xE0   SET 4, B
        .db     B4 + I_CB                ; 0xE1   SET 4, C
        .db     B4 + I_CB                ; 0xE2   SET 4, D
        .db     B4 + I_CB                ; 0xE3   SET 4, E
        .db     B4 + I_CB                ; 0xE4   SET 4, H
        .db     B4 + I_CB                ; 0xE5   SET 4, L
        .db     B4 + I_CB                ; 0xE6   SET 4, (IY+d)
        .db     B4 + I_CB                ; 0xE7   SET 4, A
        .db     B4 + I_CB                ; 0xE8   SET 5, B
        .db     B4 + I_CB                ; 0xE9   SET 5, C
        .db     B4 + I_CB                ; 0xEA   SET 5, D
        .db     B4 + I_CB                ; 0xEB   SET 5, E
        .db     B4 + I_CB                ; 0xEC   SET 5, H
        .db     B4 + I_CB                ; 0xED   SET 5, L
        .db     B4 + I_CB                ; 0xEE   SET 5, (IY+d)
        .db     B4 + I_CB                ; 0xEF   SET 5, A
        .db     B4 + I_CB                ; 0xF0   SET 6, B
        .db     B4 + I_CB                ; 0xF1   SET 6, C
        .db     B4 + I_CB                ; 0xF2   SET 6, D
        .db     B4 + I_CB                ; 0xF3   SET 6, E
        .db     B4 + I_CB                ; 0xF4   SET 6, H
        .db     B4 + I_CB                ; 0xF5   SET 6, L
        .db     B4 + I_CB                ; 0xF6   SET 6, (IY+d)
        .db     B4 + I_CB                ; 0xF7   SET 6, A
        .db     B4 + I_CB                ; 0xF8   SET 7, B
        .db     B4 + I_CB                ; 0xF9   SET 7, C
        .db     B4 + I_CB                ; 0xFA   SET 7, D
        .db     B4 + I_CB                ; 0xFB   SET 7, E
        .db     B4 + I_CB                ; 0xFC   SET 7, H
        .db     B4 + I_CB                ; 0xFD   SET 7, L
        .db     B4 + I_CB                ; 0xFE   SET 7, (IY+d)
        .db     B4 + I_CB                ; 0xFF   SET 7, A