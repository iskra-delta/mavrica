        ;; z80 constants, used in multiple places
	;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
	;; 20.06.2025   tstih

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
        .equ    I_CBHL,     0b00010100  ; CB operation on HL
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
        .equ    I_IO,       0b01010000  ; IN/OUT
        .equ    I_MEMIND,   0b01011000  ; memory indirect
        .equ    I_UNDOCUMENTED, 0b01100000  ; undocumented instruction  