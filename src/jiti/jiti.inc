        ;; jiti.inc
        ;; 
        ;; Just in time constants.
		;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
		;; 10.05.2022    tstih
        
        .globl  opcodes

        ;; rst opcodes
        .equ    RST00,      0xC7
        .equ    RST08,      0xCF
        .equ    RST10,      0xD7
        .equ    RST18,      0xDF
        .equ    RST20,      0xE7
        .equ    RST28,      0xEF
        .equ    RST30,      0xF7
        .equ    RST38,      0xFF

        ;; instruction length, first 2 bits
        .equ    B0,         0b00000000  ; ED,CB,DD,FD = 1 byte
        .equ    B1,         0b00000000  ; 1 byte instruction
        .equ    B2,         0b00000001  ; 2 byte instruction
        .equ    B3,         0b00000010  ; 3 byte instruction
        .equ    B4,         0b00000011  ; 4 byte instruction

        ;; instruction class, next 6 bits
        .equ    I_IGN,      0b00000000  ; not interesting
        .equ    I_ED,       0b00000100  ; ED prefix
        .equ    I_CB,       0b00001000  ; CB prefix
        .equ    I_DD,       0b00001100  ; DD prefix
        .equ    I_FD,       0b00010000  ; FD prefix
        .equ    I_DJNZ,     0b00010100  ; DJNZ instruction
        .equ    I_JRCC,     0b00011000  ; conditional JR
        .equ    I_RETCC,    0b00011100  ; conditional RET
        .equ    I_JPCC,     0b00100000  ; conditional JP
        .equ    I_CALLCC,   0b00100100  ; conditional CALL
        .equ    I_RST,      0b00101000  ; RST call
        .equ    I_JR,       0b00101100  ; unconditional JR
        .equ    I_JP,       0b00110000  ; unconditional JP
        .equ    I_RET_,     0b00110100  ; unconditional RET
        .equ    I_CALL,     0b00111000  ; unconditional CALL
        .equ    I_JPRR,     0b01000000  ; JP (reg16)
        .equ    I_RET,      0b01001000  ; RET

        .area   _CODE
        ;; table of basic opcodes for decoding 
        ;; instruction length and type.
opcodes:
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
        .db     B2 + I_DJNZ             ;0x10   DJNZ %
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


        ;; MANUAL PARSING
        ;;  1. 0xCB instructions
        ;;     if opcode starts with 0x?6 or 0x?e -> hl address
        ;;     instruction len is always 2
        ;;  2. 0xED instructions
        ;;     0x43, 0x53, 0x63, 0x73 -> direct mem. 
        ;;     instruction len is 4
        ;;     0x4b, 0x5b, 0x6b, 0x7b -> direct mem
        ;;     instruction len is 4
        ;;     all other instructions have a length of 2
        