/*
 * video.h
 *
 * zx spectrum video functions
 *
 * MIT License (see: LICENSE)
 * copyright (c) 2022 tomaz stih
 *
 * 05.05.2022   tstih
 *
 */
#ifndef __VIDEO_H__
#define __VIDEO_H__

extern unsigned int vid_addr2xy(void *addr);
extern void vid_write(void *addr, unsigned char value);
extern void vid_blit(void *addr);

#endif /* __VIDEO_H__ */