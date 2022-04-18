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

        .equ    FN_NONE,                0
        .equ    FN_APPEND_AREA,         1

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
        ld      2(iy),#0                ; initial state to 2(iy)!
        ld      3(iy),#0                ; status code is 1 (UNEXPECTED EOS)
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