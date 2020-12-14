#!/bin/bash

source PARAMETERS
source PROGRAMPATHS
source DIRECTORIES

REFERENCE=$1
REF=`echo $1 | sed 's/\./ /g'  | awk '{print $1}' | sed 's/\// /g' | awk '{print $NF}'`
REFDICT=$REFERENCEDIR/$REF.dict

echo "Creating BWA index..."
CT=`( ls $REFERENCEDIR/*.bwt 2>/dev/null && ls $REFERENCEDIR/*.ann 2>/dev/null && ls $REFERENCEDIR/*.amb 2>/dev/null && ls $REFERENCEDIR/*.pac 2>/dev/null && ls $REFERENCEDIR/*.sa 2>/dev/null ) | wc -l`
if [ $CT -eq 5 ] ; then
	echo "Index files exist! No need to create the index again!"
else
	$BWA index -a bwtsw $REFERENCE
fi
wait
echo "Done!"
echo " "
echo "Creating samtools fai index..."
CT=`( ls $REFERENCEDIR/*.fai 2>/dev/null ) | wc -l`
if [ $CT -eq 1 ] ; then
	echo "Index file exists! No need to create the index again!"
else
	$SAMTOOLS faidx $REFERENCE
fi
wait
echo "Done!"
echo " "
echo "Creating picard reference dictionary..."
CT=`( ls $REFERENCEDIR/*.dict 2>/dev/null ) | wc -l`
if [ $CT -eq 1 ] ; then
	echo "Index file exists! No need to create the index again!"
else
	$PICARD CreateSequenceDictionary R=$REFERENCE O=$REFDICT
fi
wait
echo "Done!"
