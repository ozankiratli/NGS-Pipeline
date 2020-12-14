#!/bin/bash
 
INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

ID=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/.sam//g'`

$SD/namesort.sh $INPUT
OUTPUT=$ID"_nsorted.bam"
NSORTED=$NSORTEDDIR/$OUTPUT

ARCHDIR=`echo $SAMDIR | sed 's|/| |g' | awk '{print $NF}'`
$SD/archivefiles.sh $INPUT $ARCHDIR

$SD/fixmateinfo.sh $NSORTED
OUTPUT=$ID"_fixmate.bam"
FIXED=$FIXEDDIR/$OUTPUT

ARCHDIR=`echo $NSORTEDDIR | sed 's|/| |g' | awk '{print $NF}'`
$SD/archivefiles.sh $NSORTED $ARCHDIR

$SD/coordsort.sh $FIXED
OUTPUT=$ID"_sorted.bam"
SORTED=$SORTEDDIR/$OUTPUT

ARCHDIR=`echo $FIXEDDIR | sed 's|/| |g' | awk '{print $NF}'`
$SD/archivefiles.sh $FIXED $ARCHDIR

$SD/markdup.sh $SORTED
OUTPUT=$ID"_markdup.bam"
MARKDUP=$MARKDUPDIR/$OUTPUT

ARCHDIR=`echo $SORTEDDIR | sed 's|/| |g' | awk '{print $NF}'`
$SD/archivefiles.sh $SORTED $ARCHDIR

$SD/cleansam.sh $MARKDUP
OUTPUT=$ID"_clean.bam"
CLEAN=$CLEANDIR/$OUTPUT

ARCHDIR=`echo $MARKDUPDIR | sed 's|/| |g' | awk '{print $NF}'`
$SD/archivefiles.sh $MARKDUP $ARCHDIR

$SD/rgtags.sh $CLEAN
OUTPUT=$ID"_rgtag.bam"
RGTAGGED=$RGTAGDIR/$OUTPUT

mkdir -p $READYDIR
OUTPUT=$ID".bam"
READY=$READYDIR/$OUTPUT
cp $RGTAGGED $READY

ARCHDIR=`echo $RGTAGDIR | sed 's|/| |g' | awk '{print $NF}'`
$SD/archivefiles.sh $RGTAGGED $ARCHDIR

$SD/indexbam.sh $READY
