# DESCRIPTION
These set of scripts is designed to align multiple samples of same species to a reference genome, then building consensus sequences and call variants. 

# USAGE
## Download
```
git clone https://github.com/evolozzy/DNA-Alignment-Pipeline.git
```
## Before using
- Make a subdirectory named `Data` in the folder containing your scripts and copy your files there, or change the line containing `DATASOURCE` in your `PARAMETERS` file, and set it to the folder that contains your data. 
- If you have two or more sets of reads to merge keep them in separate directories in `Data` directory.
- Make sure you have your reference file.

## Using
### Setting the parameters
- Carefully change the `PARAMETERS`.
  - Set the `REFERENCEFILE` to the path to reference.
  - If you have two or more sets to merge, set `MERGE` to `1`, otherwise set it to `0`.
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
