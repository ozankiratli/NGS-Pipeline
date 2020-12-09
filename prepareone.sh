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

ARCHDIR=`echo $SAMDIR | sed 's|/| |g' | awk '{print $NF}'`
$WD/archivefiles.sh $INPUT $ARCHDIR

$WD/fixmateinfo.sh $NSORTED
OUTPUT=$ID"_fixmate.bam"
FIXED=$FIXEDDIR/$OUTPUT

ARCHDIR=`echo $NSORTEDDIR | sed 's|/| |g' | awk '{print $NF}'`
$WD/archivefiles.sh $NSORTED $ARCHDIR

$WD/coordsort.sh $FIXED
OUTPUT=$ID"_sorted.bam"
SORTED=$SORTEDDIR/$OUTPUT

ARCHDIR=`echo $FIXEDDIR | sed 's|/| |g' | awk '{print $NF}'`
$WD/archivefiles.sh $FIXED $ARCHDIR

$WD/markdup.sh $SORTED
OUTPUT=$ID"_markdup.bam"
MARKDUP=$MARKDUPDIR/$OUTPUT

ARCHDIR=`echo $SORTEDDIR | sed 's|/| |g' | awk '{print $NF}'`
$WD/archivefiles.sh $SORTED $ARCHDIR

$WD/cleansam.sh $MARKDUP
OUTPUT=$ID"_clean.bam"
CLEAN=$CLEANDIR/$OUTPUT

ARCHDIR=`echo $MARKDUPDIR | sed 's|/| |g' | awk '{print $NF}'`
$WD/archivefiles.sh $MARKDUP $ARCHDIR

$WD/rgtags.sh $CLEAN
