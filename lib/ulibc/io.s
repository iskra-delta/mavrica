		;; io.s
        ;; 
        ;; minimal io ops
		;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
		;; 14.04.2022    tstih
        .module io

        .globl _fparse

        ;; automata states
        .equ    S_START,        0
        .equ    S_AREA,         1
        .equ    S_END,          7

        ;; automata test
        .equ    T_ELSE,         0b00000000
        .equ    T_DIGIT,        0b00010000

        ;; automata functions
        .equ    FN_NONE,        0
        .equ    FN_APPEND_AREA, 1

        ;; return (status) codes
        .equ    R_SUCCESS,      0
        .equ    R_UNEXPECT_EOS, 1
        .equ    R_UNEXPECT_SYM, 2

        .area _CODE
        ;; ----- int fparse(char *path, fcb_t *fcb, uint8_t *area) ------------
_fparse::
        ;; fetch args from stack
        pop     af                      ; ignore the return address...
        pop     hl                      ; pointer to path to hl
        pop     de                      ; pointer to fdb to de
        pop     bc                      ; pointer to area to bc
        ;; restore stack and make iy point to it
        ld      iy,#-8
        add     iy,sp
        ld      sp,iy
        ;; we will use space from 2(iy) to 7(iy) as
        ;; local variables ... overwriting arguments
        ;; 2(iy) ... current automata state
        ;; 3(iy) ... error code
        ld      2(iy),#S_START          ; initial state to 2(iy)!
        ld      3(iy),#R_UNEXPECT_EOS   ; status is unexpected end of string
        ;; main loop
fpa_nextsym:
        ;; get next symbol
        ld      a,(hl)
        cp      #0                      ; end of string?
        jr      z,fpa_done
        push    hl                      ; store hl!
        ;; find transition
        call    fpa_find_transition
        ;; if not found then unexpected error
        jr      nz,fpa_done
        ;; else transition function id is in register l
        call    fpa_execfn
        jr      nz,fpa_done             ; if not zero then status!
        ;; loop
        pop     hl                      ; restore hl
        inc     hl                      ; next symbol
        jr      fpa_nextsym             ; and loop
        ;; find transition
fpa_find_transition:
        ld      hl,#fpa_automata        ; address of mealy automata
        ;; b=total transitions
        ld      b,#((efpa_automata-fpa_automata)/2)
        ld      c,a                     ; store a
fpaft_loop:
        ld      a,(hl)                  ; get first byte
        and     #0b00001111             ; get state
        cp      2(iy)                   ; is it current state?
        call    z,fpaft_test            ; call test
        jr      nz,fpaft_next           ; test failed, next trans.
        inc     hl                      ; get next byte
        ld      a,(hl)                  ; get second byte to a
        and     #0b00001111             ; grab next state
        ld      2(iy),a                 ; store to current state
        ld      a,(hl)                  ; get second byte to a
        and     #0b11110000             ; extract function
        ld      l,a                     ; get function to l
        ;; and return success
        xor     a
        ld      a,c
        ret
fpaft_next:
        inc     hl                      ; next state
        inc     hl
        djnz    fpaft_loop              ; and loop it
        ;; if we are here, we did not find
        ;; the transition. clear zero flag!
fpaft_unexpect_sym:
        ld      3(iy), #R_UNEXPECT_SYM
fpaft_set_z:
        xor     a
        cp      #0xff                   ; rest z flag
        ld      a,c                     ; resotre a
        ret
        ;; extract test from a and do it!
fpaft_test:
        ld      a,(hl)                  ; get a (again)
        and     #0b11110000             ; extract test
ftaft_t01:
        cp      #T_DIGIT                ; digit test?
        jr      nz,ftaft_t02
        ;; it is digit test
        ld      a,c                     ; symbol to a
        call    test_is_digit
        ret
ftaft_t02:
        cp      #T_ELSE                 ; else test?
        jr      nz,fpaft_set_z          ; set zero flag and ret
        ;; it is else test, it always succeeds
        xor     a                       ; set z flag
        ret

        ;; we're done parsing
fpa_done:
        pop     hl                      ; restore hl
        ;; TODO: check for success
        ret                             ; and return
        ;; execute function (fn code is in register l)
fpa_execfn:
        ld      h,a                     ; store a
        ld      a,l
        cp      #FN_NONE
        jr      z,fpafn_nofun           ; there is no function!
        cp      #FN_APPEND_AREA
        call    z,fpafn_append_area
        ;; if we are here, the function is invalid
        ld      3(iy),#INVALID_FN       ; invalid function error
        xor     a
        cp      #1                      ; reset z flag
        ret
        ;; automata functions
fpafn_nofun:
        xor     a                       ; success!
        ret
fpafn_append_area:
        xor     a                       ; success
        ret
        ;; each transition is 2 bytes
        ;; byte 0:
        ;;  TTTTSSSS    T=test, S=start
        ;; byte 1:
        ;;  FFFFEEEE    F=function, E=end
        ;; example:
        ;;  00010000, 00000001 (start=0, test=1, function=0, end=1)
fpa_automata:
        .db     S_START+T_DIGIT, S_AREA+F_APPEND_AREA
        .db     S_START+T_ELSE, S_END+F_NONE
        .db     S_AREA+T_DIGIT, S_AREA+F_APPEND_AREA
        .db     S_AREA+T_ELSE, S_END+F_NONE
efpa_automata: