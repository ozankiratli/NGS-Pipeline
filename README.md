# DESCRIPTION
These set of scripts is designed to align multiple samples of same species to a reference genome, do preprocessing, and then call variants. 
The scripts use the following software for given purposes in the given order. 
1) `trimgalore` to trim adapters, clip the ends of the reads and generating fastqc reports
2) `bwa mem` for aligning 
3) `samtools sort -n` for sorting by name 
4) `samtools fixmate` for fixing mate information 
5) `samtools sort` for sorting by coordinates
6) `samtools markdup` for marking duplicates
7) `picard-tools AddOrReplaceReadGroups` for addding and replacing RGtags
8) `picard-tools CleanSam` for setting Mapping Quality 0 for the sequences that are not aligned.
9) `samtools index` for indexing 
10) `samtools coverage` for coverage reports
11) `bamtools stats` for alignment reports
12) `freebayes` for variant calling 
 
# USAGE
## Download
```
git clone https://github.com/evolozzy/NGS-Pipeline.git
```
## Before using
- Make a subdirectory named `Data` in the folder containing your scripts and copy your files there, or change the line containing `DATASOURCE` in your `PARAMETERS` file, and set it to the folder that contains your data. 
- If you have two or more sets of reads to merge keep them in separate directories in `Data` directory.
- Make sure you have your reference file.
- Edit `RGTAGS` file carefully, the files belonging the same sample should have the same SM (sample name).

## Using
### Setting the parameters
- Carefully change the `PARAMETERS`.
  - Set the `REFERENCEFILE` to the path to reference.
  - If you are running on multiple threads set `THREADS` to number of cores you want to use.
- Set the directories to be used in `DIRECTORIES` file.
  - If you're not running the scripts in the directory you have the scripts change the line containing `WD` to the path that contains your scripts.
- Install required software, and set `PROGRAMPATHS`.


### Running 
Inside the folder:
```
./runall.sh 
```
Or outside the folder:
```
/path/to/scripts/runall.sh
```
If you encounter any errors during the process and clean all the files created by the script:
```
./resetanalysis.sh
```

### Best Practices
- Before running `runall.sh`, use `trimall.sh` to quality control the trimming process. Checkout the fastqc reports after trimming and set `PARAMETERS` accordingly. 
- Make sure that the core numbers are set properly. Try to use parallel more, but it depends on the number of files. For low numbers of files

### How does this set of scripts work?
0) The script checks 
	- if the files are in place
	- if the software is installed
	- calculates a good way to use the cores available
	- builds references from reference file
1) Trimming is done with `trimgalore`.
2) Aligning is done with `bwa`
3) Preprocessing is done with `samtools` and `picard-tools`.
	1) First, the files are sorted by name and mate info is fixed.
	2) Second, the files are sorted by coordinate and duplicates are marked.
	3) Third, the files are cleaned from reads that were not aligned.
	4) Last, RG tags are added. 
4) Variants are called with `bcftools`.

- The middle files can be kept, deleted, or archived to another location.
- The code also generates reports of trimming (fastqc reports), alignment, and coverage.


