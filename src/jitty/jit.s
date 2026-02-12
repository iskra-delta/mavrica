        ;; Table-driven JIT runtime for Z80-on-Z80 execution.
        ;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
        .module jit

        .globl  jit_init
        .globl  jit_run
        .globl  jit_compile_block
        .globl  jit_trap

        .globl  decode

        .include "z80_consts.inc"

        .equ    BLOCK_MAX,       64
        .equ    BLOCK_SIZE,      12

        .equ    BLK_START_LO,    0
        .equ    BLK_START_HI,    1
        .equ    BLK_END_LO,      2
        .equ    BLK_END_HI,      3
        .equ    BLK_TRAP_LO,     4
        .equ    BLK_TRAP_HI,     5
        .equ    BLK_ORIG0,       6
        .equ    BLK_ORIG1,       7
        .equ    BLK_ORIG2,       8
        .equ    BLK_ORIG3,       9
        .equ    BLK_DESC,        10
        .equ    BLK_FLAGS,       11

        .area   _DATA
jit_block_count: .db     0
jit_blocks:      .ds     BLOCK_MAX*BLOCK_SIZE

jit_block_start: .dw     0
jit_instr_addr:  .dw     0
jit_next_pc:     .dw     0
jit_desc:        .db     0
jit_len:         .db     0

jit_trap_addr:   .dw     0
jit_target_pc:   .dw     0
jit_desc_class:  .db     0
jit_op0:         .db     0
jit_op1:         .db     0
jit_op2:         .db     0

jit_guest_a:     .db     0
jit_guest_f:     .db     0
jit_guest_bc:    .dw     0
jit_guest_de:    .dw     0
jit_guest_hl:    .dw     0
jit_guest_sp:    .dw     0

jit_host_stack:      .ds 128
jit_host_stack_top:

        .area   _CODE
;; --------------------------------------------------------------
;; jit_init() - clear block registry
jit_init:
        xor     a
        ld      (jit_block_count), a
        ret

;; --------------------------------------------------------------
;; jit_run(hl) - compile entry block and jump to guest code
;; input(s):
;;      hl ... guest entry point
jit_run:
        push    hl
        call    jit_compile_block
        pop     hl
        jp      (hl)

;; --------------------------------------------------------------
;; jit_compile_block(hl) - compile a basic block if not compiled
;; input(s):
;;      hl ... guest block start
jit_compile_block:
        push    hl
        call    jit_find_block_start
        jr      c, jit_cb_exists
        pop     hl
        ld      (jit_block_start), hl
jit_cb_scan:
        ld      (jit_instr_addr), hl
        call    decode
        ld      (jit_desc), a
        and     #0x03
        inc     a
        ld      (jit_len), a
        ld      a, (jit_desc)
        and     #0xfc
        call    jit_is_exit

        ld      hl, (jit_instr_addr)
        ld      a, (jit_len)
        ld      e, a
        ld      d, #0
        add     hl, de
        ld      (jit_next_pc), hl
        jr      z, jit_cb_finish
        ld      hl, (jit_next_pc)
        jr      jit_cb_scan

jit_cb_finish:
        call    jit_alloc_block
        ret     nc

        ld      de, (jit_block_start)
        ld      (hl), e
        inc     hl
        ld      (hl), d
        inc     hl

        ld      de, (jit_next_pc)
        ld      (hl), e
        inc     hl
        ld      (hl), d
        inc     hl

        ld      de, (jit_instr_addr)
        ld      (hl), e
        inc     hl
        ld      (hl), d
        inc     hl

        ld      a, (de)
        ld      (hl), a
        inc     hl
        inc     de
        ld      a, (de)
        ld      (hl), a
        inc     hl
        inc     de
        ld      a, (de)
        ld      (hl), a
        inc     hl
        inc     de
        ld      a, (de)
        ld      (hl), a
        inc     hl

        ld      a, (jit_desc)
        ld      (hl), a
        inc     hl
        xor     a
        ld      (hl), a

        ld      de, (jit_instr_addr)
        ld      a, #RST38
        ld      (de), a
        ret

jit_cb_exists:
        pop     hl
        ret

