BUILDROOT_DIR := $(CURDIR)/buildroot
OUTPUT_DIR    := $(CURDIR)/output
BR2_EXTERNAL  := $(CURDIR)
DEFCONFIG     ?= myosotis_qemu_x86_64_defconfig

BR_MAKE = $(MAKE) -C $(BUILDROOT_DIR) O=$(OUTPUT_DIR) BR2_EXTERNAL=$(BR2_EXTERNAL)

.PHONY: all build defconfig menuconfig clean

all: build

$(BUILDROOT_DIR)/Makefile:
	./scripts/bootstrap.sh

defconfig: $(BUILDROOT_DIR)/Makefile
	$(BR_MAKE) $(DEFCONFIG)

build: defconfig
	$(BR_MAKE)

run: build
	./scripts/run-qemu.sh

menuconfig: defconfig
	$(BR_MAKE) menuconfig

clean:
	-$(BR_MAKE) clean
