#!/bin/bash

#file=src/slicing.nim
#file=src/heap.nim
#file=src/topk.nim
#file=src/option.nim
#file=src/test.nim
file=src/main.nim

fileAbs=`readlink -m $file`
traceback=false

nim c -o:../bin/main --parallelBuild:1 -d:testing $file

compiler_exit=$?

echo "Compiler exit: $compiler_exit"

if [ "$compiler_exit" -eq 0 ]; then  # compile success
  ./bin/main
  exit $?
fi

if [ "$traceback" = true ] ; then
  echo -e "\nRunning ./koch temp c $fileAbs"
  cd ~/bin/nim-repo
  ./koch temp c `readlink -m $fileAbs`
fi

