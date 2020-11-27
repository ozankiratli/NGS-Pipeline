#!/bin/bash 

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

case $ARCHIVEFILES in 
	A)
		echo "Moving the folder $INPUT to $ARCHIVEDIR"
		mkdir -p $ARCHIVEDIR
		nohup mv $INPUT $ARCHIVEDIR >/dev/null 2>&1 & disown
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
