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
#include <ugpx.h>
#include <jiti/jiti.h>

uint8_t *bin;
unsigned int flen;

int main(int argc, char *argv[]) {
    argv;

    if (argc!=2) {
        puts("Invalid arguments.");
        return 1;
    }

    bin=fload(argv[1],NULL,&flen);
    if (bin==NULL) {
        puts("Invalid filename.");
        return 1;
    }

    /* compile code ... */
    unsigned int result=compile(bin,0x8000);
    printf("\n\n%04x\n",result);
    

    return 0;
}