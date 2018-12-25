#!/bin/bash
# gcc-8.2.0-stage1.sh by uyjulian
# Based on gcc-3.2.3-stage1.sh by AKuHAK
# Based on gcc-3.2.2-stage1.sh by Dan Peori (danpeori@oopo.net)

GCC_VERSION=8.2.0
## Download the source code.
SOURCE=http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz
wget --continue $SOURCE || { exit 1; }

## Unpack the source code.
echo Decompressing GCC $GCC_VERSION. Please wait.
rm -Rf gcc-$GCC_VERSION && tar xJf gcc-$GCC_VERSION.tar.xz || { exit 1; }

## Enter the source directory and patch the source code.
cd gcc-$GCC_VERSION || { exit 1; }

## Apply the uncommitted patches first (libgcc, short-loop bug, EE-core extensions, MMI)
## TODO: Remove these lines, once the patches are submitted.
cat ../../patches/gcc-$GCC_VERSION-libgcc.patch | patch -p1 || { exit 1; }
cat ../../patches/gcc-$GCC_VERSION-ee.patch | patch -p1 || { exit 1; }
#cat ../../patches/gcc-$GCC_VERSION-mmi.patch | patch -p1 || { exit 1; }
if [ -e ../../patches/gcc-$GCC_VERSION-PS2.patch ]; then
	cat ../../patches/gcc-$GCC_VERSION-PS2.patch | patch -p1 || { exit 1; }
fi

## isl 0.20 broke GCC compilation: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=86724
## Remove once a new version is released.
cat ../../patches/gcc-$GCC_VERSION-isl.patch | patch -p1 || { exit 1; }

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

target_names=("ee" "iop")
targets=("mips64r5900el-ps2-elf" "mipsel-ps2-irx")
extra_opts=("--with-float=hard --with-newlib" "--disable-libstdcxx")

## For each target...
for ((i=0; i<${#target_names[@]}; i++)); do
	TARG_NAME=${target_names[i]}
	TARGET=${targets[i]}
	TARG_XTRA_OPTS=${extra_opts[i]}

	## Create and enter the build directory.
	mkdir build-$TARG_NAME-stage1 && cd build-$TARG_NAME-stage1 || { exit 1; }

	## Configure the build.
	../configure --quiet --prefix="$PS2DEVUJ/$TARG_NAME" --target="$TARGET" --enable-languages="c" --disable-nls --disable-shared --disable-libssp --disable-libmudflap --disable-threads --disable-libgomp --disable-libquadmath --disable-target-libiberty --disable-target-zlib --without-ppl --without-cloog --with-headers=no --disable-libada --disable-libatomic --disable-multilib $TARG_XTRA_OPTS || { exit 1; }

	## Compile and install.
	make --quiet clean && make --quiet -j $PROC_NR && make --quiet install && make --quiet clean || { exit 1; }

	## Exit the build directory.
	cd .. || { exit 1; }

	## End target.
done
