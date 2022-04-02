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
#include <stdio.h>

int main(int argc, char *argv[]) {

    printf("Total args %d\n", argc);
    for(int i=1;i<argc;i++)
        printf("%s\n",argv[i]);
    
    return 0;
}