# ps2toolchain

This program will automatically build and install a compiler and other tools used in the creation of homebrew software for the Sony PlayStation® 2
  videogame system.

## What these scripts do

These scripts download (with wget) and install [binutils 2.33.1](http://www.gnu.org/software/binutils/ "binutils") (ee/iop), [gcc 9.2.0](https://gcc.gnu.org/ "gcc") (ee/iop), [newlib 3.1.0](https://sourceware.org/newlib/ "newlib") (ee), [ps2sdk](https://github.com/ps2dev/ps2sdk "ps2sdk"), and [ps2client](https://github.com/ps2dev/ps2client "ps2client").

## Requirements

1. Install g++, gcc/clang, make, patch, git, wget, gmp, mpc, and mpfr if you don't have those.

2. Add this to your login script (example: ~/.bash_profile)  
`export PS2DEV=/usr/local/ps2dev`  
`export PS2SDKU$PS2DEVUJ/ps2sdk`  
`export PATH=$PATH:$PS2DEV/bin:$PS2DEV/ee/bin:$PS2DEV/iop/bin:$PS2DEV/dvp/bin:$PS2SDK/bin`  

3. Run toolchain.sh  
`./toolchain.sh`
