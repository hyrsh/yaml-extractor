#!/bin/bash

#default failsafe
if [ "$1" == "" ]; then
  echo -e "\e[31;1mNo file given!\e[0;0m"
  echo "Usage: yaml-extractor.sh <FILE>"
  exit 1
fi

#extraction dir
extdir=./extracted
mkdir $extdir

#array for indexing
declare -a partsarray

#yaml separator "---" declared blocks as line number (e.g. 1 24 35 45 99)
parts=$(grep -n "\-\-\-" $1 | sed "s/:.*//g")

#arrays start at 0 :)
index=$(( 0 + 0 ))

#last recorded index
last=$(( 0 + 0 ))

#last line number of file
lines=$(wc -l $1 | awk '{print $1}')

#loop over "parts" list and map indices to values
for PART in $parts; do
  #index = line number of beginning "---" block
  partsarray[$index]=$PART
  #increase index manually
  index=$(( index + 1 ))
  #safe and overwrite last safed index (our total array length is "last - 1")
  last=$(( index + 0 ))
done

#current position for next loop
pos=$(( 0 + 0 ))

#loop over arbitrary list (here $parts) with same length of "partsarray"
for BLOCK in $parts; do
  #current position starting at 0
  cur=$pos
  #start of next block
  nxt=$(( pos + 1 ))
  #line number starting block
  lst=${partsarray[$cur]}
  #check if the current position is at array length
  if [ $pos -eq $(( last - 1 )) ]; then
    #line number ending block if it is the last block
    lnd=$lines
  else
    #line number ending block if not last block
    lnd=$(( partsarray[nxt] - 1 ))
  fi

  #get block and pipe to tmp.yml file
  sed -n "${lst},${lnd}p" $1 > $extdir/tmp.yml
  #get kind of API object
  kind=$(grep "kind:" $extdir/tmp.yml | head -1 | awk '{print $2}')
  #get name of API object
  name=$(grep "name:" $extdir/tmp.yml | head -1 | awk '{print $2}')
  #move temporary file to a more detailed name
  mv $extdir/tmp.yml $extdir/${kind}-${name}.yml
  #inform user of file
  echo "Created file $extdir/${kind}-${name}.yml"
  #increment current position counter
  pos=$(( pos + 1 ))
done
