#!/bin/bash
#
# Steps to set-up 64-bit cross compilation (for Windows under Linux):
# - install mingw-w64 (this will provide all kinds of executable named x86_64-w64-mingw32-*)
# - add a nim.cfg with the following content:
#
#     amd64.windows.gcc.path = "/usr/bin"
#     amd64.windows.gcc.exe = "x86_64-w64-mingw32-gcc"
#     amd64.windows.gcc.linkerexe = "x86_64-w64-mingw32-gcc"
#
#   note 1: Apparently the linkerexe has to be "x86_64-w64-mingw32-gcc"
#           and not "x86_64-w64-mingw32-ld"
#   note 2: The nim.cfg does not have to be specified explicitly in the compilation command.
#           The nim compiler searches for a file called "nim.cfg" (according to the rules
#           mentioned here: http://nim-lang.org/docs/nimc.html#compiler-usage-configuration-files)
#           and uses it automatically.
# - use "--cpu: amd64 --os:windows" in the compilation command below.
# 

nim c -d:release \
    --cpu:amd64 --os:windows \
    --parallelBuild:1 --verbosity:3 \
    -o:../bin/HiCS.exe src/main.nim

#
# I didn't test 32-bit cross compilation but basically it should work by:
# - installing mingw32
# - using `--cpu:i386` in the above compilation
# - checking the exact name of the mingw32-gcc binary 
# - adding this name to i386.windows.gcc.* in the nim.cfg
# 


