;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.6 #12391 (Linux)
;--------------------------------------------------------
	.module cpm
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _printf
	.globl _puts
	.globl _putchar
	.globl _bdos
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
	G$putchar$0$0	= .
	.globl	G$putchar$0$0
	C$cpm.c$14$0_0$4	= .
	.globl	C$cpm.c$14$0_0$4
;mini/cpm.c:14: int putchar(int c) {
;	---------------------------------
; Function putchar
; ---------------------------------
_putchar::
	C$cpm.c$16$1_0$4	= .
	.globl	C$cpm.c$16$1_0$4
;mini/cpm.c:16: if ((char)c=='\n') {
	ld	hl, #2
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x0a
	jr	NZ, 00102$
	C$cpm.c$17$2_0$5	= .
	.globl	C$cpm.c$17$2_0$5
;mini/cpm.c:17: bdos(C_WRITE,'\r');
	ld	hl, #0x000d
	push	hl
	ld	a, #0x02
	push	af
	inc	sp
	call	_bdos
	C$cpm.c$18$2_0$5	= .
	.globl	C$cpm.c$18$2_0$5
;mini/cpm.c:18: bdos(C_WRITE,'\n');
	inc	sp
	ld	hl,#0x000a
	ex	(sp),hl
	ld	a, #0x02
	push	af
	inc	sp
	call	_bdos
	pop	af
	inc	sp
	jr	00103$
00102$:
	C$cpm.c$19$1_0$4	= .
	.globl	C$cpm.c$19$1_0$4
;mini/cpm.c:19: } else bdos(C_WRITE,c);
	pop	de
	pop	hl
	push	hl
	push	de
	push	hl
	ld	a, #0x02
	push	af
	inc	sp
	call	_bdos
	pop	af
	inc	sp
00103$:
	C$cpm.c$20$1_0$4	= .
	.globl	C$cpm.c$20$1_0$4
;mini/cpm.c:20: return c;
	pop	de
	pop	hl
	push	hl
	push	de
	C$cpm.c$21$1_0$4	= .
	.globl	C$cpm.c$21$1_0$4
;mini/cpm.c:21: }
	C$cpm.c$21$1_0$4	= .
	.globl	C$cpm.c$21$1_0$4
	XG$putchar$0$0	= .
	.globl	XG$putchar$0$0
	ret
	G$puts$0$0	= .
	.globl	G$puts$0$0
	C$cpm.c$27$1_0$7	= .
	.globl	C$cpm.c$27$1_0$7
;mini/cpm.c:27: int puts(const char *s)
;	---------------------------------
; Function puts
; ---------------------------------
_puts::
	push	ix
	ld	ix,#0
	add	ix,sp
	C$cpm.c$30$1_0$7	= .
	.globl	C$cpm.c$30$1_0$7
;mini/cpm.c:30: if (s==NULL || s[0]==0) return 0;
	ld	a, 5 (ix)
	or	a, 4 (ix)
	jr	Z, 00101$
	ld	c, 4 (ix)
	ld	b, 5 (ix)
	ld	a, (bc)
	or	a, a
	jr	NZ, 00111$
00101$:
	ld	hl, #0x0000
	jr	00107$
	C$cpm.c$32$1_1$7	= .
	.globl	C$cpm.c$32$1_1$7
;mini/cpm.c:32: while(s[i]) { putchar(s[i]); i++; }
00111$:
	ld	de, #0x0000
00104$:
	ld	l, e
	ld	h, d
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	push	de
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	call	_putchar
	pop	af
	pop	de
	pop	bc
	inc	de
	jr	00104$
00106$:
	C$cpm.c$33$1_1$8	= .
	.globl	C$cpm.c$33$1_1$8
;mini/cpm.c:33: return 1;
	ld	hl, #0x0001
00107$:
	C$cpm.c$34$1_1$7	= .
	.globl	C$cpm.c$34$1_1$7
;mini/cpm.c:34: }
	pop	ix
	C$cpm.c$34$1_1$7	= .
	.globl	C$cpm.c$34$1_1$7
	XG$puts$0$0	= .
	.globl	XG$puts$0$0
	ret
	Fcpm$_prints$0$0	= .
	.globl	Fcpm$_prints$0$0
	C$cpm.c$44$1_1$11	= .
	.globl	C$cpm.c$44$1_1$11
;mini/cpm.c:44: static void _prints(const char *string, int width, int flags)
;	---------------------------------
; Function _prints
; ---------------------------------
__prints:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	C$cpm.c$46$2_0$11	= .
	.globl	C$cpm.c$46$2_0$11
