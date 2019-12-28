#!/bin/bash
# gcc-5.5.0-stage2.sh by Julian Uy (uyjulian@gmail.com)
# Based on gcc-5.3.0-stage2.sh by SP193 (ysai187@yahoo.com)
# Based on gcc-3.2.3-stage2.sh by Julian Uy
# Based on gcc-3.2.2-stage2.sh by Naomi Peori (naomi@peori.ca)

GCC_VERSION=5.5.0
ISL_VERSION=0.18
## Download the source code.
GCC_SOURCE=http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz
wget --continue $GCC_SOURCE || { exit 1; }
ISL_SOURCE=http://isl.gforge.inria.fr/isl-$ISL_VERSION.tar.xz
wget --continue $ISL_SOURCE || { exit 1; }

## Unpack the source code.
echo Decompressing GCC $GCC_VERSION. Please wait.
rm -Rf gcc-$GCC_VERSION && tar xfJ gcc-$GCC_VERSION.tar.xz || { exit 1; }
echo Decompressing ISL $ISL_VERSION. Please wait.
rm -Rf isl-$ISL_VERSION && tar xfJ isl-$ISL_VERSION.tar.xz || { exit 1; }

## Enter the source directory and patch the source code.
cd gcc-$GCC_VERSION || { exit 1; }

## Link ISL for in tree build.
ln -s ../isl-$ISL_VERSION isl

## Apply the uncommitted patches first (libgcc, short-loop bug, EE-core extensions, MMI)
## TODO: Remove these lines, once the patches are submitted.
cat ../../patches/gcc-$GCC_VERSION-libgcc.patch | patch -p1 || { exit 1; }
cat ../../patches/gcc-$GCC_VERSION-ee.patch | patch -p1 || { exit 1; }
cat ../../patches/gcc-$GCC_VERSION-mmi.patch | patch -p1 || { exit 1; }

if [ -e ../../patches/gcc-$GCC_VERSION-PS2.patch ]; then
	cat ../../patches/gcc-$GCC_VERSION-PS2.patch | patch -p1 || { exit 1; }
fi

OSVER=$(uname)
## Apple needs to pretend to be linux
if [ ${OSVER:0:6} == Darwin ]; then
	TARG_XTRA_OPTS="--build=i386-linux-gnu --host=i386-linux-gnu --enable-cxx-flags=-G0"
elif [ ${OSVER:0:10} == MINGW64_NT ]; then
	TARG_XTRA_OPTS="--build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --enable-cxx-flags=-G0"
else
	TARG_XTRA_OPTS="--enable-cxx-flags=-G0"
fi

## Determine the maximum number of processes that Make can work with.
if [ ${OSVER:0:5} == MINGW ]; then
	PROC_NR=$NUMBER_OF_PROCESSORS
elif [ ${OSVER:0:6} == Darwin ]; then
	PROC_NR=$(sysctl -n hw.ncpu)
else
	PROC_NR=$(nproc)
fi

echo "Building with $PROC_NR jobs"

TARG_NAME="ee"
TARGET="mips64r5900el-ps2-elf"
TARG_XTRA_OPTS="--with-float=hard --with-newlib"
## Create and enter the build directory.
mkdir build-$TARG_NAME-stage2 && cd build-$TARG_NAME-stage2 || { exit 1; }

## Configure the build.
../configure --prefix="$PS2DEV/$TARG_NAME" --target="$TARGET" --enable-languages="c,c++" --disable-nls --disable-shared --disable-libssp --disable-libmudflap --disable-threads --disable-libgomp --disable-libquadmath --disable-target-libiberty --disable-target-zlib --without-ppl --without-cloog --with-headers=no --disable-libada --disable-libatomic --disable-multilib --with-headers="$PS2DEV/$TARG_NAME/$TARGET/include" --with-isl $TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make --quiet clean && make --quiet -j $PROC_NR && make --quiet install && make --quiet clean || { exit 1; }
