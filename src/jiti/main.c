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
#include <gpx.h>
#include <jiti/jiti.h>

uint8_t *bin;
unsigned int flen;

int main(int argc, char *argv[]) {
    argv;

    if (argc!=2) {
        avdc_cls();
        gdp_cls();
        return 1;
    }

    bin=fload(argv[1],NULL,&flen);
    if (bin==NULL) {
        puts("Invalid filename.\n");
        return 1;
    }

    /* hide terminal cursor! */
    avdc_hide_cursor();

    /* clear text screen */
    avdc_cls();

    /* initialize gdb */
    gdp_init(); gdp_cls();

    /* compile code ... */
    unsigned int result=compile(bin,0x8000);
    printf("\n\n%04x\n",result);
    
    /* show terminal cursor */
    avdc_show_cursor();

    return 0;
}