;mini/cpm.c:46: int padchar = ' ';
	ld	bc, #0x0020
	C$cpm.c$51$2_0$11	= .
	.globl	C$cpm.c$51$2_0$11
;mini/cpm.c:51: for (ptr = string; *ptr; ++ptr) ++len;
	ld	a, 4 (ix)
	ld	-2 (ix), a
	ld	a, 5 (ix)
	ld	-1 (ix), a
	C$cpm.c$48$1_0$11	= .
	.globl	C$cpm.c$48$1_0$11
;mini/cpm.c:48: if (width > 0) {
	xor	a, a
	cp	a, 6 (ix)
	sbc	a, 7 (ix)
	jp	PO, 00191$
	xor	a, #0x80
00191$:
	jp	P, 00108$
	C$cpm.c$51$2_0$11	= .
	.globl	C$cpm.c$51$2_0$11
;mini/cpm.c:51: for (ptr = string; *ptr; ++ptr) ++len;
	ld	de, #0x0000
	pop	hl
	push	hl
00115$:
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	inc	hl
	inc	de
	jr	00115$
00101$:
	C$cpm.c$52$2_0$12	= .
	.globl	C$cpm.c$52$2_0$12
;mini/cpm.c:52: if (len >= width) width = 0;
	ld	a, e
	sub	a, 6 (ix)
	ld	a, d
	sbc	a, 7 (ix)
	jp	PO, 00192$
	xor	a, #0x80
00192$:
	jp	M, 00103$
	xor	a, a
	ld	6 (ix), a
	ld	7 (ix), a
	jr	00104$
00103$:
	C$cpm.c$53$2_0$12	= .
	.globl	C$cpm.c$53$2_0$12
;mini/cpm.c:53: else width -= len;
	ld	a, 6 (ix)
	sub	a, e
	ld	6 (ix), a
	ld	a, 7 (ix)
	sbc	a, d
	ld	7 (ix), a
00104$:
	C$cpm.c$54$2_0$12	= .
	.globl	C$cpm.c$54$2_0$12
;mini/cpm.c:54: if (flags & PAD_ZERO)
	bit	0, 8 (ix)
	jr	Z, 00108$
	C$cpm.c$55$2_0$12	= .
	.globl	C$cpm.c$55$2_0$12
;mini/cpm.c:55: padchar = '0';
	ld	bc, #0x0030
00108$:
	C$cpm.c$57$1_0$11	= .
	.globl	C$cpm.c$57$1_0$11
;mini/cpm.c:57: if (!(flags & PAD_RIGHT)) {
	bit	1, 8 (ix)
	jr	NZ, 00136$
	ld	e, 6 (ix)
	ld	d, 7 (ix)
00118$:
	C$cpm.c$58$3_0$15	= .
	.globl	C$cpm.c$58$3_0$15
;mini/cpm.c:58: for ( ; width > 0; --width) {
	xor	a, a
	cp	a, e
	sbc	a, d
	jp	PO, 00196$
	xor	a, #0x80
00196$:
	jp	P, 00140$
	C$cpm.c$59$4_0$16	= .
	.globl	C$cpm.c$59$4_0$16
;mini/cpm.c:59: putchar(padchar);
	push	bc
	push	de
	push	bc
	call	_putchar
	pop	af
	pop	de
	pop	bc
	C$cpm.c$58$3_0$15	= .
	.globl	C$cpm.c$58$3_0$15
;mini/cpm.c:58: for ( ; width > 0; --width) {
	dec	de
	jr	00118$
00140$:
	ld	6 (ix), e
	ld	7 (ix), d
00136$:
00121$:
	C$cpm.c$62$2_0$17	= .
	.globl	C$cpm.c$62$2_0$17
;mini/cpm.c:62: for ( ; *string ; ++string) {
	pop	hl
	push	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00138$
	C$cpm.c$63$3_0$18	= .
	.globl	C$cpm.c$63$3_0$18
;mini/cpm.c:63: putchar(*string);
	ld	d, #0x00
	push	bc
	ld	e, a
	push	de
	call	_putchar
	pop	af
	pop	bc
	C$cpm.c$62$2_0$17	= .
	.globl	C$cpm.c$62$2_0$17
;mini/cpm.c:62: for ( ; *string ; ++string) {
	inc	-2 (ix)
	jr	NZ, 00121$
	inc	-1 (ix)
	jr	00121$
00138$:
	ld	e, 6 (ix)
	ld	d, 7 (ix)
00124$:
	C$cpm.c$65$2_0$19	= .
	.globl	C$cpm.c$65$2_0$19
;mini/cpm.c:65: for ( ; width > 0; --width) {
	xor	a, a
	cp	a, e
	sbc	a, d
	jp	PO, 00198$
	xor	a, #0x80
00198$:
	jp	P, 00126$
	C$cpm.c$66$3_0$20	= .
	.globl	C$cpm.c$66$3_0$20
;mini/cpm.c:66: putchar(padchar);
	push	bc
	push	de
	push	bc
	call	_putchar
	pop	af
	pop	de
	pop	bc
	C$cpm.c$65$2_0$19	= .
	.globl	C$cpm.c$65$2_0$19
;mini/cpm.c:65: for ( ; width > 0; --width) {
	dec	de
	jr	00124$
00126$:
	C$cpm.c$68$2_0$11	= .
	.globl	C$cpm.c$68$2_0$11
;mini/cpm.c:68: }
	ld	sp, ix
	pop	ix
	C$cpm.c$68$2_0$11	= .
	.globl	C$cpm.c$68$2_0$11
	XFcpm$_prints$0$0	= .
	.globl	XFcpm$_prints$0$0
	ret
	Fcpm$_printi$0$0	= .
	.globl	Fcpm$_printi$0$0
	C$cpm.c$71$2_0$22	= .
	.globl	C$cpm.c$71$2_0$22
;mini/cpm.c:71: static void _printi(int i, int base, int sign, int width, int flags, int letbase)
;	---------------------------------
; Function _printi
; ---------------------------------
__printi:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-136
	add	hl, sp
	ld	sp, hl
	C$cpm.c$75$2_0$22	= .
	.globl	C$cpm.c$75$2_0$22
;mini/cpm.c:75: int t, neg = 0, pc = 0;
	xor	a, a
	ld	-8 (ix), a
	ld	-7 (ix), a
	C$cpm.c$76$2_0$22	= .
	.globl	C$cpm.c$76$2_0$22
;mini/cpm.c:76: unsigned int u = i;
	ld	c, 4 (ix)
	ld	b, 5 (ix)
	C$cpm.c$77$1_0$22	= .
	.globl	C$cpm.c$77$1_0$22
;mini/cpm.c:77: if (i == 0) {
	ld	a, b
	or	a, c
	jr	NZ, 00102$
	C$cpm.c$78$2_0$23	= .
	.globl	C$cpm.c$78$2_0$23
;mini/cpm.c:78: print_buf[0] = '0';
	ld	hl, #0
	add	hl, sp
	ex	de, hl
	ld	a, #0x30
	ld	(de), a
	C$cpm.c$79$2_0$23	= .
	.globl	C$cpm.c$79$2_0$23
;mini/cpm.c:79: print_buf[1] = '\0';
	ld	c, e
	ld	b, d
	inc	bc
	xor	a, a
	ld	(bc), a
	C$cpm.c$80$2_0$23	= .
	.globl	C$cpm.c$80$2_0$23
;mini/cpm.c:80: _prints(print_buf, width, flags);
	ld	l, 12 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, 13 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	l, 10 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, 11 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	de
	call	__prints
	pop	af
	pop	af
	pop	af
	C$cpm.c$81$2_0$23	= .
	.globl	C$cpm.c$81$2_0$23
;mini/cpm.c:81: return;
	jp	00118$
00102$:
	C$cpm.c$83$1_0$22	= .
	.globl	C$cpm.c$83$1_0$22
;mini/cpm.c:83: if (sign && base == 10 && i < 0) {
	ld	a, 9 (ix)
	or	a, 8 (ix)
	jr	Z, 00104$
	ld	a, 6 (ix)
	sub	a, #0x0a
	or	a, 7 (ix)
	jr	NZ, 00104$
	bit	7, 5 (ix)
	jr	Z, 00104$
	C$cpm.c$84$2_0$24	= .
	.globl	C$cpm.c$84$2_0$24
;mini/cpm.c:84: neg = 1;
	ld	-8 (ix), #0x01
	ld	-7 (ix), #0
	C$cpm.c$85$2_0$24	= .
	.globl	C$cpm.c$85$2_0$24
;mini/cpm.c:85: u = -i;
	xor	a, a
	sub	a, c
	ld	c, a
	sbc	a, a
	sub	a, b
	ld	b, a
00104$:
	C$cpm.c$87$1_0$22	= .
	.globl	C$cpm.c$87$1_0$22
;mini/cpm.c:87: s = print_buf + PRINT_BUF_LEN-1;
	ld	hl, #127
	add	hl, sp
	ex	de, hl
	C$cpm.c$88$1_0$22	= .
	.globl	C$cpm.c$88$1_0$22
;mini/cpm.c:88: *s = '\0';
	xor	a, a
	ld	(de), a
	C$cpm.c$89$2_0$25	= .
	.globl	C$cpm.c$89$2_0$25
;mini/cpm.c:89: while (u) {
	ld	a, 14 (ix)
	add	a, #0xc6
	ld	-6 (ix), a
	ld	a, 15 (ix)
	adc	a, #0xff
	ld	-5 (ix), a
00109$:
	ld	a, b
	or	a, c
	jr	Z, 00130$
	C$cpm.c$90$2_0$25	= .
	.globl	C$cpm.c$90$2_0$25
;mini/cpm.c:90: t = u % base;
	ld	a, 6 (ix)
	ld	-4 (ix), a
	ld	a, 7 (ix)
	ld	-3 (ix), a
	push	bc
	push	de
	ld	l, -4 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -3 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	call	__moduint
	pop	af
	pop	af
	pop	de
	pop	bc
	ld	-2 (ix), l
	ld	-1 (ix), h
	C$cpm.c$91$2_0$25	= .
	.globl	C$cpm.c$91$2_0$25
;mini/cpm.c:91: if( t >= 10 )
	ld	a, -2 (ix)
	sub	a, #0x0a
	ld	a, -1 (ix)
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C, 00108$
	C$cpm.c$92$2_0$25	= .
	.globl	C$cpm.c$92$2_0$25
;mini/cpm.c:92: t += letbase - '0' - 10;
	ld	a, -2 (ix)
	add	a, -6 (ix)
	ld	-2 (ix), a
	ld	a, -1 (ix)
	adc	a, -5 (ix)
	ld	-1 (ix), a
00108$:
	C$cpm.c$93$2_0$25	= .
	.globl	C$cpm.c$93$2_0$25
;mini/cpm.c:93: *--s = t + '0';
	dec	de
	ld	a, -2 (ix)
	add	a, #0x30
	ld	(de), a
	C$cpm.c$94$1_0$22	= .
	.globl	C$cpm.c$94$1_0$22
;mini/cpm.c:94: u /= base;
	push	de
	ld	l, -4 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -3 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	call	__divuint
	pop	af
	pop	af
	ld	c, l
	ld	b, h
	pop	de
	jr	00109$
00130$:
	C$cpm.c$96$1_0$22	= .
	.globl	C$cpm.c$96$1_0$22
;mini/cpm.c:96: if (neg) {
	ld	a, -7 (ix)
	or	a, -8 (ix)
	jr	Z, 00117$
	C$cpm.c$97$2_0$26	= .
	.globl	C$cpm.c$97$2_0$26
;mini/cpm.c:97: if( width && (flags & PAD_ZERO) ) {
	ld	a, 11 (ix)
	or	a, 10 (ix)
	jr	Z, 00113$
	bit	0, 12 (ix)
	jr	Z, 00113$
	C$cpm.c$98$3_0$27	= .
	.globl	C$cpm.c$98$3_0$27
;mini/cpm.c:98: putchar ('-');
	push	de
	ld	hl, #0x002d
	push	hl
	call	_putchar
	pop	af
	pop	de
	C$cpm.c$100$3_0$27	= .
	.globl	C$cpm.c$100$3_0$27
;mini/cpm.c:100: --width;
	ld	l, 10 (ix)
	ld	h, 11 (ix)
	dec	hl
	ld	10 (ix), l
	ld	11 (ix), h
	jr	00117$
00113$:
	C$cpm.c$103$3_0$28	= .
	.globl	C$cpm.c$103$3_0$28
;mini/cpm.c:103: *--s = '-';
	dec	de
	ld	a, #0x2d
	ld	(de), a
00117$:
	C$cpm.c$106$1_0$22	= .
	.globl	C$cpm.c$106$1_0$22
;mini/cpm.c:106: _prints(s, width, flags);
	ld	l, 12 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, 13 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	l, 10 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, 11 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	de
	call	__prints
	pop	af
	pop	af
	pop	af
00118$:
	C$cpm.c$107$1_0$22	= .
	.globl	C$cpm.c$107$1_0$22
;mini/cpm.c:107: }
	ld	sp, ix
	pop	ix
	C$cpm.c$107$1_0$22	= .
	.globl	C$cpm.c$107$1_0$22
	XFcpm$_printi$0$0	= .
	.globl	XFcpm$_printi$0$0
	ret
	G$printf$0$0	= .
	.globl	G$printf$0$0
	C$cpm.c$116$1_0$30	= .
	.globl	C$cpm.c$116$1_0$30
;mini/cpm.c:116: void printf(const char *format, ...)
;	---------------------------------
; Function printf
; ---------------------------------
_printf::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-16
	add	hl, sp
	ld	sp, hl
	C$cpm.c$120$2_0$31	= .
	.globl	C$cpm.c$120$2_0$31
;mini/cpm.c:120: va_start(ap, format);
	ld	hl,#0x16
	add	hl,sp
	ld	-12 (ix), l
	ld	-11 (ix), h
00132$:
	C$cpm.c$133$2_1$30	= .
	.globl	C$cpm.c$133$2_1$30
;mini/cpm.c:133: for (; *format != 0; ++format) {
	ld	c, 4 (ix)
	ld	b, 5 (ix)
	ld	a, (bc)
	or	a, a
	jp	Z, 00134$
	C$cpm.c$135$3_1$34	= .
	.globl	C$cpm.c$135$3_1$34
;mini/cpm.c:135: if (*format == '%') {
	cp	a, #0x25
	jp	NZ,00122$
	C$cpm.c$136$4_1$35	= .
	.globl	C$cpm.c$136$4_1$35
;mini/cpm.c:136: ++format;                   /* peek at next char after % */
	inc	bc
	ld	4 (ix), c
	ld	5 (ix), b
	C$cpm.c$137$4_1$35	= .
	.globl	C$cpm.c$137$4_1$35
;mini/cpm.c:137: width = flags = 0;
	xor	a, a
	ld	-2 (ix), a
	ld	-1 (ix), a
	xor	a, a
	ld	-10 (ix), a
	ld	-9 (ix), a
	C$cpm.c$133$2_1$30	= .
	.globl	C$cpm.c$133$2_1$30
;mini/cpm.c:133: for (; *format != 0; ++format) {
	ld	a, 4 (ix)
	ld	-4 (ix), a
	ld	a, 5 (ix)
	ld	-3 (ix), a
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	a, (hl)
	C$cpm.c$138$4_1$35	= .
	.globl	C$cpm.c$138$4_1$35
;mini/cpm.c:138: if (*format == '\0')        /* if end of string it's a mistake: ignore */
	or	a, a
	jp	Z, 00134$
	C$cpm.c$140$4_1$35	= .
	.globl	C$cpm.c$140$4_1$35
;mini/cpm.c:140: if (*format == '%')         /* if %% then it's escape code */
	cp	a, #0x25
	jp	Z,00122$
	C$cpm.c$142$4_1$35	= .
	.globl	C$cpm.c$142$4_1$35
;mini/cpm.c:142: if (*format == '-') {       /* if - then pad right and get next format specifier */
	sub	a, #0x2d
	jr	NZ, 00144$
	C$cpm.c$143$5_1$36	= .
	.globl	C$cpm.c$143$5_1$36
;mini/cpm.c:143: ++format;
	ld	a, -4 (ix)
	add	a, #0x01
	ld	4 (ix), a
	ld	a, -3 (ix)
	adc	a, #0x00
	ld	5 (ix), a
	C$cpm.c$144$5_1$36	= .
	.globl	C$cpm.c$144$5_1$36
;mini/cpm.c:144: flags = PAD_RIGHT;
	ld	-2 (ix), #0x02
	ld	-1 (ix), #0
	C$cpm.c$146$2_1$30	= .
	.globl	C$cpm.c$146$2_1$30
;mini/cpm.c:146: while (*format == '0') {    /* if 0 then pad zero and get next format specifier */
00144$:
	ld	c, 4 (ix)
	ld	b, 5 (ix)
00107$:
	ld	a, (bc)
	ld	e, a
	C$cpm.c$147$2_1$30	= .
	.globl	C$cpm.c$147$2_1$30
;mini/cpm.c:147: ++format;
	ld	l, c
	ld	h, b
	inc	hl
	ld	-4 (ix), l
	ld	-3 (ix), h
	C$cpm.c$146$4_1$35	= .
	.globl	C$cpm.c$146$4_1$35
;mini/cpm.c:146: while (*format == '0') {    /* if 0 then pad zero and get next format specifier */
	ld	a, e
	sub	a, #0x30
	jr	NZ, 00157$
	C$cpm.c$147$5_1$37	= .
	.globl	C$cpm.c$147$5_1$37
;mini/cpm.c:147: ++format;
	ld	c, -4 (ix)
	ld	b, -3 (ix)
	ld	a, -4 (ix)
	ld	4 (ix), a
	ld	a, -3 (ix)
	ld	5 (ix), a
	C$cpm.c$148$5_1$37	= .
	.globl	C$cpm.c$148$5_1$37
;mini/cpm.c:148: flags |= PAD_ZERO;
	ld	a, -2 (ix)
	or	a, #0x01
	ld	-2 (ix), a
	jr	00107$
00157$:
	ld	4 (ix), c
	ld	5 (ix), b
	C$cpm.c$150$4_1$35	= .
	.globl	C$cpm.c$150$4_1$35
;mini/cpm.c:150: if (*format == '*') {
	ld	a, e
	sub	a, #0x2a
	jr	NZ, 00148$
	C$cpm.c$151$5_1$38	= .
	.globl	C$cpm.c$151$5_1$38
;mini/cpm.c:151: width = va_arg(ap, int);
	ld	c, -12 (ix)
	ld	b, -11 (ix)
	inc	bc
	inc	bc
	ld	-12 (ix), c
	ld	-11 (ix), b
	dec	bc
	dec	bc
	ld	a, (bc)
	ld	-10 (ix), a
	inc	bc
	ld	a, (bc)
	ld	-9 (ix), a
	C$cpm.c$152$5_1$38	= .
	.globl	C$cpm.c$152$5_1$38
;mini/cpm.c:152: format++;
	ld	a, -4 (ix)
	ld	4 (ix), a
	ld	a, -3 (ix)
	ld	5 (ix), a
	jr	00113$
00148$:
00129$:
	C$cpm.c$154$6_1$40	= .
	.globl	C$cpm.c$154$6_1$40
;mini/cpm.c:154: for ( ; *format >= '0' && *format <= '9'; ++format) {
	ld	a, (bc)
	ld	e, a
	sub	a, #0x30
	jr	C, 00158$
	ld	a, #0x39
	sub	a, e
	jr	C, 00158$
	C$cpm.c$155$7_1$41	= .
	.globl	C$cpm.c$155$7_1$41
;mini/cpm.c:155: width *= 10;
	push	de
	ld	e, -10 (ix)
	ld	d, -9 (ix)
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	pop	de
	C$cpm.c$156$7_1$41	= .
	.globl	C$cpm.c$156$7_1$41
;mini/cpm.c:156: width += *format - '0';
	ld	d, #0x00
	ld	a, e
	add	a, #0xd0
	ld	e, a
	ld	a, d
	adc	a, #0xff
	ld	d, a
	add	hl, de
	ld	-10 (ix), l
	ld	-9 (ix), h
	C$cpm.c$154$6_1$40	= .
	.globl	C$cpm.c$154$6_1$40
;mini/cpm.c:154: for ( ; *format >= '0' && *format <= '9'; ++format) {
	inc	bc
	ld	4 (ix), c
	ld	5 (ix), b
	jr	00129$
00158$:
	ld	4 (ix), c
	ld	5 (ix), b
00113$:
	C$cpm.c$160$4_1$35	= .
	.globl	C$cpm.c$160$4_1$35
;mini/cpm.c:160: switch (*format) {
	ld	l, 4 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, 5 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	e, (hl)
	C$cpm.c$151$2_1$30	= .
	.globl	C$cpm.c$151$2_1$30
;mini/cpm.c:151: width = va_arg(ap, int);
	ld	c, -12 (ix)
	ld	b, -11 (ix)
	inc	bc
	inc	bc
	C$cpm.c$162$2_1$30	= .
	.globl	C$cpm.c$162$2_1$30
;mini/cpm.c:162: u.i = va_arg(ap, int);
	ld	a, c
	add	a, #0xfe
	ld	-8 (ix), a
	ld	a, b
	adc	a, #0xff
	ld	-7 (ix), a
	C$cpm.c$167$2_1$30	= .
	.globl	C$cpm.c$167$2_1$30
;mini/cpm.c:167: u.u = va_arg(ap, unsigned int);
	ld	a, -8 (ix)
	ld	-6 (ix), a
	ld	a, -7 (ix)
	ld	-5 (ix), a
	C$cpm.c$160$4_1$35	= .
	.globl	C$cpm.c$160$4_1$35
;mini/cpm.c:160: switch (*format) {
	ld	a, e
	sub	a, #0x58
	jp	Z,00117$
	C$cpm.c$162$2_1$30	= .
	.globl	C$cpm.c$162$2_1$30
;mini/cpm.c:162: u.i = va_arg(ap, int);
	ld	a, -8 (ix)
	ld	-4 (ix), a
	ld	a, -7 (ix)
	ld	-3 (ix), a
	C$cpm.c$160$4_1$35	= .
	.globl	C$cpm.c$160$4_1$35
;mini/cpm.c:160: switch (*format) {
	ld	a,e
	cp	a,#0x63
	jp	Z,00118$
	cp	a,#0x64
	jr	Z, 00114$
	cp	a,#0x73
	jp	Z,00119$
	cp	a,#0x75
	jr	Z, 00115$
	sub	a, #0x78
	jp	Z,00116$
	jp	00133$
	C$cpm.c$161$5_1$42	= .
	.globl	C$cpm.c$161$5_1$42
;mini/cpm.c:161: case('d'):              /* decimal! */
00114$:
	C$cpm.c$162$5_1$42	= .
	.globl	C$cpm.c$162$5_1$42
;mini/cpm.c:162: u.i = va_arg(ap, int);
	ld	hl, #2
	add	hl, sp
	ex	de, hl
	ld	-12 (ix), c
	ld	-11 (ix), b
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	l, e
	ld	h, d
	ld	(hl), c
	inc	hl
	ld	(hl), b
	C$cpm.c$163$5_1$42	= .
	.globl	C$cpm.c$163$5_1$42
;mini/cpm.c:163: _printi(u.i, 10, 1, width, flags, 'a');
	ex	de,hl
	ld	a, (hl)
	inc	hl
	ld	a, (hl)
	ld	hl, #0x0061
	push	hl
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	l, -10 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -9 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, #0x0001
	push	hl
	ld	l, #0x0a
	push	hl
	push	bc
	call	__printi
	ld	hl, #12
	add	hl, sp
	ld	sp, hl
	C$cpm.c$164$5_1$42	= .
	.globl	C$cpm.c$164$5_1$42
;mini/cpm.c:164: break;
	jp	00133$
	C$cpm.c$166$5_1$42	= .
	.globl	C$cpm.c$166$5_1$42
;mini/cpm.c:166: case('u'):              /* unsigned */
00115$:
	C$cpm.c$167$5_1$42	= .
	.globl	C$cpm.c$167$5_1$42
;mini/cpm.c:167: u.u = va_arg(ap, unsigned int);
	ld	hl, #2
	add	hl, sp
	ex	de, hl
	ld	-12 (ix), c
	ld	-11 (ix), b
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	l, e
	ld	h, d
	ld	(hl), c
	inc	hl
	ld	(hl), b
	C$cpm.c$168$5_1$42	= .
	.globl	C$cpm.c$168$5_1$42
;mini/cpm.c:168: _printi(u.u, 10, 0, width, flags, 'a');
	ex	de,hl
	ld	a, (hl)
	inc	hl
	ld	a, (hl)
	ld	hl, #0x0061
	push	hl
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	l, -10 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -9 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	l, #0x0a
	push	hl
	push	bc
	call	__printi
	ld	hl, #12
	add	hl, sp
	ld	sp, hl
	C$cpm.c$169$5_1$42	= .
	.globl	C$cpm.c$169$5_1$42
;mini/cpm.c:169: break;
	jp	00133$
	C$cpm.c$171$5_1$42	= .
	.globl	C$cpm.c$171$5_1$42
;mini/cpm.c:171: case('x'):              /* hex */
00116$:
	C$cpm.c$172$5_1$42	= .
	.globl	C$cpm.c$172$5_1$42
;mini/cpm.c:172: u.u = va_arg(ap, unsigned int);
	ld	hl, #2
	add	hl, sp
	ex	de, hl
	ld	-12 (ix), c
	ld	-11 (ix), b
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	l, e
	ld	h, d
	ld	(hl), c
	inc	hl
	ld	(hl), b
	C$cpm.c$173$5_1$42	= .
	.globl	C$cpm.c$173$5_1$42
;mini/cpm.c:173: _printi(u.u, 16, 0, width, flags, 'a');
	ex	de,hl
	ld	a, (hl)
	inc	hl
	ld	a, (hl)
	ld	hl, #0x0061
	push	hl
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	l, -10 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -9 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	l, #0x10
	push	hl
	push	bc
	call	__printi
	ld	hl, #12
	add	hl, sp
	ld	sp, hl
	C$cpm.c$174$5_1$42	= .
	.globl	C$cpm.c$174$5_1$42
;mini/cpm.c:174: break;
	jp	00133$
	C$cpm.c$176$5_1$42	= .
	.globl	C$cpm.c$176$5_1$42
;mini/cpm.c:176: case('X'):              /* hex, capital */
00117$:
	C$cpm.c$177$5_1$42	= .
	.globl	C$cpm.c$177$5_1$42
;mini/cpm.c:177: u.u = va_arg(ap, unsigned int);
	ld	hl, #2
	add	hl, sp
	ex	de, hl
	ld	-12 (ix), c
	ld	-11 (ix), b
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	l, e
	ld	h, d
	ld	(hl), c
	inc	hl
	ld	(hl), b
	C$cpm.c$178$5_1$42	= .
	.globl	C$cpm.c$178$5_1$42
;mini/cpm.c:178: _printi(u.u, 16, 0, width, flags, 'A');
	ex	de,hl
	ld	a, (hl)
	inc	hl
	ld	a, (hl)
	ld	hl, #0x0041
	push	hl
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	l, -10 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -9 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	l, #0x10
	push	hl
	push	bc
	call	__printi
	ld	hl, #12
	add	hl, sp
	ld	sp, hl
	C$cpm.c$179$5_1$42	= .
	.globl	C$cpm.c$179$5_1$42
;mini/cpm.c:179: break;
	jp	00133$
	C$cpm.c$181$5_1$42	= .
	.globl	C$cpm.c$181$5_1$42
;mini/cpm.c:181: case('c'):              /* char */
00118$:
	C$cpm.c$182$5_1$42	= .
	.globl	C$cpm.c$182$5_1$42
;mini/cpm.c:182: u.c = va_arg(ap, int);
	ld	hl, #2
	add	hl, sp
	ex	de, hl
	ld	-12 (ix), c
	ld	-11 (ix), b
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	a, (hl)
	ld	(de), a
	C$cpm.c$183$5_1$42	= .
	.globl	C$cpm.c$183$5_1$42
;mini/cpm.c:183: scr[0] = u.c;
	ld	hl, #0
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	a, (de)
	ld	(bc), a
	C$cpm.c$184$5_1$42	= .
	.globl	C$cpm.c$184$5_1$42
;mini/cpm.c:184: scr[1] = '\0';
	ld	e, c
	ld	d, b
	inc	de
	xor	a, a
	ld	(de), a
	C$cpm.c$185$5_1$42	= .
	.globl	C$cpm.c$185$5_1$42
;mini/cpm.c:185: _prints(scr, width, flags);
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	l, -10 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -9 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	call	__prints
	pop	af
	pop	af
	pop	af
	C$cpm.c$186$5_1$42	= .
	.globl	C$cpm.c$186$5_1$42
;mini/cpm.c:186: break;
	jr	00133$
	C$cpm.c$188$5_1$42	= .
	.globl	C$cpm.c$188$5_1$42
;mini/cpm.c:188: case('s'):              /* string */
00119$:
	C$cpm.c$189$5_1$42	= .
	.globl	C$cpm.c$189$5_1$42
;mini/cpm.c:189: u.s = va_arg(ap, char *);
	ld	hl, #2
	add	hl, sp
	ex	de, hl
	ld	-12 (ix), c
	ld	-11 (ix), b
	ld	c, -8 (ix)
	ld	b, -7 (ix)
	ld	a, (bc)
	ld	-6 (ix), a
	inc	bc
	ld	a, (bc)
	ld	-5 (ix), a
	ld	l, e
	ld	h, d
	ld	a, -6 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -5 (ix)
	ld	(hl), a
	C$cpm.c$191$5_1$42	= .
	.globl	C$cpm.c$191$5_1$42
;mini/cpm.c:191: _prints(u.s ? u.s : "(null)", width, flags);
	ld	a, (de)
	ld	-4 (ix), a
	inc	de
	ld	a, (de)
	ld	-3 (ix), a
	ld	a, -5 (ix)
	or	a, -6 (ix)
	jr	NZ, 00137$
	ld	-4 (ix), #<(___str_0)
	ld	-3 (ix), #>(___str_0)
00137$:
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	l, -10 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -9 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	l, -4 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -3 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	call	__prints
	pop	af
	pop	af
	pop	af
	C$cpm.c$192$5_1$42	= .
	.globl	C$cpm.c$192$5_1$42
;mini/cpm.c:192: break;
	jr	00133$
	C$cpm.c$198$4_1$43	= .
	.globl	C$cpm.c$198$4_1$43
;mini/cpm.c:198: esc:
00122$:
	C$cpm.c$199$4_1$43	= .
	.globl	C$cpm.c$199$4_1$43
;mini/cpm.c:199: putchar(*format);
	ld	b, #0x00
	ld	c, a
	push	bc
	call	_putchar
	pop	af
00133$:
	C$cpm.c$133$2_1$33	= .
	.globl	C$cpm.c$133$2_1$33
;mini/cpm.c:133: for (; *format != 0; ++format) {
	inc	4 (ix)
	jp	NZ,00132$
	inc	5 (ix)
	jp	00132$
00134$:
	C$cpm.c$202$2_1$30	= .
	.globl	C$cpm.c$202$2_1$30
;mini/cpm.c:202: }
	ld	sp, ix
	pop	ix
	C$cpm.c$202$2_1$30	= .
	.globl	C$cpm.c$202$2_1$30
	XG$printf$0$0	= .
	.globl	XG$printf$0$0
	ret
Fcpm$__str_0$0_0$0 == .
___str_0:
	.ascii "(null)"
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
