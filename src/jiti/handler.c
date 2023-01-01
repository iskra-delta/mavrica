/*
 * handler.c
 *
 * rst handler
 *
 * MIT License (see: LICENSE)
 * copyright (c) 2022 tomaz stih
 *
 * 31.12.2022   tstih
 *
 */
void rhandler() __naked {

    __asm
        call    ctx_store               /* store context */
    __endasm;

    __asm


    reti
    __endasm;

}