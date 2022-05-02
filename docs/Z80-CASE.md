# Z80 Design Patterns: The Case Statement

A good design can save you a lot of work. Take, for example, this *case* statement. 

~~~asm
        ld      a,(hl)                  ; get a 
        cp      #' '
        jr      z,is_space
        cp      #'_'
        jr      z,is_underscore
        cp      #'$'
        jr      z,is_dollar
        jr      error_handler
~~~

It is well structured and easy to understand. This is possible because compare instruction returns the result in the `Z`  flag and preserves the value of register `A`. But what if you want to check if a value falls between two bounds? Writing code using the `CP` instruction would break the natural flow and introduce jumps and complexity.

Let's encapsulate the comparison operation into a function that behaves like the `CP` instruction and sets or resets the Z flag to keep the flow intact.

Our test function below accepts the symbol in the `A` register and tests if within the bounds of registers `D` and `E` so that **D >= A >= E**. 

~~~asm
        ;; test if a is within DE: D >= A >= E
        ;; input(s):
        ;;  A   value to test (preserved!)
        ;;  DE   interval
        ;; output(s):
        ;;  Z    zero flag is 1 if inside, 0 if outside
        ;; affects:
        ;;  D, E, flags
test_inside_interval:
        push    bc                      ; store original bc
        ld      c,a                     ; store a
        cp      e			            ; a=a-e
        jr      nc, tidg_possible	    ; a>=e       
        jr      tidg_false              ; false
tidg_possible:
        cp      d                       ; a=a-d
        jr      c,tidg_true		        ; a<d
        jr      z,tidg_true             ; a=d
        jr      tidg_false
tidg_true:
        ;; set zero flag
        xor     a                       ; a=0, set zero flag
        ld      a,c                     ; restore a
        pop     bc                      ; restore bc
        ret
tidg_false:
        ;; reset zero flag
        xor     a
        cp      #0xff                   ; reset zero flag
        ld      a,c                     ; restore a
        pop     bc                      ; restore original bc
        ret
~~~

We can derive our tests by simply populating DE and A and calling this function. 

~~~asm
test_is_digit:
	    ld      de,#0x3930	            ; d='9', e='0'
        jr      test_inside_interval    ; ret optimization...
~~~

 > The `ret` optimization means that we jump on the test, and when it returns, it will go directly to the callee, so we save one call.

This approach enables us to chain calls like this.

~~~asm
test_is_alpha:
        call    test_is_upper
        ret     z
        jr      test_is_lower

test_is_upper:
        ld      de,#0x5a41              ; d='Z'. e='A'
        jr      test_inside_interval

test_is_lower:
        ld      de,#0x7a61              ; d='z', e='a'
        jr      test_inside_interval    ; last tests' result is the end result

test_is_alphanumeric:
        call    test_is_digit
        ret     z
        jr      test_is_alpha
~~~

Each of the functions above imitates the `CP`. Now we can finally write our case statement.

~~~asm
        ld      a,(hl)              
        call    test_is_digit           
        jr      z,is_digit
        cp      #' '
        jr      z,is_space
        cp      #'_'
        jr      z,is_underscore
        call    test_is_alpha
        jr      z,is_alpha
        jr      error_handler
~~~

[Follow this link for a real-life example](https://github.com/tstih/mavrica/blob/main/lib/ulibc/ctype.s) of this approach - a partial implementation of the ctype.h standard C library functions.