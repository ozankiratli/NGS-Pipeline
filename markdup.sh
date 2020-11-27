#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_^*[a-z]\w*.bam/\_markdup.bam/g'`
MARKDUP=$MARKDUPDIR/$OUTPUT

echo "Marking Duplicates: $INPUT ..."
$SAMTOOLS markdup -@ $SAMTOOLSCORES $INPUT $MARKDUP

