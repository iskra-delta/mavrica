		;; crt0.s
        ;; 
        ;; a minimal crt0.s startup code for Iskra Delta Partner program
        ;; 
        ;; TODO: 
        ;;  - handle cmd line
		;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
		;; 22.03.2022    tstih
		.module crt0cpm

       	.globl  _main
        .globl  _heap

		.area 	_CODE
start:
        ;; define a stack   
        ld      sp,#stack

        ;; SDCC init globals
        call    gsinit

        ;; load argc and argv to stack for the main function
        call    pargs
        ld      hl, #argv
        push    hl
        ld      hl, (argc)
        push    hl

        ;; call the main
	    call    _main

        ;; BDOS exit (reset) return control to CP/M.
        ld      c,#0
	    jp      5

		;; Ordering of segments for the linker (after header)
		.area 	_CODE
        .area   _GSINIT
        .area   _GSFINAL	
        .area   _HOME
        .area   _INITIALIZER
        .area   _INITFINAL
        .area   _INITIALIZED
        .area   _DATA
        .area   _BSS
        .area	_STACK
        .area   _HEAP


        ;; init code for functions/var.
        .area   _GSINIT
gsinit::      
        ;; copy statics.
        ld      bc, #l__INITIALIZER
        ld      a, b
        or      a, c
        jr      Z, gsinit_done
        ld      de, #s__INITIALIZED
        ld      hl, #s__INITIALIZER
        ldir
gsinit_done:
        .area   _GSFINAL
        ret


        ;; parse command line in CP/M
pargs:
        ld      de,#0x80                ; args start
        ld      hl,argv                 ; argv pointers
        ;; first pointer is NULL
        xor     a
        ld      (hl),a
        inc     hl
        ld      (hl),a
        inc     (hl)                    ;; hl points to first "real" argv
        ;; let de point to first char
        ld      a,(de)                  ; get number of bytes to b
        inc     a                       ; end
        ld      b,a                     ; b is counter
        inc     de                      ; de points to first char
        push    de                      ; "remember" start of current arg
        ;; argc=1 (default)
        xor     a
        ld      (args+1),a
        inc     a
        ld      (args),a
pargs_loop:
        ;; now iterate
        ld      a,(de)
        cp      #0                      ; end of args?
        jr      z,pargs_end
        cp      #' '                    ; space is next arg
        jr      pargs_next
        ;; if we're here it's default...
        ;; TODO: normal
        djnz    pargs_loop
pargs_next:
        xor     a
        ld      (de),a
        djnz    pargs_loop
pargs_end:
        ;; TOOD: get current arg from stack...
        ;; compare to DE, if equal - no arg!
        ;; TODO: store HL
        push    de                      ; store de
        exx
        pop     de
        pop     hl
        or      a                       ; clear flags
        sbc     de,hl                   ; compare
        exx
        ret     z                       ; return if equal
        ;; else store arg!
        exx
        push    hl
        exx
pargs_store:
        pop     de
        ld      (hl),e
        inc     hl
        ld      (hl),d
        inc     hl
        ret


        .area   _DATA
argc:
        .dw 1                           ; default argc is 1 (filename!)
argv:
        .ds 16                          ; max 8 argv arguments


        .area	_STACK
	    .ds	    1024
stack:


        .area   _HEAP
_heap::                                 ; start of our heap.