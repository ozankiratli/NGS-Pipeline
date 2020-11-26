#!/bin/bash

REFERENCE=$1
INPUT1=$2
INPUT2=$3

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

OUTPUT=`echo $INPUT1 | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_R[0-9]_/ /g' | awk '{print $1}'`
SAM=$SAMDIR/$OUTPUT.sam

echo "Aligning $INPUT1 and $INPUT2 ..."
$BWA mem $BWAOPTIONS $REFERENCE $INPUT1 $INPUT2 > $SAM
wait
