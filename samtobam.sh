#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\.sam/.bam/g'`

SAM=$INPUT
BAM=$BAMDIR/$OUTPUT

echo "Converting $SAM to $BAM ..."
$SAMTOOLS view -@ $SAMTOOLSCORES -bS $SAM -o $BAM
wait
