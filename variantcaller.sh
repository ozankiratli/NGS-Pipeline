#!/bin/bash

source PARAMETERS
source PROGRAMPATHS
source DIRECTORIES

REF=$1
VCFFILEN=$VCFOUTPUTFILENAME".vcf"

VCFFILE=$VCFDIR/$VCFFILEN

echo "Creating VCF file: $VCFFILE ..."

$FREEBAYES -f $REF $FREEBAYESOPTIONS $READYDIR/*.bam > $VCFFILE
wait
echo "Done!"
echo " "


#bcftools mpileup -B -C50 -q20 -Q20 -d2000 -a "AD,DP,SP,INFO/AD" -Ou -f Reference/dmel_v5-39_all.fasta Output/ready/*.bam | bcftools call -m -A -v -Ov -o Output/VCF/bcftools_pd1210.vcf
