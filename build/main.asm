;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.6 #12391 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _printf
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
	G$main$0$0	= .
	.globl	G$main$0$0
	C$main.c$14$0_0$5	= .
	.globl	C$main.c$14$0_0$5
;jiti/main.c:14: int main(int argc, char *argv[]) {
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	ix
	ld	ix,#0
	add	ix,sp
	C$main.c$16$1_0$5	= .
	.globl	C$main.c$16$1_0$5
;jiti/main.c:16: printf("Total args %d\n", argc);
	ld	l, 4 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, 5 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, #___str_0
	push	hl
	call	_printf
	pop	af
	pop	af
	C$main.c$17$2_0$6	= .
	.globl	C$main.c$17$2_0$6
;jiti/main.c:17: for(int i=1;i<argc;i++)
	ld	bc, #0x0001
00103$:
	ld	a, c
	sub	a, 4 (ix)
	ld	a, b
	sbc	a, 5 (ix)
	jp	PO, 00118$
	xor	a, #0x80
00118$:
	jp	P, 00101$
	C$main.c$18$2_0$6	= .
	.globl	C$main.c$18$2_0$6
;jiti/main.c:18: printf("%s\n",argv[i]);
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ex	de,hl
	ld	l, 6 (ix)
	ld	h, 7 (ix)
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	bc
	push	de
	ld	hl, #___str_1
	push	hl
	call	_printf
	pop	af
	pop	af
	pop	bc
	C$main.c$17$2_0$6	= .
	.globl	C$main.c$17$2_0$6
;jiti/main.c:17: for(int i=1;i<argc;i++)
	inc	bc
	jr	00103$
00101$:
	C$main.c$20$1_0$5	= .
	.globl	C$main.c$20$1_0$5
;jiti/main.c:20: return 0;
	ld	hl, #0x0000
	C$main.c$21$1_0$5	= .
	.globl	C$main.c$21$1_0$5
;jiti/main.c:21: }
	pop	ix
	C$main.c$21$1_0$5	= .
	.globl	C$main.c$21$1_0$5
	XG$main$0$0	= .
	.globl	XG$main$0$0
	ret
Fmain$__str_0$0_0$0 == .
___str_0:
	.ascii "Total args %d"
	.db 0x0a
	.db 0x00
Fmain$__str_1$0_0$0 == .
___str_1:
	.ascii "%s"
	.db 0x0a
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
