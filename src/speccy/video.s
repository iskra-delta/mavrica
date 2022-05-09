		;; video.s
        ;; 
        ;; video ram functions
		;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
		;; 05.05.2022    tstih
        .module video

        .globl  _vid_addr2xy
        .globl  _vid_write
        .globl  _vid_blit

        .equ    V_EMPTY,    0x00
        .equ    V_FULL,     0xff 
        .equ    V_50P,      0xaa

        .area   _CODE


        ;; ----- unsigned int vid_addr2xy(unsigned int addr) ------------------
_vid_addr2xy:
        pop     hl                      ; ret addr
        pop     de                      ; vram addr
        ;; restore stack
        push    de      
        push    hl
        ;; quick call
        ;; input:
        ;;  de=address
        ;; output:
        ;;  h=y, l=x
        ;; affects:
        ;;  a, hl
addr2xy:
        ;; calculate x
        ld      a,e
        and     #0b00011111             ; x to a
        ld      l,a                     ; x to l
        ld      a,d
        and     #0b00000111             ; y2-y0
        ld      h,a
        srl     d                       ; bits 
        srl     d
        srl     d
        ;; now 16 bit shift 2 times
        srl     d
        rr      e
        srl     d
        rr      e
        ld      a,e
        and     #0b11111000
        or      h
        ld      h,a
        ret     


        ;; ----- void vid_write(unsigned int addr, unsigned char value) -------
_vid_write:
        ;; get args and restore stack
        pop     hl
        pop     de                      ; de=addr
        pop     bc                      ; c=value
        push    bc
        push    de
        push    hl
        ;; convert address in de to h=y,l=x
        call    addr2xy
        ;; move to x,y
        xor     a                       ; a=0
        ld      d,a                     ; de=y
        ld      e,h                     
        ld      h,a                     ; hl=x
        ;; multily x in hl by 16
        sla     l
        rl      h
        sla     l
        rl      h
        sla     l
        rl      h
        sla     l
        rl      h
        ;; move cursor there
        call    gdp_set_xy
        ;; raw function to write byte
        ;; expects cursor at x,y and value in c
vid_write:
        ;; pen down
        ld      a,#0b00000010
        call    gdp_exec_cmd
        ;; last "color"
        ld      d,#2
        ;; 8 bits are in c
        ld      b,#8
vw_loop:
        sla     c                       ; get bit out
        jr      c,vw_set
        ;; select pen
        xor     a
        cp      d                       ; no change?
        jr      z,vw_draw
        ld      d,a                     ; set new d
        call    gdp_exec_cmd            ; select pen
        jr      vw_draw
vw_set:
        ld      a,#0b00000001           ; select eraser
        cp      d
        jr      z,vw_draw               ; no change...
        ld      d,a
        call    gdp_exec_cmd
vw_draw:
        ;; last pixel?
        ld      a,b
        cp      #1
        jr      z,vw_2pix
        ld      a,#0b11000000           ; 3 pixels
        jr      vw_pix_done
vw_2pix:
        ld      a,#0b10100000           ; last 2 pixels
vw_pix_done:
        call    gdp_exec_cmd
        djnz    vw_loop
        ;; pen up
        ld      a,#0b00000011
        call    gdp_exec_cmd
        ;; move 1 pixel to the right
        ld      a,#0b10100000
        call    gdp_exec_cmd
        ret

        ;; ----- void vid_blit(unsigned int addr) -----------------------------
        ;; blit image to screen
        ;; register usage
        ;;  de' ... logical vmem address (spec. adddress)
        ;;  hl' ... physical vmem address
        ;;   a  ... mostly byte from memory
        ;;   b  ... mostly counter
        ;;   c  ... storage for a
        ;;   d  ... previous value
        ;;   e  ... counter of prev. occurances
        ;;   l  ... command counterm for current row 
