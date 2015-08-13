#!/bin/bash

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

echo -e "\n *** compiling 64 bit version"
nim c -d:release \
    --cpu:amd64 --os:windows \
    --parallelBuild:1 --verbosity:3 \
    -o:../bin/HiCS_x64.exe src/main.nim

#
# I didn't test 32-bit cross compilation but basically it should work by:
# - installing mingw32 (probably not needed, see below)
# - using `--cpu:i386` in the above compilation
# - checking the exact name of the mingw32-gcc binary (probably just i686-w64-mingw32-gcc, see below)
# - adding this name to i386.windows.gcc.* in the nim.cfg
#
#
# Some resources on cross compilation:
# - http://forum.nim-lang.org/t/1132#6973
# - http://forum.nim-lang.org/t/1251#7712
# - http://forum.nim-lang.org/t/251#1278
# - http://stackoverflow.com/questions/19690504/how-do-i-compile-and-link-a-32-bit-windows-executable-using-mingw-w64
#
# Interestingly mingw-w64 does not only create the binaries "x86_64-w64-..." but also "i686-w64-...".
# Explanation from this answer:
#
#   "Don't be put off by the rather confusing executable names:
#    i686-w64-mingw32-gcc is the 32-bit compiler and
#    x86_64-w64-mingw32-gcc is the 64-bit one."
#
#
#

echo -e "\n *** compiling 32 bit version"
nim c -d:release \
    --cpu:i386 --os:windows \
    --parallelBuild:1 --verbosity:3 \
    -o:../bin/HiCS_x86.exe src/main.nim




