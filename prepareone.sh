#!/bin/bash
 
INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

ID=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/.sam//g'`

$WD/namesort.sh $INPUT
OUTPUT=$ID"_nsorted.bam"
NSORTED=$NSORTEDDIR/$OUTPUT

$WD/fixmateinfo.sh $NSORTED
OUTPUT=$ID"_fixmate.bam"
FIXED=$FIXEDDIR/$OUTPUT

$WD/coordsort.sh $FIXED
OUTPUT=$ID"_sorted.bam"
SORTED=$SORTEDDIR/$OUTPUT

$WD/markdup.sh $SORTED
OUTPUT=$ID"_markdup.bam"
MARKDUP=$MARKDUPDIR/$OUTPUT

$WD/rgtags.sh $MARKDUP


