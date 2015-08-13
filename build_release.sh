#!/bin/bash

nim c -o:../bin/HiCS --parallelBuild:1 -d:release src/main.nim

./cross_compile.sh

