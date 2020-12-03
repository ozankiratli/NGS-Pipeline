#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

mkdir -p $FIXEDDIR

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_^*[a-z]\w*.bam/\_fixmate.bam/g'`
FIXED=$FIXEDDIR/$OUTPUT

echo "Fixing Mate Info for $INPUT ..."
$SAMTOOLS fixmate -@ $SAMTOOLSCORES -O bam -rm $INPUT $FIXED
