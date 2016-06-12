#!/bin/sh

script=$PWD/convert.sh
entries=( text/* )
((i=1))

for file in "${entries[@]}"; do
  # Get participant's name
  name="`echo $file | sed -e 's/.transcript//' | sed -e 's=text/=='`"

  # Execute conversion script
  $script "P$i" "$name"

  ((i+=1))
done
