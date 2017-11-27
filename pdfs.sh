#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for d in "workshop"; do
  echo "Converting $d to pdf..."
  cd $DIR/$d
  ./build.sh
  cat "README.md" | grep -v "\-\-\-" | pandoc -o $DIR/$d.pdf
  cd $DIR
  echo "Done"
done
