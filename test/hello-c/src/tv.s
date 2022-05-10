        ;; tv.s
        ;; 
        ;; vram calculations
		;;
        ;; MIT License (see: LICENSE)
        ;; Copyright (C) 2021 Tomaz Stih
        ;;
		;; 2021-06-16   tstih
        .module tv

        .globl  _cls
        .globl  _print
        
        ;; addr. and sizes
        .equ    VMEMBEG, 0x4000         ; video ram
        .equ    VMEMSZE, 0x1800         ; raster size
        .equ    ATTRSZE, 0x02ff         ; attr size

        ;; ports
        .equ    BDRPORT, 0xfe           ; border port

        ;; constants
        .equ    BLACK, 0x00
        .equ    GREEN, 0x04


        .area   _CODE
        ;; given y (0...191) calc. row addr. in vmem
        ;; input:   b=y
        ;; output:  hl=vmem address, a=l
        ;; affects: flags, a, hl
tv_rowaddr::
        ld      a,b                     ; get y0-y2 to acc.
        and     #0x07                   ; mask out 00000111
        or      #0x40                   ; vmem addr
        ld      h,a                     ; to h
        ld      a,b                     ; y to acc. again
        rrca
        rrca
        rrca
        and     #0x18                   ; y6,y7 to correct pos.
        or      h                       ; h or a
        ld      h,a                     ; store to h
        ld      a,b                     ; y back to a
        rla                             ; move y3-y5 to position
        rla
        and     #0xe0                   ; mask out 11100000
        ld      l,a                     ; to l
        ret


        ;; given hl get next row address in vmem
        ;; input:   hl=address
        ;; output:  hl=next row address
        ;; affects: flags, a, hl
tv_nextrow::
        inc     h
        ld      a,h
        and     #7
        jr      nz,tvnr_done
        ld      a,l
        add     a,#32
        ld      l,a
        jr      c,tvnr_done
        ld      a,h
        sub     #8
        ld      h,a
tvnr_done:
        ret


        ;; clears the screen using background
        ;; and foreground color 
        ;; input:   a=background color
        ;;          b=foreground color
        ;; affects: af, hl, de, bc
tv_cls::
        out     (#BDRPORT),a            ; set border
        ;; prepare attr
        rlca                            ; bits 3-5
        rlca
        rlca
        or      b                       ; ink color to bits 0-2
        ;; first vmem
        ld      hl,#VMEMBEG             ; vmem
        ld      bc,#VMEMSZE             ; size
        ld      (hl),l                  ; l=0
        ld      d,h
        ld      e,#1
        ldir                            ; cls
        ld      (hl),a                  ; attr
        ld      bc,#ATTRSZE             ; size of attr
        ldir
        ret

        ;; ----------
        ;; void cls()
        ;; ----------
        ;; clears the screen using black background 
        ;; color and green foreground color
        ;; affects: af, hl, de, bc
_cls::
        ;; first clear screen
        ld      a,#BLACK
        ld      b,#GREEN
        call    tv_cls
        ret

        ;; -----------------
        ;; void print(
        ;;  unsigned char x,
        ;;  unsigned char y,
        ;;  const char *s)
        ;; -----------------
        ;; prints string at x,y
        ;; affects: flags, a, bc, de, hl
_print::
        ;; get arguments from stack
        pop     hl                      ; ret addr.
        pop     bc                      ; b=y, c=x
        pop     de                      ; de=string
        ;; restore stack
        push    de
        push    bc
        push    hl
        ;; calc. address and store to hl
        sla     b                       ; b=b*2
        sla     b                       ; b=b*4
        sla     b                       ; b=b*8
        call    tv_rowaddr              ; hl=vid row
        push    de                      ; store de
        ld      d,#0
        ld      e,c                     ; de=x
        add     hl,de                   ; to correct address
        pop     de                      ; de=ptr (again)
        ;; loop all characters
prn_loop:
        ld      a,(de)                  ; get char
        or      a                       ; end of string?
        ret     z
        call    prn_drawch              ; print char in a to hl
        inc     de                      ; next char.
        inc     hl                      ; next vmem addr.
        jr      prn_loop
prn_drawch:
        push    hl                      ; store hl
        exx                             ; don't touch de and hl
        sub     #32                     ; first char is space
        ld      d,#0                    ; code to de
        ld      e,a
        sla     e                       ; de=de*2
        rl      d
        sla     e                       ; de=de*4
        rl      d
        sla     e                       ; de=de*8
        rl      d
        ld      hl,#binnacle_font       ; font address to hl
        add     hl,de                   ; hl=char ptr.
        ex      de,hl                   ; de=char ptr.
        pop     hl                      ; restore hl'=addr
        ld      b,#8                    ; 8 chars
prndc_put:
        ld      a,(de)                  ; font line to a
        inc     de                      ; next font line
        ld      (hl),a                  ; to screen
        call    tv_nextrow              ; next screen row
        djnz    prndc_put               ; 8 times...
        exx
        ret