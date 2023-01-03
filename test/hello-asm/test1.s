        ;; test1.inc
        ;; 
        ;; Standard instructions test.
	;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
	;; 02.01.2023    tstih
        
        .area   _CODE
        ld      (store_sp),sp           ; 0000 ED 73 XX XX
        ld      sp,#0x9000              ; 0004 31 00 90
        ;; loop
        ld      b,#100                  ; 0007 06 64
loop:   djnz    loop                    ; 0009 10 FE
        xor     a                       ; 000B AF  
        ld      c,a                     ; 000C 4F
        push    bc                      ; 000D C5   
        pop     hl                      ; 000E E1  
        ld      a,h                     ; 000F 7C
        or      l                       ; 0010 B5 
        jr      z, cont                 ; 0011 28 04 
        nop                             ; 0013 00
        nop                             ; 0014 00
        nop                             ; 0015 00
        ;; dummy re, unreacable code
        ret                             ; 0016 C9 
cont:   ld      sp,(store_sp)           ; 0017 ED 7B XX XX 
        ret                             ; 001B C9
        .area   _DATA
store_sp:
        .ds     2                       ; XXXX YY YY