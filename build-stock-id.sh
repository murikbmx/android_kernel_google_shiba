#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# Build the Pixel 8 (zuma) kernel so that "uname -r", "uname -v" and
# /proc/version match the stock LineageOS 24.0 shiba kernel:
#
#   Linux version 6.1.162-android14-11-g33365f631c28-ab16466998
#   (build-user@build-host) (Android (10087095, +pgo, +bolt, +lto, -mlgo,
#   based on r487747c) clang version 17.0.2 (...), LLD 17.0.2)
#   #1 SMP PREEMPT Tue Sep 29 05:28:16 UTC 2026
#
# The release suffix comes from CONFIG_LOCALVERSION in zuma_defconfig, the
# rest from the KBUILD_BUILD_* variables below (KBUILD_BUILD_COMPILER is
# handled by scripts/mkcompile_h). LOCALVERSION is set but empty so that
# scripts/setlocalversion does not append "+".
#
# Usage: ./build-stock-id.sh [make targets...]
#   With no targets, runs zuma_defconfig and then the default build.
#
# Environment:
#   TC   directory with the aarch64-linux-* GCC toolchain binaries
#        (kernel.org crosstool GCC 14.2.0, nolibc); default: use $PATH
#   O    output directory; default: out
#   CROSS_COMPILE  toolchain prefix; default: aarch64-linux-
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

if [ -n "${TC:-}" ]; then
	export PATH="$TC:$PATH"
fi
CROSS_COMPILE=${CROSS_COMPILE:-aarch64-linux-}
O=${O:-out}

if ! command -v "${CROSS_COMPILE}gcc" >/dev/null; then
	echo "${CROSS_COMPILE}gcc not found; set TC to the toolchain bin directory" >&2
	exit 1
fi

export KBUILD_BUILD_USER=build-user
export KBUILD_BUILD_HOST=build-host
export KBUILD_BUILD_VERSION=1
export KBUILD_BUILD_TIMESTAMP="Tue Sep 29 05:28:16 UTC 2026"
export KBUILD_BUILD_COMPILER="Android (10087095, +pgo, +bolt, +lto, -mlgo, based on r487747c) clang version 17.0.2 (https://android.googlesource.com/toolchain/llvm-project d9f89f4d16663d5012e5c09495f3b30ece3d2362), LLD 17.0.2"
export LOCALVERSION=

MAKE=(make O="$O" ARCH=arm64 CROSS_COMPILE="$CROSS_COMPILE"
      CC="${CROSS_COMPILE}gcc" -j"$(nproc --all)")

if [ $# -eq 0 ]; then
	"${MAKE[@]}" zuma_defconfig
	"${MAKE[@]}"
else
	"${MAKE[@]}" "$@"
fi
