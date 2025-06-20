# Makefile for generic Z80 assembler project with recursive source file search and map file

# Directories
SRC_DIR = src
BUILD_DIR = build
BIN_DIR = bin

# Tools
AS = sdasz80
LD = sdld
OBJCOPY = sdobjcopy

# Source files (recursively find all .s files in src/ and subdirectories)
SOURCES = $(shell find $(SRC_DIR) -type f -name '*.s')
OBJECTS = $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.rel, $(SOURCES))

# Output binary and map file
TARGET = $(BIN_DIR)/z80_project.bin
MAP_FILE = $(BUILD_DIR)/z80_project.map

# Compiler and linker flags
ASFLAGS = -plosgff
LDFLAGS = -i -m
OBJCOPYFLAGS = -I ihex -O binary

# Default target
all: check_sources $(TARGET)

# Check if source files exist
check_sources:
	@if [ -z "$(SOURCES)" ]; then \
		echo "Error: No .s files found in $(SRC_DIR)/ or its subdirectories"; \
		exit 1; \
	fi
	@echo "Found sources: $(SOURCES)"

# Link object files to create .ihx and .map files
$(BUILD_DIR)/z80_project.ihx: $(OBJECTS)
	@mkdir -p $(BUILD_DIR)
	@echo "Linking: $(OBJECTS)"
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS)

# Convert .ihx to .bin
$(TARGET): $(BUILD_DIR)/z80_project.ihx
	@mkdir -p $(BIN_DIR)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

# Assemble .s files to .rel files
$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	@echo "Assembling: $<"
	$(AS) $(ASFLAGS) -o $@ $<

# Clean up build and bin directories
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

# Phony targets
.PHONY: all clean check_sources