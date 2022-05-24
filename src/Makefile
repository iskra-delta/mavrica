# Virtual paths are all subfolders!
SDIRS	=	$(wildcard */)
vpath %.c $(SDIRS)
vpath %.s $(SDIRS)
vpath %.h $(SDIRS)

# Source files.
C_SRCS	=	$(wildcard */*.c)
S_SRCS	=	$(filter-out $(CRT0).s, $(wildcard */*.s))
OBJS	=	$(addprefix $(BUILD_DIR)/, \
				$(notdir \
					$(patsubst %.c,%.rel,$(C_SRCS)) \
					$(patsubst %.s,%.rel,$(S_SRCS)) \
				) \
			)
TARGET = mavrica

# Rules.
.PHONY: all
all: $(BUILD_DIR)/$(TARGET).com

$(BUILD_DIR)/$(TARGET).com: $(BUILD_DIR)/$(TARGET).ihx
	$(OBJCOPY) -I ihex -O binary $(basename $@).ihx $(basename $@).com

$(BUILD_DIR)/$(TARGET).ihx: $(BIN_DIR)/$(CRT0).rel $(OBJS)
	$(LD) $(LDFLAGS) -o $(BUILD_DIR)/$(TARGET).ihx \
		$(BIN_DIR)/$(CRT0).rel $(OBJS)
	$(L2FIX) $(BUILD_DIR)/$(TARGET).lk > $(BUILD_DIR)/$(TARGET).link
	$(L2) $(L2FLAGS) $(BUILD_DIR)/$(TARGET).link

$(BUILD_DIR)/$(CRT0).rel: $(LIB_DIR)/ulibc/$(CRT0).s
	$(AS) $(ASFLAGS) $(BUILD_DIR)/$(@F) $<

$(BUILD_DIR)/%.rel: %.c
	$(CC) -c -o $(BUILD_DIR)/$(@F) $< $(CFLAGS)

$(BUILD_DIR)/%.rel: %.s
	$(AS) $(ASFLAGS) $(BUILD_DIR)/$(@F) $<

.PHONY: clean
clean: