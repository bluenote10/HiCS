#!/bin/bash

clear

while true; do
  ./build_debug.sh

  change=$(inotifywait -r -e close_write,moved_to,create,modify . \
    --exclude 'src/main$|nimchange|#.*' \
    2> /dev/null) 

  # very short sleep to avoid "text file busy"
  sleep 0.01

  clear
  echo "changed: $change `date +%T`"
  echo "changed: $change" >> .changes
done
