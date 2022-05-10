APP			=	app
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

$(APP).bin: $(APP).ihx
	$(OBJCOPY) -I ihex -O binary $(basename $@).ihx $(basename $@).bin

$(APP).ihx:	$(APP).rel
	$(LD) $(LDFLAGS) -o $(APP).ihx $(APP).rel
	$(L2FIX) $(APP).lk > $(APP).link
	$(L2) $(L2FLAGS) $(APP).link

$(APP).rel: $(APP).s
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