# Z80 Automata Implementation

Hi there. You're probably interested in Z80, final state machines, or CP/M if you are here. Then, you've come to the right place. In this example of a non-trivial Z80 finite state machine, we are implementing an extended CP/M path parser.

 > Just what exactly is an extended CP/M path? It is a CP/M filename with an extension that includes the CP/M area and drive. For example, 2A:TEST.DAT.

Using the FSM for this task may not be optimal, but our objective is to demonstrate the technique. After that, you can use it to implement more complex tasks, such as the standard C printf function or a programming language tokenizer.

# Syntax and Semantic Analysis

Here's the syntax diagram.

![The railroad diagram](../docs/img/parse-path-railroad.png)

A valid path also respects two additional semantic rules:

 * Filename and extension are 7 bit ascii strings and cannot contain any of the following: < > . , ; : = ? * [ ] % | ( ) / \. 
 * Max length for the filename is 8 and for extension 3. 

## Introducing the Finite-State Machine

Our approach is to convert the parsing task into a [Mealy machine](https://en.wikipedia.org/wiki/Mealy_machine). Our input will be character and current state, and our output a call to function to do something with it.

This is the partial mealy machine for parsing the area at the beginning of the path.

![Parse area](../docs/img/parse-path-area.png)

We start in the `START` state and read the first symbol. Then, we call the function `APPEND AREA` and move to the `AREA` state if it is a digit. If it is not a digit, there is no area, and we move to the `END` state. We persist in the `AREA` state as long as digits are available. We move to the 'END' state if we encounter anything else.

 > In case of any unexpected symbol, we trigger an error.

This machine will take any number from the start of a string, but it will not perform the semantic check. An excellent place to do that is the `APPEND AREA` function. 

### Encoding the Finite-State Machine

To implement this in the Z80 assembly, we need to define the final state machine with the table of states and transitions. 

We could create an adjacent matrix for state transitions, but this would be memory hungry. So our transitions will be a simple row of data:

~~~
<start>, <test>, <function>, <end>
~~~

Our automata can be written as:

~~~
START, 0-9, APPEND AREA, AREA
START, , , END
AREA, 0-9, APPEND AREA, AREA
AREA, , , END
~~~

Two rows contain no test, and no function. An empty test always succeeds, and an empty function means no code is executed on state transfer. Depending on number of states, tests, and functions we can optimize table encoding for our FSM. 

Our states are: START, AREA, END
Our tests are: 0-9, empty test
Our functions are: APPEND AREA, empty function

We need 2 bits to encode state and 1 bit to encode test and function. Hence our row for describing a single transiton is **2 + 1 + 1 + 2 =** 6 bits long. The entire automata takes **4 * 6** = 24 bits or 3 bytes.

### The Complete Finite-State Machine

So now we know how we'll encode the automata. Next, it is time to create the real finite-state machine we will use for the task.

![Parse path](../docs/img/parse-path.png)

We have eight states which we can encode with 3 bits. There are less than eight functions which require additional 3 bits. And there are six tests which require 3 bits. Great! We can write our automata into a comfortable 2 bytes per transition or 30 bytes for all 15 state transitions.

~~~asm
        ;; automata states
        .equ    S_START,        0b00000000
        .equ    S_AREA,         0b00000001
        .equ    S_DRIVE,        0b00000010
        .equ    S_FNAME0,       0b00000011
        .equ    S_FNAME,        0b00000100
        .equ    S_EXT0,         0b00000101
        .equ    S_EXT,          0b00000110
        .equ    S_END,          0b00000111

        ;; automata test
        .equ    T_ELSE,         0b00000000
        .equ    T_DIGIT,        0b00010000
        .equ    T_COLON,        0b00100000
        .equ    T_DOT,          0b00110000
        .equ    T_ALPHA,        0b01000000
        .equ    T_ASCII7,       0b01010000
        .equ    T_ZERO,         0b01100000

        ;; automata functions
        .equ    F_NONE,         0b00000000
        .equ    F_APPEND_AREA,  0b00010000
        .equ    F_STACK_SYM,    0b00100000
        .equ    F_SET_DRV,      0b00110000
        .equ    F_APPEND_FNAME, 0b01000000
        .equ    F_APPEND_EXT,   0b01010000

        ;; ----- automata definition ------------------------------------------
        ;; each transition is 2 bytes
        ;; byte 0:
        ;;  TTTTSSSS    T=test, S=start
        ;; byte 1:
        ;;  FFFFEEEE    F=function, E=end
        ;; example:
        ;;  00010000, 00000001 (start=0, test=1, function=0, end=1)
fpa_automata:
        .db     S_START + T_DIGIT,      S_AREA + F_APPEND_AREA
        .db     S_START + T_ALPHA,      S_DRIVE + F_STACK_SYM
        .db     S_START + T_ASCII7,     S_FNAME + F_APPEND_FNAME
        .db     S_AREA + T_DIGIT,       S_AREA + F_APPEND_AREA
        .db     S_AREA + T_COLON,       S_FNAME0 + F_NONE
        .db     S_AREA + T_ASCII7,      S_DRIVE + F_STACK_SYM
        .db     S_DRIVE + T_COLON,      S_FNAME0 + F_SET_DRV
        .db     S_DRIVE + T_ASCII7,     S_FNAME + F_APPEND_FNAME
        .db     S_FNAME0 + T_ASCII7,    S_FNAME + F_APPEND_FNAME
        .db     S_FNAME + T_ASCII7,     S_FNAME + F_APPEND_FNAME
        .db     S_FNAME + T_ZERO,       S_END + F_NONE
        .db     S_FNAME + T_DOT,        S_EXT0 + F_NONE
        .db     S_EXT0 + T_ASCII7,      S_EXT + F_APPEND_EXT
        .db     S_EXT + T_ASCII7,       S_EXT + F_APPEND_EXT
        .db     S_EXT + T_ZERO,         S_END + F_NONE
efpa_automata:
~~~

### Finite-State Machine Engine

Here's the C prototype of the parse function.

~~~cpp
extern uint8_t fparse(char *path, fcb_t *fcb, uint8_t *area);
~~~

This is our goal! The CP/M `fcb_t` type is defined as

~~~cpp
typedef struct fcb_s {
	uint8_t drive;          /* 0 -> Searches in default disk drive */
	char filename[8];       /* file name ('?' means any char) */
	char filetype[3];       /* file type */
	uint8_t ex;             /* extent */
   	uint16_t resv;          /* reserved for CP/M */
	uint8_t rc;             /* records used in extent */
	uint8_t alb[16];        /* allocation blocks used */
	uint8_t seqreq;         /* sequential records to read/write */
	uint16_t rrec;          /* rand record to read/write */ 
	uint8_t rrecob;         /* rand record overflow byte (MS) */
} fcb_t; /* file control block */
~~~

We will only populate the first three members of this structure: `drive`, `filename`, and `filetype`. The `filename` and `filetype` members must be padded with spaces if shorter than the allocated space.

The compiler will place function arguments on the stack from last to first. The last value on the stack will be the return address. Here's the code that pops the function arguments up and initializes the `fcb_t` structure.

~~~asm
_fparse::
        ;; fetch args from stack
        pop     af                      ; ignore the return address...
        pop     hl                      ; pointer to path to hl
        exx
        ;; pad filename and extension (of FCB) with spaces
        pop     de                      ; pointer to fcb to de
        push    de                      ; return it
        xor     a                       ; a=0
        ld      (de),a                  ; default drive
        inc     de                      ; skip over default 
        ld      b,#11                   ; 8+3 filename
        ld      a,#' '                  ; pad with spaces
fpa_init_fcb:
        ld      (de),a
        inc     de
        djnz    fpa_init_fcb
        pop     de                      ; restore de
        pop     bc                      ; pointer to area to bc
        exx
        ;; restore stack and make iy point to it
        ld      iy,#-8
        add     iy,sp
        ld      sp,iy
~~~

There are eight bytes of local variables on the stack, and after we move them to registers, we don't need them anymore. So we can reuse this space for our *local variables*.

~~~asm
        ;; we will use space from 2(iy) to 7(iy) as
        ;; local variables ... overwriting arguments
        ld      2(iy),#S_START          ; initial state to 2(iy)!
        ld      3(iy),#R_UNEXPECT       ; status is unexpected
        ld      4(iy),#DEFAULT_AREA     ; default area
        ld      5(iy),#NO_SYM           ; stacked symbol
        ld      6(iy),#0                ; fname len
        ld      7(iy),#0                ; ext len
~~~

Now let's write the top routine.

~~~asm
fpa_nextsym:
        ;; get next symbol
        ld      a,(hl)
        push    hl                      ; store hl!
        ;; find transition
        call    fpa_find_transition
        ;; if not found then unexpected error
        jr      nz,fpa_done
        ;; else transition function id is in register l
        call    fpa_execfn
        jr      nz,fpa_done             ; if not zero then status!
        ;; is it final state?
        ld      a,2(iy)
        and     #0x0f
        cp      #S_END
        jr      z,fpa_done
        ;; loop
        pop     hl                      ; restore hl
        inc     hl                      ; next symbol
        jr      fpa_nextsym             ; and loop
~~~

It's dead simple. We take a symbol (a char) from the filename. Based on the symbol and the current state, the `fpa_find_transition` function finds the transition. It reports an error if not found. And calls the function if found. Before moving to the next symbol, we check if we have reached the final state.

We find the transition by iterating through the entire finite-state machine.

~~~asm
        ;; find transition
fpa_find_transition:
        ld      hl,#fpa_automata        ; address of mealy automata
        ;; b=total transitions
        ld      b,#((efpa_automata-fpa_automata)/2)
        ld      c,a                     ; store a
fpaft_loop:
        ld      a,(hl)                  ; get first byte
        and     #0b00001111             ; get state
        cp      2(iy)                   ; is it current state?
        call    z,fpaft_test            ; call test
        jr      nz,fpaft_next           ; test failed, next trans.
        inc     hl                      ; get next byte
        ld      a,(hl)                  ; get second byte to a
        and     #0b00001111             ; grab next state
        ld      2(iy),a                 ; store to current state
        ld      a,(hl)                  ; get second byte to a
        and     #0b11110000             ; extract function
        ld      l,a                     ; get function to l
        ;; and return success
        xor     a
        ld      a,c
        ret
fpaft_next:
        inc     hl                      ; next state
        inc     hl
        djnz    fpaft_loop              ; and loop it
        ;; if we are here, we did not find
        ;; the transition. clear zero flag!
fpaft_unexpect_sym:
        ld      3(iy), #R_UNEXPECT
fpaft_set_z:
        xor     a
        cp      #0xff                   ; rest z flag
        ld      a,c                     ; resotre a
        ret
~~~

The `fpaft_test` function calls the tests defined in the transition and sets the `Z` flag. It uses the design pattern, described in [Z80 Patterns: The Case Statement](https://github.com/tstih/mavrica/blob/main/docs/Z80-CASE.md).

Finally, the logic to populate the `fcb_t` and return arguments correctly is encapsulated in FSM functions. Following is an example of the SET DRIVE function.

~~~asm
        ;; set drive
fpafn_set_drv:
        ld      a,5(iy)                 ; get stacked symbol
        ld      5(iy),#0                ; empty stack
        exx
        ld      (de),a                  ; first byte of FCB 
        exx
        xor     a
        ret
~~~