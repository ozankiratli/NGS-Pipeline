#!/bin/bash 

INPUT=$1
DIR=$2

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

LAST="${ARCHIVEDIR: -1}"
if [ $LAST != "/" ] ; then
  ARCHIVEDIR=$ARCHIVEDIR"/"
fi

if [ ! -z $DIR ] ; then
  LAST="${DIR: -1}"
  if [ $LAST != "/" ] ; then
    DIR=$DIR"/"
  fi
else
  DIR=""
fi

ARCHIVETO=$ARCHIVEDIR$DIR

case $ARCHIVEFILES in 
	A)
		echo "Moving the folder $INPUT to $ARCHIVEDIR"
		mkdir -p $ARCHIVEDIR
		mkdir -p $ARCHIVETO
		nohup mv $INPUT $ARCHIVETO >/dev/null 2>&1 & disown
		;;
	D)
		echo "Deleting the folder $INPUT"
		rm -r $INPUT
		;;
	K)
		echo "Keeping the folder $INPUT"
		;;
	*)
		echo Wrong parameter set for TEMPFILES in PARAMETERS file. Keeping the folder $INPUT. If you're getting this message and don't want to keep the folder, stop the script here and re-assign the value in your PARAMETERS file.
		;;

esac
