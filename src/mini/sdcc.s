		;; sdcc.s
        ;; 
        ;; minimal sdcc library
		;;
        ;; MIT License (see: LICENSE)
        ;; copyright (c) 2022 tomaz stih
        ;;
		;; 31.03.2022    tstih
        .module sdcc

        .globl  __divuint
        .globl  __divuchar
        .globl  __moduchar
        .globl  __moduint

        .area   _CODE
 __divuint::
        pop     af
        pop     hl
        pop     de
        push    de
        push    hl
        push    af
        jr      __divu16
__divuchar::
        ld      hl,#2+1
        add     hl,sp
        ld      e,(hl)
        dec     hl
        ld      l,(hl)
__divu8:
        ld      h,#0x00
        ld      d,h
      
__divu16:
        ld      a,e
        and     a,#0x80
        or      a,d
        jr      NZ,.morethan7bits
.atmost7bits:
        ld      b,#16          
        adc     hl,hl
.dvloop7:
        rla
        sub     a,e
        jr      NC,.nodrop7   
        add     a,e            
.nodrop7:
        ccf                               
        adc     hl,hl
        djnz    .dvloop7
        ld      e,a             
        ret
.morethan7bits:
        ld      b,#9           
        ld      a,l             
        ld      l,h           
        ld      h,#0
        rr      l              
.dvloop:
        adc     hl,hl           
        sbc     hl,de
        jr      NC,.nodrop      
        add     hl,de           
.nodrop:
        ccf                    
        rla
        djnz    .dvloop
        rl      b               
        ld      d,b
        ld      e,a           
        ex      de,hl           
        ret
__moduchar::
        ld      hl,#2+1
        add     hl,sp
        ld      e,(hl)
        dec     hl
        ld      l,(hl)
        call    __divu8
	    ex	de,hl
        ret
__moduint::
        pop     af
        pop     hl
        pop     de
        push    de
        push    hl
        push    af
        call    __divu16
        ex      de,hl
        ret    