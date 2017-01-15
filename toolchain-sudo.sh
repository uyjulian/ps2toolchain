#!/bin/bash
# toolchain-sudo.sh by Dan Peori (danpeori@oopo.net)

## Enter the ps2toolchain directory.
cd "`dirname $0`" || { echo "ERROR: Could not enter the ps2toolchain directory."; exit 1; }

## Set up the environment.
export PS2DEVUJ=/usr/local/ps2devuj
export PS2SDKUJ=$PS2DEVUJ/ps2sdk
export PATH=$PATH:$PS2DEVUJ/bin
export PATH=$PATH:$PS2DEVUJ/ee/bin
export PATH=$PATH:$PS2DEVUJ/iop/bin
export PATH=$PATH:$PS2DEVUJ/dvp/bin
export PATH=$PATH:$PS2SDKUJ/bin

## Run the toolchain script.
./toolchain.sh $@ || { echo "ERROR: Could not run the toolchain script."; exit 1; }
