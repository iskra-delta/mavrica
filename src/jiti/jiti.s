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
        ld      e,(iy)                  ; get block to hl
        ld      d,1(iy)
        ld      b,#20                   ; TODO:test 20 bytes
_comp_fetch:
        ld      a,(de)                  ; first instruction
        ld      hl,#opcodes             ; opcodes to hl
        push    de                      ; store de
        ld      d,#0                    ; opcode to de
        ld      e,a                     
        add     hl,de                   ; hl points to correct byte
        ld      a,(hl)                  ; get opcode
        cp      #(B4+1)                 ; a<4
        jr      c,_comp_skip            ; no instructions...
        ;; if we are here we have instruction type
        ld      c,a                     ; store a to c
        and     #0b11111100             ; get instruction type

        
        ;; TODO exit result
        ld      h,#0
        ld      l,a
        pop     de
        ret


        ld      a,c                     ; restore a
_comp_skip:
        ;; skip over instruction
        and     #0b00000011             ; only two bytes
        inc     a                       ; +1
        ld      e,a                     ; de=a
        pop     hl                      ; hl=stored de
        add     hl,de                   ; add instr.size
        ex      de,hl                   ; back to de
        djnz    _comp_fetch             ; TODO:test loop
        ret
laddr:
        .dw     1