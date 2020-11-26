#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

echo "Indexing $INPUT ..."
$SAMTOOLS index -@ $SAMTOOLSCORES $INPUT