_vid_blit:
        exx
        ;; get address into hl' 
        pop     de
        pop     hl
        ;; restore stack
        push    hl
        push    de
        ;; de=logical vram ptr
        ld      de,#0x4000
        exx
        ;; vertical loop
        ld      a,#192                  ; 192 rows
vblt_row_loop:
        push    af                      ; store counter
        ;; initialize "vars"
        ld      iy,#vblt_cmds
        ld      b,#31                   ; 32-1 bytes per row
        ld      e,#1                    ; prev. repeat counter
        ld      l,#0                    ; no of commands
        exx
        ld      a,(hl)                  ; first char to a
        inc     hl                      ; next char
        exx
        ld      d,a                     ; prev=first
vblt_col_loop:
        ;; get next char into a
        exx
        ld      a,(hl)                  ; get a
        inc     hl                      ; next char
        exx
        cp      d                       ; compare to previous
        jr      z,vblt_repeat
        ;; write prev command and reset loop
        ld      (iy),d
        ld      1(iy),e
        inc     l                       ; inc. command counter
        ld      e,#0                    ; counter to 0
        ld      d,a                     ; prev to a
        inc     iy                      ; next cmd
        inc     iy
vblt_repeat:
        inc     e                       ; inc counter
        djnz    vblt_col_loop           ; the column loop
        ;; if we are here, there's one more char
        ld      (iy),d
        ld      1(iy),e
        inc     l                       ; increate comamnd counter
        ;; and draw row
        call    vblt_draw
        ;; the row loop
        pop     af
        dec     a
        jr      nz, vblt_row_loop
        ;; we're done
        ret
vblt_cmds:
        .ds     64
        ;; draw RLEd row...
vblt_draw:
        ;; move gdp cursor to start of row (0,y)
        exx
        ;; store regs
        push    hl
        push    de
        call    addr2xy                 ; get y to h, x to l
        ;; gdp_set_xy (hl=x,de=y)
        xor     a                       ; a=0
        ld      d,a                     ; de=y
        ld      e,h                     
        ld      hl,#0                   ; x=0
        ;; move graphics cursor to this position
        call    gdp_set_xy
        ;; restore regs
        pop     de
        pop     hl
        exx
        ;; process commands
        ld      b,l                     ; command counter
        ld      hl,#vblt_cmds           ; start of commands
vblt_draw_loop:
        ld      a,(hl)                  ; get value
        inc     hl
        ld      c,(hl)                  ; get repeats
        inc     hl        
        cp      #V_EMPTY
        jr      z,vblt_draw_white_line
        cp      #V_FULL
        jr      z,vblt_draw_black_line
        ;; TODO: V_50P
vblt_draw_byte:
        ;; draw byte, pattern=a,len=c
        push    bc                      ; store c
        push    af
        ld      c,a                     ; a to co for vid_write
        call    vid_write
        pop     af                      ; restore a
        pop     bc                      ; restore c   
        dec     c
        jr      nz,vblt_draw_byte
        jr      vblt_draw_done
vblt_draw_white_line:
        xor     a                       ; select pen
        call    gdp_exec_cmd
        ;; and draw line
        jr      vblt_draw_line
vblt_draw_black_line:
        ld      a,#0b00000001           ; select eraser
        call    gdp_exec_cmd
        ;; and draw line
vblt_draw_line:
        push    bc                      ; store counter!
        ;; multiply c (dx) by 16
        ld      b,#0
        sla     c
        rl      b
        sla     c
        rl      b
        sla     c
        rl      b
        sla     c
        rl      b
        ;; draw horz. line bc=dx
        call    gdp_hline
        ;; no need to jump to done here
        pop     bc                      ; restore counter!
vblt_draw_done:
        djnz    vblt_draw_loop
        ;; add 32 to logical DE 
        exx
        ld      a,e
        add     #32
        jr      nc,#vblt_draw_ret       ; overflow?
        inc     d
vblt_draw_ret:
        ld      e,a
        exx
        ret