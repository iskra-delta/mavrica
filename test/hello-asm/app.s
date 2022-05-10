        
        .area   _CODE
        ld      a,b
        and     #0x07
        or      #0x40
        ld      h,a
        ld      a,b
        rrca
        rrca
        rrca
        and     #0x18
        or      h
        ld      h,a
        ld      a,b
        rla
        rla
        and     #0xe0
        ld      l,a
        ret
        .area   _DATA