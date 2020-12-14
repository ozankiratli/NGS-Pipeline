#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

mkdir -p $MARKDUPDIR

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_^*[a-z]\w*.bam/\_markdup.bam/g'`
REPOUT=`echo $OUTPUT | sed 's/.bam/.txt/'`

MARKDUP=$MARKDUPDIR/$OUTPUT
REPORT=$MARKDUPDIR/$REPOUT

echo "Marking Duplicates: $INPUT ..."
$SAMTOOLS markdup -@ $SAMTOOLSCORES -s -f $REPORT $INPUT $MARKDUP
echo "Done! Marking Duplicates: $INPUT"
