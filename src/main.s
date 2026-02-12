        ;; Just in time compiler for Z80
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
	;; 21.06.2025   tstih
        .module main

	;; Set order of segments for the linker.
	.area 	_CODE
	.area 	_DATA

	.globl 	start
        .globl  jit_init
        .globl  jit_trap

        .area	_CODE
        jp      start
        .ds     0x35
        jp      jit_trap

start:
	di
        call    jit_init
tarpit: jr 	tarpit
