# src/Makefile – Iskra Delta Partner Z80 assembly build (runs inside docker)

# ------- paths (we run as: make -C src ...) -------
SRC_DIR    := .
BUILD_DIR  := ../build

# target comes from the top Makefile (e.g., TARGET=mavrica)
TARGET     ?= mavrica
OUT_BASE   := $(BUILD_DIR)/$(TARGET)

# ------- z80 params -------
LOAD_ADDR_HEX ?= 0x0000

# ------- tools -------
AS        := sdasz80
LD        := sdldz80
OBJCOPY   := sdobjcopy

# ------- flags -------
ASFLAGS   := -plosgfp
OBJCOPYFLAGS := -I ihex -O binary

# ------- sources (main.s first, then all other .s files) -------
MAIN_SRC := $(SRC_DIR)/main.s
MAIN_OBJ := $(BUILD_DIR)/main.rel

S_SRCS   := $(filter-out $(MAIN_SRC), \
              $(shell find $(SRC_DIR) -type f -name '*.s'))
S_OBJS   := $(patsubst $(SRC_DIR)/%.s,$(BUILD_DIR)/%.rel,$(S_SRCS))

OBJS     := $(S_OBJS)

# ------- outputs -------
IHX      := $(OUT_BASE).ihx
BIN      := $(OUT_BASE).bin
LINKFILE := $(OUT_BASE).lk

# ------- default -------
all: $(BIN)
	@echo "ok: $(notdir $(BIN))"

# ------- link via generated .lk -------
$(IHX): $(MAIN_OBJ) $(OBJS)
	@mkdir -p $(BUILD_DIR)
	@echo "[link] generating $(LINKFILE)"
	@{ \
	  echo "-b_CODE=$(LOAD_ADDR_HEX)"; \
	  echo "-i"; \
	  echo "-m"; \
	  echo "-j"; \
	  echo "-o $(notdir $(TARGET)).ihx"; \
	  echo "$$(realpath --relative-to=$(BUILD_DIR) $(MAIN_OBJ))"; \
	  for obj in $(OBJS); do echo "$$(realpath --relative-to=$(BUILD_DIR) $$obj)"; done; \
	} > $(LINKFILE)
	@echo "[link] sdldz80 -f $(notdir $(LINKFILE))"
	@cd $(BUILD_DIR) && $(LD) -f $(notdir $(LINKFILE))

# ------- ihx -> bin -------
$(BIN): $(IHX)
	@mkdir -p $(dir $@)
	@echo "[objcopy] $(notdir $@)"
	@$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

# ------- build rules -------
# Assemble main.s first
$(MAIN_OBJ): $(MAIN_SRC)
	@mkdir -p $(dir $@)
	@echo "[as] $< -> $@"
	@$(AS) $(ASFLAGS) -o $@ $<

# Assemble any .s -> .rel
$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	@echo "[as] $< -> $@"
	@$(AS) $(ASFLAGS) -o $@ $<

# ------- utilities -------
clean:
	@echo "[clean] removing $(BUILD_DIR)"
	@rm -rf "$(BUILD_DIR)"

.PHONY: all clean
