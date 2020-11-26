#!/bin/bash

source PARAMETERS
source PROGRAMPATHS
source DIRECTORIES

INPUT=$1
ID=`echo $INPUT | sed 's/\.bam//g' | sed 's/\// /g' | awk '{print $NF}' `
CLEAN=$CLEANDIR/$ID"_clean.bam"
echo "Cleaning bam file: $ID"
$PICARD CleanSam I=$INPUT O=$CLEAN
echo "$ID Done!" 
