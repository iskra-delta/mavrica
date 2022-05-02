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
#include <string.h>

#include <io.h>

fcb_t fcb;
uint8_t area;

int main(int argc, char *argv[]) {
    argc; argv;

    int result = fparse("1C:T.A", &fcb, &area);

    char fname[9], ext[4];
    memcpy(fname,&(fcb.filename[0]),8);
    fname[8]=0;
    memcpy(ext,&(fcb.filetype[0]),3);
    ext[3]=0;

    printf("FILE : %s\n EXT : %s\n RES : %04x\nAREA : %d\n DRV : %d\n", 
        fname, ext, result, area, fcb.drive);

    return 0;
}