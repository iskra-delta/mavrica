/*
 * io.h
 *
 * file I/O functions
 * 
 * MIT License (see: LICENSE)
 * copyright (c) 2022 tomaz stih
 *
 * 02.04.2022   tstih
 *
 */
#ifndef __IO_H__
#define __IO_H__

#define FP_DEFAULT              0xff
#define FP_STS_SUCCESS          0x00
#define FP_STS_INVALID_AREA     0x01
#define FP_STS_INVALID_DRIVE    0x02
#define FP_STS_UNEXPECTED_END   0x03
#define FP_STS_INVALID_SYMBOL   0x04
/* file path structure */
typedef struct path_s {
    unsigned char area;         /* 0xff...default, 0-15 valid */
    unsigned char drive;        /* 0xff...default, A-Z */
    char filename[8];           /* file name, space padded */
	char filetype[3];           /* file type, space padded */
    unsigned char status;       /* path status, 0=valid, !0=error */
} path_t;

/* parse path such as 1A:TEST.DAT and returns path_t
   structure */
extern path_t *fparse(char *path, path_t *out);

#define DMA_SIZE        128
typedef struct fcb_s {
	unsigned char drive;        /* 0 -> Searches in default disk drive */
	char filename[8];           /* file name ('?' means any char) */
	char filetype[3];           /* file type */
	unsigned char ex;           /* extent */
   	unsigned int resv;          /* reserved for CP/M */
	unsigned char rc;           /* records used in extent */
	unsigned char alb[16];      /* allocation blocks used */
	unsigned char seqreq;       /* sequential records to read/write */
	unsigned int rrec;          /* rand record to read/write */ 
	unsigned char rrecob;       /* rand record overflow byte (MS) */
} fcb_t; /* File Control Block */

/* load entire file into memory */
extern unsigned char *fload(char *path, unsigned char* out);

#endif /* __IO_H__ */