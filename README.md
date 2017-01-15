# ps2toolchain

This program will automatically build and install a compiler and other tools used in the creation of homebrew software for the Sony PlayStation® 2
  videogame system.

## What these scripts do

These scripts download (with wget) and install [binutils 2.27](http://www.gnu.org/software/binutils/ "binutils") (ee/iop), [gcc 6.3.0](https://gcc.gnu.org/ "gcc") (ee/iop), [newlib 2.5.0](https://sourceware.org/newlib/ "newlib") (ee), [ps2sdk](https://github.com/ps2dev/ps2sdk "ps2sdk"), and [ps2client](https://github.com/ps2dev/ps2client "ps2client").

## Requirements

1. Install g++, gcc/clang, make, patch, git, wget, gmp, mpc, and mpfr if you don't have those.

2. Add this to your login script (example: ~/.bash_profile)  
`export PS2DEVUJ=/usr/local/ps2devuj`  
`export PS2SDKUJ=$PS2DEVUJ/ps2sdk`  
`export PATH=$PATH:$PS2DEVUJ/bin:$PS2DEVUJ/ee/bin:$PS2DEVUJ/iop/bin:$PS2DEVUJ/dvp/bin:$PS2SDKUJ/bin`  

3. Run toolchain.sh  
`./toolchain.sh`
