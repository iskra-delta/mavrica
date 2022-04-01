/*
 * mem.h
 *
 * Memory management utility functions.
 * 
 * MIT License (see: LICENSE)
 * copyright (c) 2021 tomaz stih
 *
 * 25.05.2012   tstih
 *
 */
#ifndef __MEM_H__
#define __MEM_H__

#include <mini/list.h>

#ifndef NONE
#define NONE 0
#endif

#define MEM_TOP         0xc000
#define BLK_SIZE        (sizeof(struct block_s) - sizeof(unsigned char[1]))
#define MIN_CHUNK_SIZE  4

/* block status, use as bit operations */
#define NEW             0x00
#define ALLOCATED       0x01

typedef struct block_s {
    list_header_t   hdr;
    unsigned char   stat;
    unsigned int    size;
    unsigned char   data[1];
} block_t;

/* Must be defined in crt0 */
extern void _heap;

/* find first free block of appropriate size */
extern unsigned char _match_free_block(list_header_t *p, unsigned int size);

/* merge block with the next block */
extern void _merge_with_next(block_t *b);

/* split memory block into two blocks */
extern void _split(block_t *b, unsigned int size);

/* initialize memory management */
extern void _memory_init();

/* initialize custom heap */
extern void _heap_init(unsigned int  start, unsigned int  size);

/* allocate block on the heap (used by malloc) */
extern void *_alloc(unsigned int  heap, unsigned int  size);

/* release block from the heap (used by free) */
extern void _dealloc(unsigned int  heap, void *p);

#endif /* __MEM_H__ */