;; --------------------------------------------------------------
;; jit_trap() - RST 38h handler for patched block exits
jit_trap:
        ld      (jit_guest_hl), hl
        ld      (jit_guest_de), de
        ld      (jit_guest_bc), bc
        push    af
        pop     bc
        ld      a, b
        ld      (jit_guest_a), a
        ld      a, c
        ld      (jit_guest_f), a

        pop     hl
        dec     hl
        ld      (jit_trap_addr), hl
        ld      (jit_guest_sp), sp
        ld      sp, #jit_host_stack_top

        ld      hl, (jit_trap_addr)
        call    jit_find_block_trap
        jr      c, jit_trap_found
jit_trap_panic:
        di
        jr      jit_trap_panic

jit_trap_found:
        push    hl
        ld      a, l
        add     a, #BLK_DESC
        ld      l, a
        jr      nc, jit_tf_0
        inc     h
jit_tf_0:
        ld      a, (hl)
        and     #0xfc
        ld      (jit_desc_class), a
        pop     hl

        push    hl
        ld      a, l
        add     a, #BLK_ORIG0
        ld      l, a
        jr      nc, jit_tf_1
        inc     h
jit_tf_1:
        ld      a, (hl)
        ld      (jit_op0), a
        inc     hl
        ld      a, (hl)
        ld      (jit_op1), a
        inc     hl
        ld      a, (hl)
        ld      (jit_op2), a
        pop     hl

        push    hl
        ld      a, l
        add     a, #BLK_END_LO
        ld      l, a
        jr      nc, jit_tf_2
        inc     h
jit_tf_2:
        ld      a, (hl)
        ld      (jit_target_pc), a
        inc     hl
        ld      a, (hl)
        ld      (jit_target_pc+1), a
        pop     hl

        ld      a, (jit_desc_class)
        cp      #I_JR
        jp      z, jit_emul_jr
        cp      #I_JRCC
        jp      z, jit_emul_jrcc
        cp      #I_JP
        jp      z, jit_emul_jp
        cp      #I_JPCC
        jp      z, jit_emul_jpcc
        cp      #I_CALL
        jp      z, jit_emul_call
        cp      #I_CALLCC
        jp      z, jit_emul_callcc
        cp      #I_RET
        jp      z, jit_emul_ret
        cp      #I_RETCC
        jp      z, jit_emul_retcc
        cp      #I_RST
        jp      z, jit_emul_rst
        cp      #I_JPRR
        jp      z, jit_emul_jprr
        jp      jit_trap_dispatch

jit_emul_jr:
        ld      a, (jit_op1)
        call    jit_set_rel_target
        jp      jit_trap_dispatch

jit_emul_jrcc:
        ld      a, (jit_op0)
        call    jit_eval_jrcc
        jp      nc, jit_trap_dispatch
        ld      a, (jit_op1)
        call    jit_set_rel_target
        jp      jit_trap_dispatch

jit_emul_jp:
        ld      a, (jit_op1)
        ld      (jit_target_pc), a
        ld      a, (jit_op2)
        ld      (jit_target_pc+1), a
        jp      jit_trap_dispatch

jit_emul_jpcc:
        ld      a, (jit_op0)
        call    jit_eval_cc
        jp      nc, jit_trap_dispatch
        ld      a, (jit_op1)
        ld      (jit_target_pc), a
        ld      a, (jit_op2)
        ld      (jit_target_pc+1), a
        jp      jit_trap_dispatch

jit_emul_call:
        ld      hl, (jit_target_pc)
        call    jit_push_guest_word
        ld      a, (jit_op1)
        ld      (jit_target_pc), a
        ld      a, (jit_op2)
        ld      (jit_target_pc+1), a
        jr      jit_trap_dispatch

jit_emul_callcc:
        ld      a, (jit_op0)
        call    jit_eval_cc
        jr      nc, jit_trap_dispatch
        ld      hl, (jit_target_pc)
        call    jit_push_guest_word
        ld      a, (jit_op1)
        ld      (jit_target_pc), a
        ld      a, (jit_op2)
        ld      (jit_target_pc+1), a
        jr      jit_trap_dispatch

jit_emul_ret:
        call    jit_pop_guest_word
        ld      (jit_target_pc), hl
        jr      jit_trap_dispatch

jit_emul_retcc:
        ld      a, (jit_op0)
        call    jit_eval_cc
        jr      nc, jit_trap_dispatch
        call    jit_pop_guest_word
        ld      (jit_target_pc), hl
        jr      jit_trap_dispatch

