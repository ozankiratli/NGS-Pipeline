#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

ID=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\.bam/ /g' | awk '{print $1}'`
OUTPUT=$ID"_coverage_report.txt"
BAM=$INPUT
REPORT=$REPORTCOVERDIR/$OUTPUT

echo "--------------------------------------------------------" > $REPORT
echo "Coverage report for $ID" >> $REPORT
echo "--------------------------------------------------------" >> $REPORT
echo " " 
$SAMTOOLS coverage $BAM >> $REPORT
wait
