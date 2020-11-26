#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_^*[a-z]\w*.bam/\_rgtag.bam/g'`
ID=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_^*[a-z]\w*.bam//g'`

SM=`grep $ID $RGTAGFILE | sed 's/\,/ /g' | awk '{print $2}'`
LB=`grep $ID $RGTAGFILE | sed 's/\,/ /g' | awk '{print $3}'`
PL=`grep $ID $RGTAGFILE | sed 's/\,/ /g' | awk '{print $4}'`
PU=`grep $ID $RGTAGFILE | sed 's/\,/ /g' | awk '{print $5}'`

BAM=$INPUT
RGTAGGED=$RGTAGDIR/$OUTPUT

echo "Tagging $BAM ..."
$PICARD AddOrReplaceReadGroups I=$INPUT O=$RGTAGGED RGID=$ID RGSM=$SM RGLB=$LB RGPL=$PL RGPU=$PU $ADDGROUPOPTIONS
echo "$ID Done!"
