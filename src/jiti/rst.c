/*
 * rst.c
 *
 * handle rst vectors
 *
 * MIT License (see: LICENSE)
 * copyright (c) 2022 tomaz stih
 *
 * 21.12.2022   tstih
 *
 */
#include <stdint.h>

#include <jiti/rst.h>

void rst_install(int vecno, rst_handler pfn) {
    uint8_t *rstaddr=(uint8_t*)vecno;
    uint8_t *fnpaddr=(uint8_t*)pfn;
    *rstaddr++=*fnpaddr++;
    *rstaddr++=*fnpaddr++;
}