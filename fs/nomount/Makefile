# Makefile for NoMount

ifeq ($(filter /%,$(src)),)
NM_REAL_PATH := $(realpath $(srctree)/$(src))
else
NM_REAL_PATH := $(realpath $(src))
endif

# Vendored into the kernel tree, so the git detection can't see NoMount's own
# history. Pinned to maxsteeel/nomount master 7046c7ad (v2.1.1).
NOMOUNT_COMMITS := 555

ifneq ($(NOMOUNT_COMMITS),)
ccflags-y += -DNOMOUNT_COMMIT_COUNT=\"$(NOMOUNT_COMMITS)\"
endif

obj-$(CONFIG_NOMOUNT) += nomount.o
ccflags-y += -std=gnu11 -Wno-declaration-after-statement -O3 -fno-stack-protector
