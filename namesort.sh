#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_^*[a-z]\w*.bam/\_nsorted.bam/g'`

BAM=$INPUT
NSORTED=$NSORTEDDIR/$OUTPUT

echo "Sorting $BAM ..."
$SAMTOOLS sort -@ $SAMTOOLSCORES -n $BAM -o $NSORTED

