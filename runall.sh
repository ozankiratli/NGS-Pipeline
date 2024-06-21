#!/bin/bash

echo "Starting script..."
echo " "
source PROGRAMPATHS
source DIRECTORIES

echo "Calculating the number of cores needed for different programs..."
$SD/calculatecores.sh
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
source $SD/checkinstalled.sh
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
$SD/buildref.sh $REFERENCE > $REPORTSDIR/buildreference_report.txt
wait
echo "Reference building is completed!"
echo " "

echo "Starting trimming..."
mkdir -p $REPORTFASTQCDIR
mkdir -p $REPORTTRIMDIR
mkdir -p $UNPAIREDDIR
mkdir -p $TRIMMEDDIR
wait

INPUT=$DATADIR"/*"$READ1EXTENSION
READ1=`echo $READ1EXTENSION | sed 's/\./ /g' | awk '{print $1}' `
READ2=`echo $READ2EXTENSION | sed 's/\./ /g' | awk '{print $1}' `

$PARALLEL --progress -j $TRIMJOBS $SD/trimone.sh {} {=s/$READ1/$READ2/=} ::: $INPUT
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
$SD/archivefiles.sh $TEMPDIR
wait 
echo " "

LIST=`ls $TRIMMEDDIR`
for file in $LIST ; do
	newfile=`echo $file | sed 's/_val_[0-9]//' `
	echo "$file $newfile"
	mv $TRIMMEDDIR/$file $TRIMMEDDIR/$newfile 2>/dev/null
done
INPUT=$TRIMMEDDIR"/*"$READ1".fq.gz"
wait

TEMPDIR=$TRIMMEDDIR
echo "Starting aligning..."
mkdir -p $SAMDIR
$PARALLEL --progress -j $BWAJOBS $SD/alignone.sh $REFERENCE {} {=s/$READ1/$READ2/=} ::: $INPUT
wait
echo "Aligning process is done!"
INPUT=$SAMDIR"/*.sam"
echo " "
echo " "
$SD/archivefiles.sh $TEMPDIR 
wait

TEMPDIR=$SAMDIR
echo "Starting Preprocessing..."
$PARALLEL --progress -j $JOBBINS $SD/prepareone.sh {} ::: $INPUT
wait
echo "Done Preprocessing!"

mkdir -p $VCFDIR
mkdir -p $REPORTALIGNDIR
mkdir -p $REPORTCOVERDIR

INPUT=$READYDIR"/*.bam"

echo "Generating alignment reports!"
$PARALLEL --progress -j $SAMTOOLSJOBS $SD/reportalign.sh {} ::: $INPUT
$PARALLEL --progress -j $SAMTOOLSJOBS $SD/reportcoverage.sh {} ::: $INPUT
echo "Done generating reports"


echo "Starting variant calling..."
nohup $SD/archivefiles.sh $TEMPDIR </dev/null >/dev/null 2>&1 &
wait
echo " "
$SD/variantcaller.sh $REFERENCE
wait
echo "Done!"
echo " "
mkdir -p $RESULTSDIR
echo "Copying results to $RESULTSDIR ..."
$SD/copyresults.sh
wait
echo "Done!"
echo " "
echo "End of script!"
