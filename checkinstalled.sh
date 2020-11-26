#!/bin/bash

source PROGRAMPATHS
source DIRECTORIES
source PARAMETERS

tmpfile="$WD/checkinstalled.tmp"

rm -f $tmpfile
touch $tmpfile

JAVP=`$JAVA -version 2>&1`
if [ -z "$JAVP" ]
then
	echo "java is not installed or wrong path in PROGRAMPATHS file." >> $tmpfile
else
	echo "java is installed" >> $tmpfile
fi
rm -f 1
wait

PICNP=`$PICARD ViewSam --version 2>&1`
if [ -z "$PICNP" ]
then
	echo "picard-tools is not installed or wrong path in PROGRAMPATHS file." >> $tmpfile
else
	echo "picard-tools is installed" >> $tmpfile
fi
wait

SAMP=`$SAMTOOLS --version`
if [ -z "$SAMP" ]
then
	echo "samtools is not installed or wrong path in PROGRAMPATHS file." >> $tmpfile
else
	echo "samtools is installed" >> $tmpfile
fi
wait

BAMP=`$BAMTOOLS --version`
if [ -z "$BAMP" ]
then
	echo "bamtools is not installed or wrong path in PROGRAMPATHS file." >> $tmpfile
else
	echo "bamtools is installed" >> $tmpfile
fi
wait


BCFP=`$BCFTOOLS -v`
if [ -z "$BCFP" ]
then
	echo "bcfools is not installed or wrong path in PROGRAMPATHS file." >> $tmpfile
else
	echo "bcftools is installed" >> $tmpfile
fi
wait


BWAP=`$BWA 2>&1 | grep "Version"`
if [ -z "$BWAP" ]
then
	echo "bwa is not installed or wrong path in PROGRAMPATHS file." >> $tmpfile
else
	echo "bwa is installed" >> $tmpfile
fi
wait

TGLP=`$TRIMGALORE --version`
if [ -z "$TGLP" ]
then
	echo "trim_galore is not installed or wrong path in PROGRAMPATHS file." >> $tmpfile
else
	echo "trim_galore is installed" >> $tmpfile
fi
wait

FBYP=`$FREEBAYES --version`
if [ -z "$FBYP" ]
then
	echo "freebayes is not installed or wrong path in PROGRAMPATHS file." >> $tmpfile
else
	echo "freebayes is installed" >> $tmpfile
fi
wait

CTAP=`$CUTADAPT --version`
if [ -z "$CTAP" ]
then
	echo "cutadapt is not installed or wrong path in PROGRAMPATHS file." >> $tmpfile
else
	echo "cutadapt is installed" >> $tmpfile
fi
wait

FASTQCPATH=`echo $FASTQC | sed 's_/fastqc__g'`
CHECKFQCPATH=`echo $PATH | grep $FASTQCPATH`
if [ -z "$CHECKFQCPATH" ]
then
	PATH=$PATH:$FASTQCPATH
	export PATH=$PATH
	echo "FastQC path is added to the path"
	echo "New Path is:"
	echo $PATH
fi
wait

FQCP=`fastqc --version`
if [ ! -z "$FQCP" ]
then
	echo "fastqc is installed" >> $tmpfile
else
	echo "fastqc is not installed or wrong path in PROGRAMPATHS file." >> $tmpfile
fi
wait

cat $tmpfile
wait
