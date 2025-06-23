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

        .area	_CODE
start:
	di
tarpit: jr 	tarpit 