        ;; jiti.s
        ;; 
        ;; Just in time interpreter.
        ;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
        ;; 05.05.2022    tstih
        .module jiti

        .include "jiti.inc"

        .globl  _compile

        .area   _CODE
        ;; ----- uint16_t compile(void *block, uint16_t laddr) ---------------------
        ;; relocate and run zx spectrum code (block), 
        ;; logical address is laddr
_compile:   
        ;; iy points to args
        ld      iy,#2
        add     iy,sp
        ld      l,(iy)                  ; get block addr to hl
        ld      h,1(iy)
comp_fetch:
        ld      a,(hl)                  ; first instruction
        push    hl                      ; store block address
        ld      hl,#opcodes             ; table address to hl
        call    comp_table_fetch        ; fetch result to a
        push    af                      ; store translation
        cp      #(B4+1)                 ; a<4
        jr      c,comp_next            ; can ignore...
        ;; if we are here we have instruction type
        and     #0b11111100             ; get instruction type
        ;; now compare against know instruction types
        ;; and branch to it...return to comp_done
        cp      #I_ED
        jr      z,compile_ed
        cp      #I_CB
        jr      z,compile_cb
        cp      #I_DD
        jr      z,compile_dd
        cp      #I_FD
        jr      z,compile_fd
        ;; if we are here, we'll just insert the RST,
        ;; and store the location and the original code
        ;; to the tree...
comp_next:
        pop     af                      ; get back
        ;; skip over instruction
        and     #0b00000011             ; only two bytes
        inc     a                       ; +1
        ld      d,#0                    ; will use e of de
        ld      e,a                     ; de=a
        pop     hl                      ; hl=stored block addr.
        add     hl,de                   ; add instr.size
        jr      comp_fetch              ; next instruction

        ;; fetch indexed value into a
        ;; inputs:
        ;;      hl ... table address
        ;;      a  ... offset
        ;; output:
        ;;      a  ... value
comp_table_fetch:
        ld      d,#0                    ; use low byte of de
        ld      e,a                     ; de=offset
        add     hl,de                   ; hl points to result
        ld      a,(hl)                  ; to a
        ret
compile_ed:
compile_cb:
compile_dd:
compile_fd:
        jr      comp_next