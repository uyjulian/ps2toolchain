#!/bin/sh
# gcc-3.2.3-stage1.sh by AKuHAK

 GCC_VERSION=3.2.3
 EE_GCC_VERSION=5.3.0
 ## Download the source code.
 SOURCE=http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2
 wget --continue $SOURCE || { exit 1; }
 SOURCE=http://ftpmirror.gnu.org/gcc/gcc-$EE_GCC_VERSION/gcc-$EE_GCC_VERSION.tar.bz2
 wget --continue $SOURCE || { exit 1; }

 ## Unpack the source code.
 echo Decompressing GCC $GCC_VERSION. Please wait.
 rm -Rf gcc-$GCC_VERSION && tar xfj gcc-$GCC_VERSION.tar.bz2 || { exit 1; }
 echo Decompressing GCC $EE_GCC_VERSION. Please wait.
 rm -Rf gcc-$EE_GCC_VERSION && tar xfj gcc-$EE_GCC_VERSION.tar.bz2 || { exit 1; }

 ## Enter the source directory and patch the source code.
 cd gcc-$GCC_VERSION || { exit 1; }
 if [ -e ../../patches/gcc-$GCC_VERSION-PS2.patch ]; then
 	cat ../../patches/gcc-$GCC_VERSION-PS2.patch | patch -p1 || { exit 1; }
 fi

 ## Make the configure files
 autoreconf || { exit 1; }

 ## For each target...
 for TARGET in "iop"; do

  ## Create and enter the build directory.
  mkdir build-$TARGET-stage1 && cd build-$TARGET-stage1 || { exit 1; }

  ## Configure the build.
  ../configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" --enable-languages="c" --with-newlib --without-headers || { exit 1; }

  ## Compile and install.
  make clean && make -j 2 && make install && make clean || { exit 1; }

  ## Exit the build directory.
  cd .. || { exit 1; }

 ## End target.
 done

 cd ..

 ## Enter the source directory and patch the source code.
 cd gcc-$EE_GCC_VERSION || { exit 1; }
 if [ -e ../../patches/gcc-$EE_GCC_VERSION-PS2.patch ]; then
 	cat ../../patches/gcc-$EE_GCC_VERSION-PS2.patch | patch -p1 || { exit 1; }
 fi

 ## For each target...
 for TARGET in "ee"; do

  ## Create and enter the build directory.
  mkdir build-$TARGET-stage1 && cd build-$TARGET-stage1 || { exit 1; }

  ## Configure the build.
  ../configure --prefix="$PS2DEV/$TARGET" --target="mips64r5900el-ps2-elf" --program-prefix="$TARGET-" --enable-languages="c" --disable-nls --disable-shared --disable-libssp --disable-libmudflap --disable-threads --disable-libgomp --disable-libquadmath --disable-target-libiberty --disable-target-zlib --without-ppl --without-cloog --with-headers=no --disable-libada --disable-libatomic --disable-multilib --with-float=hard || { exit 1; }

  ## Compile and install.
  make clean && make -j 2 && make install && make clean || { exit 1; }

  ## Exit the build directory.
  cd .. || { exit 1; }

 ## End target.
 done
