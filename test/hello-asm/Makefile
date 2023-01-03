SRC			=	$(wildcard *.s)
BIN			=	$(patsubst %.s,%.bin,$(SRC)) 
ADDR		=	0x8000
AS          =   sdasz80
ASFLAGS     =   -xlos -g
LD          =   sdcc
LDFLAGS     =   -mz80 -Wl -y --code-loc $(ADDR) \
				--no-std-crt0 --nostdlib --nostdinc \
				-p
L2          =   sdldz80
L2FLAGS     =   -nf
L2FIX       =   sed '/-b _DATA = 0x8000/d'
OBJCOPY     =   sdobjcopy
RM 			= 	rm -f

.PHONY: all
all: 	$(BIN)

%.bin: 	%.ihx
	$(OBJCOPY) -I ihex -O binary $(basename $@).ihx $(basename $@).bin

.PRECIOUS: %.ihx
%.ihx: 	%.rel
	$(LD) $(LDFLAGS) -o $(basename $@).ihx $(basename $@).rel
	$(L2FIX) $(basename $@).lk > $(basename $@).link
	$(L2) $(L2FLAGS) $(basename $@).link

.PRECIOUS: %.rel
%.rel: 	%.s
	$(AS) $(ASFLAGS) $(@F) $<

.PHONY: clean
clean:
	$(RM) *.lst
	$(RM) *.rel
	$(RM) *.sym
	$(RM) *.cdb
	$(RM) *.ihx
	$(RM) *.lk
	$(RM) *.link
	$(RM) *.map
	$(RM) *.noi
	$(RM) *.bin