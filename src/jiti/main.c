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

int main(int argc, char *argv[]) {
    argc; argv;

    unsigned int flen;
    void *out;
    out=fload(argv[1],NULL,&flen);

    printf("FILE: %s, LEN: %d, RESULT: %d\n", 
        argv[1],
        flen,
        out
        );

    return 0;
}