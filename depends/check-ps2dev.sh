#!/bin/sh
# check-ps2dev.sh by uyjulisn
# Based on check-pspdev.sh by Dan Peori (danpeori@oopo.net)

## Check if $PS2DEVUJ is set.
if test ! $PS2DEVUJ; then { echo "ERROR: Set \$PS2DEVUJ before continuing."; exit 1; } fi

## Check if $PS2SDKUJ is set.
if test ! $PS2SDKUJ; then { echo "ERROR: Set \$PS2SDKUJ before continuing."; exit 1; } fi

## Check for the $PS2DEVUJ directory.
ls -ld $PS2DEVUJ 1> /dev/null || mkdir -p $PS2DEVUJ 1> /dev/null || { echo "ERROR: Create $PS2DEVUJ before continuing."; exit 1; }

## Check for the $PS2SDKUJ directory.
ls -ld $PS2SDKUJ 1> /dev/null || mkdir -p $PS2SDKUJ 1> /dev/null || { echo "ERROR: Create $PS2SDKUJ before continuing."; exit 1; }

## Check for $PS2DEVUJ write permission.
touch $PS2DEVUJ/test.tmp 1> /dev/null || { echo "ERROR: Grant write permissions for $PS2DEVUJ before continuing."; exit 1; }

## Check for $PS2SDKUJ write permission.
touch $PS2SDKUJ/test.tmp 1> /dev/null || { echo "ERROR: Grant write permissions for $PS2SDKUJ before continuing."; exit 1; }

## Check for $PS2DEVUJ/bin in the path.
echo $PATH | grep $PS2DEVUJ/bin 1> /dev/null || { echo "ERROR: Add $PS2DEVUJ/bin to your path before continuing."; exit 1; }

## Check for $PS2DEVUJ/ee/bin in the path.
echo $PATH | grep $PS2DEVUJ/ee/bin 1> /dev/null || { echo "ERROR: Add $PS2DEVUJ/ee/bin to your path before continuing."; exit 1; }

## Check for $PS2DEVUJ/iop/bin in the path.
echo $PATH | grep $PS2DEVUJ/iop/bin 1> /dev/null || { echo "ERROR: Add $PS2DEVUJ/iop/bin to your path before continuing."; exit 1; }

## Check for $PS2DEVUJ/dvp/bin in the path.
echo $PATH | grep $PS2DEVUJ/dvp/bin 1> /dev/null || { echo "ERROR: Add $PS2DEVUJ/dvp/bin to your path before continuing."; exit 1; }

## Check for $PS2SDKUJ/bin in the path.
echo $PATH | grep $PS2SDKUJ/bin 1> /dev/null || { echo "ERROR: Add $PS2SDKUJ/bin to your path before continuing."; exit 1; }
