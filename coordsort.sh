#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_^*[a-z]\w*.bam/\_sorted.bam/g'`

BAM=$INPUT
SORTED=$SORTEDDIR/$OUTPUT

echo "Sorting $BAM ..."
$SAMTOOLS sort -@ $SAMTOOLSCORES $BAM -o $SORTED
