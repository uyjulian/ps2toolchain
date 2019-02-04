#!/bin/bash
# binutils-2.31.sh by uyjulian
# Based on binutils-2.14.sh by Dan Peori (danpeori@oopo.net)

BINUTILS_VERSION=2.25.1
## Download the source code.
SOURCE=http://ftpmirror.gnu.org/binutils/binutils-$BINUTILS_VERSION.tar.gz
wget --continue $SOURCE || { exit 1; }

## Unpack the source code.
echo Decompressing Binutils $BINUTILS_VERSION. Please wait.
rm -Rf binutils-$BINUTILS_VERSION && pigz -dc binutils-$BINUTILS_VERSION.tar.gz | pv | tar xf - || { exit 1; }

## Enter the source directory and patch the source code.
cd binutils-$BINUTILS_VERSION || { exit 1; }
if [ -e ../../patches/binutils-$BINUTILS_VERSION-PS2.patch ]; then
	cat ../../patches/binutils-$BINUTILS_VERSION-PS2.patch | patch -p1 || { exit 1; }
fi

## Determine the maximum number of processes that Make can work with.
## MinGW's Make doesn't work properly with multi-core processors.
OSVER=$(uname)
if [ ${OSVER:0:10} == MINGW32_NT ]; then
	PROC_NR=2
elif [ ${OSVER:0:6} == Darwin ]; then
	PROC_NR=$(sysctl -n hw.ncpu)
else
	PROC_NR=$(nproc)
fi

target_names=("iop")
targets=("mipsel-ps2-irx")
extra_opts=("")

## For each target...
for ((i=0; i<${#target_names[@]}; i++)); do
	TARG_NAME=${target_names[i]}
	TARGET=${targets[i]}
	TARG_XTRA_OPTS=${extra_opts[i]}

	## Create and enter the build directory.
	mkdir build-$TARG_NAME && cd build-$TARG_NAME || { exit 1; }

	## Configure the build.
	../configure --quiet --prefix="$PS2DEV/$TARG_NAME" --target="$TARGET" $TARG_XTRA_OPTS || { exit 1; }

	## Compile and install.
	make --quiet clean && make --quiet -j $PROC_NR && make --quiet install && make --quiet clean || { exit 1; }

	## Exit the build directory.
	cd .. || { exit 1; }

	## End target.
done
