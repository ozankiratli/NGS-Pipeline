#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

REPORTDIR=$REPORTALIGNDIR

ID=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\.bam/ /g' | awk '{print $1}'`
OUTPUT=$ID"_alignment_report.txt"
BAM=$INPUT
REPORT=$REPORTALIGNDIR/$OUTPUT

echo "--------------------------------------------------------" > $REPORT
echo "Alignment Report For: $ID" >> $REPORT
echo "--------------------------------------------------------" >> $REPORT
$BAMTOOLS stats -in $BAM >> $REPORT
wait
echo " " >> $REPORT
echo " " >> $REPORT
echo " " >> $REPORT
