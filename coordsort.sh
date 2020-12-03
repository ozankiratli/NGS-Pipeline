#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

mkdir -p $SORTEDDIR

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_^*[a-z]\w*.bam/\_sorted.bam/g'`
SORTED=$SORTEDDIR/$OUTPUT

echo "Sorting $INPUT by coordinate..."
$SAMTOOLS sort -@ $SAMTOOLSCORES -O bam $INPUT -o $SORTED
