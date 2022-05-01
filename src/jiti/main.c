/*
 * main.c
 *
 * mavrica main code
 *
 * MIT License (see: LICENSE)
 * copyright (c) 2022 tomaz stih
 *
 * 27.03.2022   tstih
 *
 */
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

#include <io.h>

fcb_t fcb;
uint8_t area;

int main(int argc, char *argv[]) {
    argc; argv;

    int result = fparse("TEST.COM", &fcb, &area);

    printf("Result is %d, area is %d, drive is %c, fname is %s\n", 
        result, 
        area, 
        fcb.drive,
        &(fcb.filetype));

    return 0;
}