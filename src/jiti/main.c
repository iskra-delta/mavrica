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

#include <speccy/video.h>
#include <gpx.h>
#include <io.h>

uint8_t *screen;
unsigned int flen;

int main(int argc, char *argv[]) {
    argv;

    if (argc!=2) {
        avdc_cls();
        gdp_cls();
        return 1;
    }

    screen=fload(argv[1],NULL,&flen);
    if (screen==NULL) {
        puts("Invalid filename.\n");
        return 1;
    }

    /* hide terminal cursor! */
    avdc_hide_cursor();

    /* clear text screen */
    avdc_cls();

    /* initialize gdb */
    gdp_init(); gdp_cls();

    /* draw ... */
    vid_blit(screen);
    
    //vid_write(0,screen[0]);
    //for(int i=1;i</*6144*/32;i++)
    //test();
        //vid_write(i,screen[i]);

    /* show terminal cursor */
    avdc_show_cursor();

    return 0;
}