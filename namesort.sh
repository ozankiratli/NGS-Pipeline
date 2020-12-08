#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

mkdir -p $NSORTEDDIR

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/.sam/\_nsorted.bam/g'`
NSORTED=$NSORTEDDIR/$OUTPUT

echo "Sorting by name: $INPUT ..."
$SAMTOOLS sort -@ $SAMTOOLSCORES -O bam -n $INPUT -o $NSORTED
echo "Done! Sorting by name: $INPUT"
