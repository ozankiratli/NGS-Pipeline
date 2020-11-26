#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_^*[a-z]\w*.bam/\_markdup.bam/g'`

BAM=$INPUT
MARKDUP=$MARKDUPDIR/$OUTPUT

echo "Marking Duplicates: $BAM ..."
$SAMTOOLS markdup -@ $SAMTOOLSCORES $BAM $MARKDUP

