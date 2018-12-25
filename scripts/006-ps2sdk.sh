#!/bin/bash
# ps2sdk.sh by uyjulian
# based on ps2sdk.sh by Dan Peori (danpeori@oopo.net)
# changed to use Git by Mathias Lafeldt <misfire@debugon.org>

# make sure ps2sdk's makefile does not use it
unset PS2SDKSRC

## Download the source code.
if test ! -d "ps2sdk/.git"; then
	git clone https://github.com/uyjulian/ps2sdk && cd ps2sdk && git reset --hard origin/uyjworking || exit 1
else
	cd ps2sdk &&
		git pull && git fetch origin &&
		git reset --hard origin/uyjworking || exit 1
fi

## Determine the maximum number of processes that Make can work with.
## MinGW's Make doesn't work properly with multi-core processors.
# OSVER=$(uname)
# if [ ${OSVER:0:10} == MINGW32_NT ]; then
# 	PROC_NR=2
# elif [ ${OSVER:0:6} == Darwin ]; then
# 	PROC_NR=$(sysctl -n hw.ncpu)
# else
# 	PROC_NR=$(nproc)
# fi

## Rename variables
find . -name Makefile\* -exec sed -i 's/\$(PS2SDK)/$(PS2SDKUJ)/g' '{}' \;
find . -name Rules\* -exec sed -i 's/\$(PS2SDK)/$(PS2SDKUJ)/g' '{}' \;
find . -name Makefile\* -exec sed -i 's/\$(PS2DEV)/$(PS2DEVUJ)/g' '{}' \;

## Build and install
make --quiet clean && make --quiet && make --quiet install && make --quiet clean || { exit 1; }

## Replace newlib's crt0 with the one in ps2sdk.
# ln -sf "$PS2SDK/ee/startup/crt0.o" "$PS2DEV/ee/lib/gcc-lib/ee/3.2.3/crt0.o" || { exit 1; }
# ln -sf "$PS2SDK/ee/startup/crt0.o" "$PS2DEV/ee/ee/lib/crt0.o" || { exit 1; }
