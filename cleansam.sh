#!/bin/bash

source PARAMETERS
source PROGRAMPATHS
source DIRECTORIES

INPUT=$1
OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_^*[a-z]\w*.bam/\_clean.bam/g'`
CLEAN=$CLEANDIR/$OUTPUT
echo "Cleaning bam file: $INPUT"
$PICARD CleanSam I=$INPUT O=$CLEAN

