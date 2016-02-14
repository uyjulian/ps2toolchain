#!/bin/bash
# binutils-2.25.1.sh by SP193 (ysai187@yahoo.com)
# Originally binutils-2.14.sh by Dan Peori (danpeori@oopo.net)
# There is no support for the "dvp" because I never worked with it
# and don't actually understand why the old changes were necessary.

 BINUTILS_VERSION=2.25.1
 ## Download the source code.
 SOURCE=http://ftpmirror.gnu.org/binutils/binutils-$BINUTILS_VERSION.tar.bz2
 wget --continue $SOURCE || { exit 1; }

 ## Unpack the source code.
 echo Decompressing Binutils $BINUTILS_VERSION. Please wait.
 rm -Rf binutils-$BINUTILS_VERSION && tar xfj binutils-$BINUTILS_VERSION.tar.bz2 || { exit 1; }

 ## Enter the source directory and patch the source code.
 cd binutils-$BINUTILS_VERSION || { exit 1; }
 if [ -e ../../patches/binutils-$BINUTILS_VERSION-PS2.patch ]; then
 	cat ../../patches/binutils-$BINUTILS_VERSION-PS2.patch | patch -p1 || { exit 1; }
 fi

 target_names=("ee" "iop")
 targets=("mips64r5900el-ps2-elf" "mipsel-ps2-irx")
 extra_opts=("--with-float=hard" "")

 ## For each target...
 for ((i=0; i<${#target_names[@]}; i++)); do
  TARG_NAME=${target_names[i]}
  TARGET=${targets[i]}
  TARG_XTRA_OPTS=${extra_opts[i]}

  ## Create and enter the build directory.
  mkdir build-$TARG_NAME && cd build-$TARG_NAME || { exit 1; }

  ## Configure the build.
  ../configure --prefix="$PS2DEV/$TARG_NAME" --target="$TARGET" $TARG_XTRA_OPTS || { exit 1; }

  ## Compile and install.
  make clean && make -j 2 && make install && make clean || { exit 1; }

  ## Exit the build directory.
  cd .. || { exit 1; }

 ## End target.
 done
