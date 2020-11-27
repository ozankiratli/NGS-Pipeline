#!/bin/bash

echo "Starting script..."
echo " "
source PROGRAMPATHS
source DIRECTORIES

echo "Calculating the number of cores needed for different programs..."
$WD/calculatecores.sh
echo " "
echo "CORES will be used as:"
cat CORES
echo " "
echo " "

source CORES
source PARAMETERS


echo "Checking REFERENCE file..."
RefCheck=`ls $REFERENCEFILE`
if [ -z "$RefCheck" ] ; then
	echo "Reference file not found! Check PARAMETERS file"
	exit 1
else
	echo "Reference file is: $REFERENCEFILE"
fi
echo " "
wait

echo "Checking DATA files..."
if [ -d $DATASOURCE  ] ; then
	DATAIN=$DATASOURCE
	echo "The data source is set to: $DATAIN"
else
	echo "Data directory does not exist! Check PARAMETERS file"
	exit 1
fi
wait

if [[ $DATAIN -ef Data ]] ; then
	echo "No need to copy. Data is already in: $DATADIR"
else
	mkdir -p $DATADIR
	echo "Copying the files to $DATADIR..."
	cp -r $DATASOURCE/* $DATADIR/
	echo "Files are copied!"
fi
echo " "
wait

if [ -d $ARCHIVEDIR ] ; then 
  	CHECKARCHIVE=`ls $ARCHIVEDIR`
	if [ -z $CHECKARCHIVE ] ; then
	  	echo "Archive directory $ARCHIVEDIR exists, and it's empty."
	else
	  	echo "Archive directory $ARCHIVEDIR exists, but it's not empty. Please empty the directory or change the variable in PARAMETERS file."
		exit 1
	fi
else
  	echo "Archive directory $ARCHIVEDIR doesn't exist! Creating the directory!"
	mkdir -p $ARCHIVEDIR
fi


echo "Checking whether the required programs installed..."
source $WD/checkinstalled.sh
echo " "
CHECKPT1=`grep "not" $WD/checkinstalled.tmp`
if [ ! -z "$CHECKPT1" ]
then
	echo "Please install the missing programs or correct their paths in PROGRAMPATHS file"
	rm -f $WD/checkinstalled.tmp
	exit 1
else
	rm -f $WD/checkinstalled.tmp
fi
wait
echo " "

echo "Building Reference..."
mkdir -p $OUTPUTDIR
mkdir -p $REFERENCEDIR
mkdir -p $REPORTSDIR
cp $REFERENCEFILE $REFERENCEDIR/
REF=`echo $REFERENCEFILE | sed 's/\// /g' | awk '{print $NF}'`
echo $REF
REFERENCE=$REFERENCEDIR/$REF
echo $REFERENCE
export _JAVA_OPTIONS=$JAVAOPTIONS
$WD/buildref.sh $REFERENCE > $REPORTSDIR/buildreference_report.txt
wait
echo "Reference building is completed!"
echo " "

echo "Starting trimming..."
mkdir -p $REPORTFASTQCDIR
mkdir -p $REPORTTRIMDIR
mkdir -p $UNPAIREDDIR
mkdir -p $TRIMMEDDIR
wait

INPUT=$DATADIR"/*_R1_*.fastq.gz"
$PARALLEL --progress -j $TRIMJOBS $WD/trimone.sh {} {=s/_R1_/_R2_/=} ::: $INPUT
wait

mv *.zip $REPORTFASTQCDIR
mv *.html $REPORTFASTQCDIR
mv *.txt $REPORTTRIMDIR
mv *_unpaired_* $UNPAIREDDIR
mv *val* $TRIMMEDDIR
wait

echo "Trimming process is done!"
echo " "
echo " "
TEMPDIR=$UNPAIREDDIR
$WD/archivefiles.sh $TEMPDIR
wait 
echo " "

LIST=`ls $TRIMMEDDIR`
for file in $LIST ; do
	newfile=`echo $file | sed 's/_val_[0-9]//' `
	echo "$file $newfile"
	mv $TRIMMEDDIR/$file $TRIMMEDDIR/$newfile 2>/dev/null
done
INPUT=$TRIMMEDDIR"/*_R1_*.fq.gz"
wait

TEMPDIR=$TRIMMEDDIR
echo "Starting aligning..."
mkdir -p $SAMDIR
$PARALLEL --progress -j $BWAJOBS $WD/alignone.sh $REFERENCE {} {=s/_R1_/_R2_/=} ::: $INPUT
wait
echo "Aligning process is done!"
INPUT=$SAMDIR"/*.sam"
echo " "
echo " "
$WD/archivefiles.sh $TEMPDIR 
wait

TEMPDIR=$SAMDIR

echo "Converting files from SAM to BAM..."
mkdir -p $BAMDIR
$PARALLEL --progress -j $SAMTOOLSJOBS $WD/samtobam.sh {} ::: $INPUT
wait
echo "Done!"
INPUT=$BAMDIR"/*.bam"
echo " " 
echo " "
$WD/archivefiles.sh $TEMPDIR 
wait

TEMPDIR=$BAMDIR

echo "Sorting by name..."
mkdir -p $NSORTEDDIR
$PARALLEL --progress -j $SAMTOOLSJOBS $WD/namesort.sh {} ::: $INPUT
wait 
echo "Done!"
INPUT=$NSORTEDDIR"/*.bam"
echo " "
echo " "
$WD/archivefiles.sh $TEMPDIR
wait

TEMPDIR=$NSORTEDDIR

echo "Fixing Mate info..."
mkdir -p $FIXEDDIR
$PARALLEL --progress -j $SAMTOOLSJOBS $WD/fixmateinfo.sh {} ::: $INPUT
wait
echo "Done!"
INPUT=$FIXEDDIR"/*.bam"
echo " "
echo " "
$WD/archivefiles.sh $TEMPDIR
wait

TEMPDIR=$FIXEDDIR

echo "Sorting BAM files by coordinate..."
mkdir -p $SORTEDDIR
$PARALLEL --progress -j $SAMTOOLSJOBS $WD/coordsort.sh {} ::: $INPUT
wait
echo "Done!"
INPUT=$SORTEDDIR"/*.bam"
echo " "
echo " "
echo "Indexing BAM files..."
$PARALLEL --progress -j $SAMTOOLSJOBS $WD/indexbam.sh {} ::: $INPUT
wait
echo "Done!"
echo " "
echo " "
$WD/archivefiles.sh $TEMPDIR
wait

TEMPDIR=$SORTEDDIR

echo "Marking Duplicates..."
mkdir -p $MARKDUPDIR
$PARALLEL --progress -j $SAMTOOLSJOBS $WD/markdup.sh {} ::: $INPUT
wait
echo "Done!"
INPUT=$MARKDUPDIR"/*.bam"
echo " "
echo " "
echo "Indexing BAM files..."
$PARALLEL --progress -j $SAMTOOLSJOBS $WD/indexbam.sh {} ::: $INPUT
wait
echo "Done!"
echo " "
echo " "
$WD/archivefiles.sh $TEMPDIR
wait

TEMPDIR=$MARKDUPDIR

echo "RG Tagging..."
mkdir -p $RGTAGDIR
$PARALLEL --progress -j $JOBBINS $WD/rgtags.sh {} ::: $INPUT
wait
echo "Done!"
INPUT=$RGTAGDIR"/*.bam"
echo " "
echo " "
echo "Indexing BAM files..."
$PARALLEL --progress -j $SAMTOOLSJOBS $WD/indexbam.sh {} ::: $INPUT
wait
echo "Done!"
echo " "
echo " "
$WD/archivefiles.sh $TEMPDIR
wait

TEMPDIR=$RGTAGDIR

echo "Cleaning BAM files..."
mkdir -p $CLEANDIR
$PARALLEL --progress -j $JOBBINS $WD/cleansam.sh {} ::: $INPUT
wait
echo "Done!"
INPUT=$CLEANDIR"/*.bam"
echo " "
echo " "
echo "Indexing BAM files..."
$PARALLEL --progress -j $SAMTOOLSJOBS $WD/indexbam.sh {} ::: $INPUT
wait
echo "Done!"
echo " "
echo " "
$WD/archivefiles.sh $TEMPDIR
wait

TEMPDIR=$CLEANDIR


#BSQR goes here!
#
#
#

mkdir -p $READYDIR
mkdir -p $VCFDIR
mkdir -p $REPORTALIGNDIR
mkdir -p $REPORTCOVERDIR

cp $TEMPDIR/* $READYDIR/ &
echo "Done!"
wait
echo " "
echo " " 
echo "Renaming!"

INPUT=$READYDIR"/*"
for file in $INPUT ; do
	newfile=`echo $file | sed 's/\_^*[a-z]\w*.bam/_ready.bam/g' `
	echo "Renaming $file to $newfile"
	mv $file $newfile
done


INPUT=$READYDIR"/*.bam"

echo "Generating alignment reports!"
$PARALLEL --progress -j $SAMTOOLSJOBS $WD/reportalign.sh {} ::: $INPUT
$PARALLEL --progress -j $SAMTOOLSJOBS $WD/reportcoverage.sh {} ::: $INPUT
echo "Done generating reports"


echo "Starting variant calling..."
nohup $WD/archivefiles.sh $TEMPDIR </dev/null >/dev/null 2>&1 &
wait
echo " "
$WD/variantcaller.sh $REFERENCE
wait
echo "Done!"
echo " "
mkdir -p $RESULTSDIR
echo "Copying results to $RESULTSDIR ..."
$WD/copyresults.sh
wait
echo "Done!"
echo " "
echo "End of script!"
