#!/bin/sh
# gcc-5.3.0-stage2.sh by SP193
# Originally gcc-3.2.2-stage2.sh by Dan Peori (danpeori@oopo.net)

 GCC_VERSION=5.3.0
 ## Download the source code.
 SOURCE=http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2
 wget --continue $SOURCE || { exit 1; }

 ## Unpack the source code.
 echo Decompressing GCC $GCC_VERSION. Please wait.
 rm -Rf gcc-$GCC_VERSION && tar xfj gcc-$GCC_VERSION.tar.bz2 || { exit 1; }

 ## Enter the source directory and patch the source code.
 cd gcc-$GCC_VERSION || { exit 1; }
 ## Apply the bug-fix to libgcc first.
 cat ../../patches/gcc-5.3.0-libgcc.patch | patch -p1 || { exit 1; }
 if [ -e ../../patches/gcc-$GCC_VERSION-PS2.patch ]; then
 	cat ../../patches/gcc-$GCC_VERSION-PS2.patch | patch -p1 || { exit 1; }
 fi

 ## Create and enter the build directory.
 mkdir build-ee-stage2 && cd build-ee-stage2 || { exit 1; }

 ## Configure the build.
 ../configure --prefix="$PS2DEV/ee" --target="mips64r5900el-ps2-elf" --program-prefix="ee-" --enable-languages="c,c++" --disable-nls --disable-shared --disable-libssp --disable-libmudflap --disable-threads --disable-libgomp --disable-libquadmath --disable-target-libiberty --disable-target-zlib --without-ppl --without-cloog --with-headers=no --disable-libada --disable-libatomic --disable-multilib --with-float=hard --with-newlib --with-headers="$PS2DEV/ee/ee/include" || { exit 1; }

 ## Compile and install.
 make clean && make -j 2 && make install && make clean || { exit 1; }
