		;; args.s
        ;; 
        ;; program arguments
		;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
		;; 22.03.2022    tstih
        .module args


        .globl  pargs
        .globl  argc
        .globl  argv


        .area   _CODE
        ;; parse command line in CP/M
pargs::
        ld      de,#0x80                ; args start
        ld      hl,argv                 ; argv pointers
        ;; first pointer is NULL
        xor     a
        ld      (hl),a
        inc     hl
        ld      (hl),a
        inc     hl                      ; hl points to first "real" argv
        ;; let de point to first char
        ld      a,(de)                  ; get number of bytes to b
        inc     a                       ; end
        ld      b,a                     ; b is counter
        inc     de                      ; de points to first char
        push    de                      ; "remember" start of current arg
        ;; argc=1 (default)
        xor     a
        ld      (argc+1),a
        inc     a
        ld      (argc),a
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
        ;; TODO
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
argc::
        .dw 1                           ; default argc is 1 (filename!)
argv::
        .ds 16                          ; max 8 argv arguments