jit_emul_rst:
        ld      hl, (jit_target_pc)
        call    jit_push_guest_word
        ld      a, (jit_op0)
        and     #0x38
        ld      l, a
        ld      h, #0x00
        ld      (jit_target_pc), hl
        jr      jit_trap_dispatch

jit_emul_jprr:
        ld      a, (jit_op0)
        cp      #0xe9
        jr      z, jit_jprr_hl
        cp      #0xdd
        jr      nz, jit_jprr_fd
        ld      a, (jit_op1)
        cp      #0xe9
        jr      nz, jit_trap_dispatch
        push    ix
        pop     hl
        ld      (jit_target_pc), hl
        jr      jit_trap_dispatch
jit_jprr_fd:
        ld      a, (jit_op0)
        cp      #0xfd
        jr      nz, jit_trap_dispatch
        ld      a, (jit_op1)
        cp      #0xe9
        jr      nz, jit_trap_dispatch
        push    iy
        pop     hl
        ld      (jit_target_pc), hl
        jr      jit_trap_dispatch
jit_jprr_hl:
        ld      hl, (jit_guest_hl)
        ld      (jit_target_pc), hl

jit_trap_dispatch:
        ld      hl, (jit_target_pc)
        push    hl
        call    jit_compile_block
        pop     hl

        ld      a, (jit_guest_a)
        ld      b, a
        ld      a, (jit_guest_f)
        ld      c, a
        push    bc
        pop     af
        ld      bc, (jit_guest_bc)
        ld      de, (jit_guest_de)
        ld      hl, (jit_guest_hl)
        ld      sp, (jit_guest_sp)
        ld      hl, (jit_target_pc)
        jp      (hl)

;; --------------------------------------------------------------
;; helper: set relative target from signed displacement in A
jit_set_rel_target:
        ld      e, a
        ld      d, #0x00
        bit     7, a
        jr      z, jit_srt_0
        ld      d, #0xff
jit_srt_0:
        ld      hl, (jit_trap_addr)
        inc     hl
        inc     hl
        add     hl, de
        ld      (jit_target_pc), hl
        ret

;; --------------------------------------------------------------
;; helper: evaluate JR cc (carry=true means branch is taken)
;; input(s): A=opcode (0x20/0x28/0x30/0x38)
jit_eval_jrcc:
        rrca
        rrca
        rrca
        and     #0x03
        jp      jit_eval_condcode

;; --------------------------------------------------------------
;; helper: evaluate generic cc (carry=true means branch is taken)
;; input(s): A=opcode (RET/JP/CALL cc forms)
jit_eval_cc:
        rrca
        rrca
        rrca
        and     #0x07
        jp      jit_eval_condcode

;; --------------------------------------------------------------
;; helper: evaluate cond code in A (0..7)
;; output(s): carry set if true, carry clear if false
jit_eval_condcode:
        cp      #0
        jr      z, jit_cc_nz
        cp      #1
        jr      z, jit_cc_z
        cp      #2
        jr      z, jit_cc_nc
        cp      #3
        jr      z, jit_cc_c
        cp      #4
        jr      z, jit_cc_po
        cp      #5
        jr      z, jit_cc_pe
        cp      #6
        jr      z, jit_cc_p
        ; code 7 = M
        ld      a, (jit_guest_f)
        bit     7, a
        jr      z, jit_cc_false
        scf
        ret
jit_cc_nz:
        ld      a, (jit_guest_f)
        bit     6, a
        jr      nz, jit_cc_false
        scf
        ret
jit_cc_z:
        ld      a, (jit_guest_f)
        bit     6, a
        jr      z, jit_cc_false
        scf
        ret
jit_cc_nc:
        ld      a, (jit_guest_f)
        bit     0, a
        jr      nz, jit_cc_false
        scf
        ret
jit_cc_c:
        ld      a, (jit_guest_f)
        bit     0, a
        jr      z, jit_cc_false
        scf
        ret
jit_cc_po:
        ld      a, (jit_guest_f)
        bit     2, a
        jr      nz, jit_cc_false
        scf
        ret
jit_cc_pe:
        ld      a, (jit_guest_f)
        bit     2, a
        jr      z, jit_cc_false
        scf
        ret
