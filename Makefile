# We only allow compilation on linux!
ifneq ($(shell uname), Linux)
$(error OS must be Linux!)
endif

# Check if all required tools are on the system.
REQUIRED = sdcc sdar sdasz80 sdldz80 sdobjcopy sed cpmcp
K := $(foreach exec,$(REQUIRED),\
    $(if $(shell which $(exec)),,$(error "$(exec) not found. Please install or add to path.")))

# Global settings: folders.
export ROOT 		=	$(realpath .)
export BUILD_DIR	=	$(ROOT)/build
export BIN_DIR		=	$(ROOT)/bin
export SRC_DIR		=	$(ROOT)/src
export LIB_DIR		=	$(ROOT)/lib
export INC_DIR		=	$(SRC_DIR) \
						$(LIB_DIR)/idp-udev/include
export DISK_DIR		=	$(ROOT)/disk

# Globa settings: 8 bit tools.
export CC			=	sdcc
export CFLAGS		=	--std-c11 -mz80 --debug --nostdinc \
						$(addprefix -I,$(INC_DIR))
export AS			=	sdasz80
export ASFLAGS		=	-xlos -g
export AR			=	sdar
export ARFLAGS		=	-rc
export LD			=	sdcc
export LDFLAGS		=	-mz80 -Wl -y --code-loc 0x100 \
						--no-std-crt0 --nostdlib --nostdinc \
						$(addprefix -L,$(BIN_DIR)) \
						-lusdcc -lulibc -lugpx -p
export OBJCOPY		=	sdobjcopy
export CRT0			=	crt0

# Data segment fix (relink due to SDCC bug)
export L2           =   sdldz80
export L2FLAGS      =   -nf
export L2FIX        =   sed '/-b _DATA = 0x8000/d'

# Floppy disk image
export FLOPPY		=	$(BIN_DIR)/fddb.img

# Rules.
.PHONY: all
all:	mkdirs $(LIB_DIR) $(SRC_DIR) mkdisk

.PHONY: $(SRC_DIR)
$(SRC_DIR):
	$(MAKE) -C $@

.PHONY: $(LIB_DIR)
$(LIB_DIR):
	$(MAKE) -C $@ BIN_DIR=$(BIN_DIR) BUILD_DIR=$(BUILD_DIR)/lib

.PHONY: mkdirs
mkdirs:
	# Create build dir.
	mkdir -p $(BUILD_DIR)
	# And bin dir.
	mkdir -p $(BIN_DIR)

.PHONY: mkdisk
mkdisk: 
	# Inside bin dir.
	cp $(DISK_DIR)/diskdefs .
	mkfs.cpm -f idpfdd -t $(FLOPPY)
	cpmcp -f idpfdd $(FLOPPY) $(BUILD_DIR)/mavrica.com 0:mavrica.com
	cpmcp -f idpfdd $(FLOPPY) $(DISK_DIR)/extras/*.* 0:
	rm ./diskdefs

.PHONY: install
install: all
	cp $(FLOPPY) ~/Dex/fddb.img

.PHONY: clean
clean: 
	rm -f -r $(BIN_DIR)
	rm -f -r $(BUILD_DIR)