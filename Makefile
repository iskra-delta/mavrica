# Makefile for Mavrica Z80 JIT project with linker command file and explicit start address

# Directories
SRC_DIR = src
BUILD_DIR = build
BIN_DIR = bin

# Tools
AS = sdasz80
LD = sdld
OBJCOPY = sdobjcopy

# Source files
SOURCES = $(shell find $(SRC_DIR) -type f -name '*.s')
MAIN_SRC = $(shell find $(SRC_DIR) -type f -name 'main.s')
OTHER_SRCS = $(filter-out $(MAIN_SRC), $(SOURCES))

# Output object file names
MAIN_OBJ = $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.rel, $(MAIN_SRC))
OTHER_OBJS = $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.rel, $(OTHER_SRCS))
OBJECTS = $(MAIN_OBJ) $(OTHER_OBJS)

# Output files
IHX = $(BUILD_DIR)/mavrica.ihx
BIN = $(BIN_DIR)/mavrica.bin
MAP = $(BUILD_DIR)/mavrica.map
LINKFILE = $(BUILD_DIR)/linkfile.lk

# Flags
ASFLAGS = -plosgff
OBJCOPYFLAGS = -I ihex -O binary

# Default target
all: check_sources $(BIN)

# Check if source files exist
check_sources:
	@if [ -z "$(SOURCES)" ]; then \
		echo "Error: No .s files found in $(SRC_DIR)/ or its subdirectories"; \
		exit 1; \
	fi
	@echo "Found sources: $(SOURCES)"

# Link object files using a linker command file
$(IHX): $(OBJECTS)
	@mkdir -p $(BUILD_DIR)
	@echo "Creating linker command file..."
	@echo "-b_CODE=0x0000" > $(LINKFILE)
	@echo "-i" >> $(LINKFILE)
	@echo "-m" >> $(LINKFILE)
	@echo "-o mavrica.ihx" >> $(LINKFILE)
	@for obj in $(OBJECTS); do echo "$$(realpath --relative-to=$(BUILD_DIR) $$obj)" >> $(LINKFILE); done
	@echo "Linking via linker command file..."
	@cd $(BUILD_DIR) && $(LD) -f linkfile.lk

# Convert .ihx to .bin
$(BIN): $(IHX)
	@mkdir -p $(BIN_DIR)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

# Assemble .s files to .rel
$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	@echo "Assembling: $<"
	$(AS) $(ASFLAGS) -o $@ $<

# Clean targets
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

.PHONY: all clean check_sources