/*
 * mem.c
 *
 * Memory management utility functions.
 * 
 * MIT License (see: LICENSE)
 * copyright (c) 2021 tomaz stih
 *
 * 25.05.2012   tstih
 *
 */
#include <mini/mem.h>

unsigned char _match_free_block(list_header_t *p, unsigned int size)
{
    block_t *b = (block_t *)p;
    return !(b->stat & ALLOCATED) && b->size >= size;
}

void _merge_with_next(block_t *b)
{
    block_t *bnext = b->hdr.next;
    b->size += (BLK_SIZE + bnext->size);
    b->hdr.next = bnext->hdr.next;
}

void _split(block_t *b, unsigned int size)
{
    block_t *nw;
    nw = (block_t *)((unsigned int)(b->data) + size);
    nw->hdr.next = b->hdr.next;
    nw->size = b->size - (size + BLK_SIZE);
    nw->stat = b->stat;
    /* do not set owner and stat because
	   they'll be populated later */
    b->size = size;
    b->hdr.next = nw;
}

void _memory_init()
{
    /* Calculate free memory */
    unsigned int size=MEM_TOP - (unsigned int)&_heap;
    _heap_init((unsigned int)&_heap,size);
}

void _heap_init(unsigned int start, unsigned int size) {
    /* First block is the heap. s*/
    block_t *first = (block_t *)start;
    first->hdr.next = NULL;
    first->size = size - BLK_SIZE;
    first->stat = NEW;
}

void *_alloc(unsigned int heap, unsigned int size)
{
    block_t *prev;
    block_t *b;

    b = (block_t *)_list_find(
        (list_header_t *)heap,
        (list_header_t **)&prev,
        _match_free_block, size);

    if (b)
    {
        if (b->size - size > BLK_SIZE + MIN_CHUNK_SIZE)
            _split(b, size);
        b->stat = ALLOCATED;
        return b->data;
    }
    else
        return NULL;
}

void _dealloc(unsigned int heap, void *p)
{
    block_t *prev;
    block_t *b;

    /* calculate block address from pointer */
    b = (block_t *)((unsigned int)p - BLK_SIZE);

    /* make sure it is a valid memory block by finding it */
    if (_list_find((list_header_t *)heap, (list_header_t **)&prev, _list_match_eq, (unsigned int)b))
    {
        b->stat = NEW;
        /* merge 3 blocks if possible */
        if (prev && !(prev->stat & ALLOCATED))
        { /* try previous */
            _merge_with_next(prev);
            b = prev;
        }
        /* try next */
        if (b->hdr.next && !(((block_t *)(b->hdr.next))->stat & ALLOCATED))
            _merge_with_next(b);
    }
}