jit_cc_p:
        ld      a, (jit_guest_f)
        bit     7, a
        jr      nz, jit_cc_false
        scf
        ret
jit_cc_false:
        and     a
        ret

;; --------------------------------------------------------------
;; helper: push HL to guest stack
jit_push_guest_word:
        push    hl
        ld      hl, (jit_guest_sp)
        dec     hl
        dec     hl
        ld      (jit_guest_sp), hl
        ex      de, hl
        pop     hl
        ld      a, l
        ld      (de), a
        inc     de
        ld      a, h
        ld      (de), a
        ret

;; --------------------------------------------------------------
;; helper: pop word from guest stack to HL
jit_pop_guest_word:
        ld      de, (jit_guest_sp)
        ld      a, (de)
        ld      l, a
        inc     de
        ld      a, (de)
        ld      h, a
        inc     de
        ld      (jit_guest_sp), de
        ret

;; --------------------------------------------------------------
;; helper: classify block exits (Z=exit, NZ=non-exit)
;; input(s): A=descriptor class (masked with 0xfc)
jit_is_exit:
        cp      #I_JRCC
        ret     z
        cp      #I_RETCC
        ret     z
        cp      #I_JPCC
        ret     z
        cp      #I_CALLCC
        ret     z
        cp      #I_RST
        ret     z
        cp      #I_JR
        ret     z
        cp      #I_JP
        ret     z
        cp      #I_RET
        ret     z
        cp      #I_CALL
        ret     z
        cp      #I_JPRR
        ret     z
        or      #1
        ret

;; --------------------------------------------------------------
;; helper: allocate next block record
;; output(s): carry set + hl=record pointer on success
jit_alloc_block:
        ld      a, (jit_block_count)
        cp      #BLOCK_MAX
        jr      nc, jit_alloc_fail
        ld      b, a
        inc     a
        ld      (jit_block_count), a
        ld      hl, #jit_blocks
jit_alloc_loop:
        ld      a, b
        or      a
        jr      z, jit_alloc_ok
        ld      a, l
        add     a, #BLOCK_SIZE
        ld      l, a
        jr      nc, jit_alloc_0
        inc     h
jit_alloc_0:
        dec     b
        jr      jit_alloc_loop
jit_alloc_ok:
        scf
        ret
jit_alloc_fail:
        and     a
        ret

;; --------------------------------------------------------------
;; helper: find block by start address
;; input(s):  hl=block start
;; output(s): carry set + hl=record pointer if found
jit_find_block_start:
        ld      d, h
        ld      e, l
        ld      a, (jit_block_count)
        or      a
        jr      z, jit_fbs_fail
        ld      b, a
        ld      hl, #jit_blocks
jit_fbs_loop:
        ld      a, e
        cp      (hl)
        jr      nz, jit_fbs_next
        inc     hl
        ld      a, d
        cp      (hl)
        jr      z, jit_fbs_hit
        dec     hl
jit_fbs_next:
        ld      a, l
        add     a, #BLOCK_SIZE
        ld      l, a
        jr      nc, jit_fbs_0
        inc     h
jit_fbs_0:
        djnz    jit_fbs_loop
jit_fbs_fail:
        and     a
        ret
jit_fbs_hit:
        dec     hl
        scf
        ret

;; --------------------------------------------------------------
;; helper: find block by trap address
;; input(s):  hl=trap address
;; output(s): carry set + hl=record pointer if found
jit_find_block_trap:
        ld      d, h
        ld      e, l
        ld      a, (jit_block_count)
        or      a
        jr      z, jit_fbt_fail
        ld      b, a
        ld      hl, #jit_blocks
jit_fbt_loop:
        push    hl
        ld      a, l
        add     a, #BLK_TRAP_LO
        ld      l, a
        jr      nc, jit_fbt_0
        inc     h
jit_fbt_0:
        ld      a, e
        cp      (hl)
        jr      nz, jit_fbt_miss
        inc     hl
        ld      a, d
        cp      (hl)
        jr      z, jit_fbt_hit
jit_fbt_miss:
        pop     hl
        ld      a, l
        add     a, #BLOCK_SIZE
        ld      l, a
        jr      nc, jit_fbt_1
        inc     h
jit_fbt_1:
        djnz    jit_fbt_loop
jit_fbt_fail:
        and     a
        ret
jit_fbt_hit:
        pop     hl
        scf
        ret
