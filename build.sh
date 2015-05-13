#!/bin/bash

#file=slicing.nim
#file=backgroundjob.nim
file=src/main.nim

fileAbs=`readlink -m $file`
traceback=false

#nim c -r -o:bin/test $file

#nim c -r -o:bin/test --parallelBuild:1 --threads:on $file

nim c -o:../bin/main --parallelBuild:1 -d:testing $file

#nim c -o:../bin/main --parallelBuild:1 -d:testing -d:release $file

compiler_exit=$?

echo "Compiler exit: $compiler_exit"

if [ "$compiler_exit" -eq 0 ]; then  # compile success
  ./bin/main
  exit $?
else  # compile fail
  exit $compiler_exit
fi

if [ "$traceback" = true ] ; then
  echo -e "\nRunning ./koch temp c $fileAbs"
  cd ~/bin/nim-repo
  ./koch temp c `readlink -m $fileAbs`
fi

