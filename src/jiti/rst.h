/*
 * rst.c
 *
 * handle rst vectors header file
 *
 * MIT License (see: LICENSE)
 * copyright (c) 2022 tomaz stih
 *
 * 21.12.2022   tstih
 *
 */
#ifndef __RST_H__
#define __RST_H__

#define RST00   0x0000
#define RST08   0x0008
#define RST10   0x0010
#define RST18   0x0018
#define RST20   0x0020
#define RST28   0x0028
#define RST30   0x0030
#define RST38   0x0038

typedef void (*rst_handler)();

extern void rst_install(int vecno, rst_handler pfn);

#endif /* __RST_H__ */