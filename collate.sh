#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

mkdir -p $NSORTEDDIR

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/.sam/\_nsorted.bam/g'`
NSORTED=$NSORTEDDIR/$OUTPUT

echo "Sorting $INPUT by name..."
$SAMTOOLS collate -@ $SAMTOOLSCORES -u $INPUT -o $NSORTED

