# We only allow compilation on linux!
ifneq ($(shell uname), Linux)
$(error OS must be Linux!)
endif

# Tools
AS = sdasz80
LD = sdld
OBJCOPY = sdobjcopy

# Check if all required tools are on the system.
REQUIRED = sdasz80 sdldz80 sdobjcopy
K := $(foreach exec,$(REQUIRED),\
    $(if $(shell which $(exec)),,$(error "$(exec) not found. Please install or add to path.")))

# Directories
SRC_DIR = src
BUILD_DIR = build

# All source files, with main.s explicitly first
SOURCES := $(SRC_DIR)/main.s \
           $(filter-out $(SRC_DIR)/main.s, $(shell find $(SRC_DIR) -type f -name '*.s'))
OBJECTS := $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.rel, $(SOURCES))

# Output files
TARGET = $(BUILD_DIR)/mavrica
LINKFILE = $(TARGET).lk

# Flags
ASFLAGS = -plosgff
OBJCOPYFLAGS = -I ihex -O binary

# Default target
all: $(TARGET).bin

# Link object files using a linker command file
$(TARGET).ihx: $(OBJECTS)
	@mkdir -p $(BUILD_DIR)
	@echo "-b_CODE=0x0000" > $(LINKFILE)
	@echo "-i" >> $(LINKFILE)
	@echo "-m" >> $(LINKFILE)
	@echo "-j" >> $(LINKFILE)
	@echo "-o mavrica.ihx" >> $(LINKFILE)
	@for obj in $(OBJECTS); do echo "$$(realpath --relative-to=$(BUILD_DIR) $$obj)" >> $(LINKFILE); done
	@cd $(BUILD_DIR) && $(LD) -f $(notdir $(LINKFILE))

# Convert .ihx to .bin
$(TARGET).bin: $(TARGET).ihx
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

# Assemble .s files to .rel
$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $<

# Clean targets
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean