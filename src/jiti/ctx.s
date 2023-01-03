        ;; ctx.s
        ;; 
        ;; the code to store and restore context, required by
        ;; the just in time compiler and the reset vector
        ;; handler.
        ;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
        ;; 05.05.2022    tstih
        .module ctx

        .globl  ctx_store
        .globl  ctx_restore
        .globl  ctx_call

        .area   _CODE
        ;; store (used) registers and sp 
        ;; of the emulated process...
        ;; inputs: return address on stack
        ;; output: emulated process regs on stack
ctx_store::
        ld      (ctx_hl),hl             ; store hl
        ld      (ctx_sp),sp             ; store sp
        ld      sp,#ctx_sp              ; set sp space before ctx_sp...
        ex      (sp),hl                 ; return address to hl
        push    af                      ; store a and flags!
        push    bc
        push    de
        ld      sp,(ctx_sp)             ; restore stack...
        jp      (hl)

ctx_restore::
        ;; restore regs and flags
        ld      hl,(ctx_hl)
        pop     de
        pop     bc
        pop     af

        ;; and return!
        ld      sp,(ctx_sp)
        ret


ctx_set_bookmark::

ctx_jump_bookmark::



;; context stack (registers)
ctx_de: .ds     2                       ; de
ctx_af: .ds     2                       ; af
ctx_sp: .ds     2                       ; space for stack poi
ctx_hl: .ds     2                       ; hl
ctx_call:
        .ds    2                        ; return to main()