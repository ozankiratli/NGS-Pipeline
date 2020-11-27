#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/.bam/\_nsorted.bam/g'`
NSORTED=$NSORTEDDIR/$OUTPUT

echo "Sorting $INPUT by name..."
$SAMTOOLS sort -@ $SAMTOOLSCORES -n $INPUT -o $NSORTED

