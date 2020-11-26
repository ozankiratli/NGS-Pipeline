#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_^*[a-z]\w*.bam/\_fixmate.bam/g'`

BAM=$INPUT
FIXED=$FIXEDDIR/$OUTPUT

echo "Sorting $BAM ..."
$SAMTOOLS fixmate -@ $SAMTOOLSCORES -m $BAM $FIXED
