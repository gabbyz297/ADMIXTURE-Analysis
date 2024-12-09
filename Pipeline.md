## Create a list of file names for running scripts in parallel 📚
We will use a list of file names without the file extensions for running our scripts in parallel. For example: a file named `sample1.fastq` would be `sample1` in our text file. 

## Install Miniconda  🐍
Miniconda is a free installer that includes conda and python. You can chose from thousands of packages in Anaconda's public repository to install and miniconda will install all of it's dependancies automatically. We will use miniconda to download the packages we need to clean up our raw sequence data.

_This code was taken from [Anaconda](https://docs.anaconda.com/miniconda/)_

Make a directory to install miniconda into: 
`mkdir -p ~/miniconda3`

Download the miniconda bash script:  
`wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh`

Run the bash script to install miniconda: 
`bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3`

Delete the miniconda bash script: 
`rm ~/miniconda3/miniconda.sh`

## Install FastQC using Miniconda 🐍
Now we can use Miniconda to install our first package, FastQC.

Create a conda environment to install FastQC into: 
`conda create -n fastqc`

Activate the FastQC conda environment: 
`conda activate fastqc`

Install FastQC in the FastQC conda environment: 
`conda install -c bioconda fastqc`

## Run FastQC 🏃‍♀️
FastQC is a tool that analyzes raw sequence data from high throughput sequencing to identify potential issues. We will use the output to determine if any samples need to be removed from our analysis and will help us determine our trimming parameters later. FastQC can be run on zipped fasta files so if your files are zipped, you don't have to unzip them. 

#This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

#Set the maximum heap size to 192 gigabytes 

`java -Xmx192g`

#Specify where conda is installed  

`source /path/to/miniconda3/etc/profile.d/conda.sh`

#Activate conda environment

`conda activate fastqc`

#Specify where FastQC is installed

`/path/to/miniconda3/envs/fastqc/bin/fastqc`

#Change directory to where files are located

`cd /path/to/files/`

#Use `cat` to call the list of samples parallel will use to call files and `parallel --jobs 16` to run 16 jobs in parallel. Use `{}.fastq.gz` to specify the file type at the end of all the files and use `-o` to specify where the output files should be written. 

`cat sample_list.txt | parallel --jobs 16 "fastqc {}.fastq.gz -o /work/gabby297/delaware_pool1/fastqc/"`

FastQC script without notes can be found [here](https://github.com/gabbyz297/Structure-Pipeline/blob/main/fastqc.sh)

## Install MultiQC using Miniconda 🐍
MultiQC is a tool that compiles FastQC results into a single `html` file to view results for multiple files more easily. 

Create a conda environment to install MultiQC into: 
`conda create -n multiqc`

Activate the MultiQC conda environment: 
`conda activate multiqc`

MultiQC recommends not installing with `-c bioconda` anymore because it pulls an old version of MultiQC that may cause issues later. Instead, run: `conda config --add channels bioconda` before installing multiqc

Install MultiQC in the MultiQC conda environment: 
`conda install multiqc`

## Run MultiQC 🏃‍♀️
To compile `html` outputs into one `html` file, run MultiQC in the directory that the files are located. This will create a file called `multiqc_report.html` 

`cd /path/to/fastqc/`

`conda activate multiqc`

`multiqc .`


## Install Trim Galore using Miniconda 🐍
`trim_galore` removes adaptors and trims reads based on a specified quality score. 

Create a conda environment to install Trim Galore into: 
`conda create -n trim_galore`

Activate the Trim Galore conda environment: 
`conda activate trim_galore`

Install Trim Galore in the Trim Galore conda environment: 
`conda install -c bioconda trim_galore`

## Run Trim Galore ✂️
`trim_galore` parameters will depend on FastQC results. High quality sequence data may allow for more stringent paramenters whereas average sequence quality may require you to relax some parameters to prevent throwing out the majority of your reads.

`--paired` This option performs length trimming of quality/adapter/RRBS trimmed reads for paired-end files. To pass the validation test, both sequences of a sequence pair are required to have a certain minimum length which is governed by the option `--length` (default 20bp). If only one read passes this length threshold the other read can be rescued; `-q` Trim low-quality ends from reads in addition to adapter removal. For RRBS samples, quality trimming will be performed first, and adapter trimming is carried in a second round. Other files are quality and adapter trimmed in a single pass. The algorithm is the same as the one used by BWA (Subtract INT from all qualities; compute partial sums from all indices to the end of the sequence; cut sequence at the index at which the sum is minimal). 


#This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

#Specify where conda is installed  

`source /path/to/miniconda3/etc/profile.d/conda.sh`

#Activate conda environment

`conda activate trim_galore`

#Specify where Trim Galore is installed

`/path/to/miniconda3/envs/trim_galore/bin/trim_galore`

#Change directory to where files are located

`cd /path/to/files/`


`cat sample_list.txt | parallel "trim_galore --paired -q 20  --dont_gzip  {}_R1_001.fastq.gz {}_R2_001.fastq.gz -o /path/to/trim_galore/"`

Trim Galore script without notes can be found [here](trim_galore.sh)

## Run FastQC/MultiQC again to make sure trimming was successful 👍
This can also help determine if there are any samples that you'd like to remove or resequence before further analysis. 

## Index Reference Genome to prep for Genome Alignment 📖
If your reference isn't already indexed, you can use code found [here](Pipeline.md)

## Align Reads to Reference Genome with BWA mem 📖
Trimmed reads will now be aligned to our indexed reference genome using BWA mem. To align using BWA mem your reference genome must be indexed using BWA index. Make sure all indexed outputs are in the same directory. 

`-M` Mark shorter split hits as secondary (for Picard compatibility); `-t` Number of threads; `-v` Control the verbose level of the output. This option has not been fully supported throughout BWA. Ideally, a value 0 for disabling all the output to stderr; 1 for outputting errors only; 2 for warnings and errors; 3 for all normal messages; 4 or higher for debugging. When this option takes value 4, the output is not SAM. [3]

#This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

#Specify where conda is installed  

`source /path/to/miniconda3/etc/profile.d/conda.sh`

#Activate conda environment

`conda activate bwa`

#Specify where BWA is installed

`/path/to/miniconda3/envs/bwa/bin/bwa`

#Change directory to where files are located

`cd /path/to/files/`

`cat sample_list.txt | parallel "bwa mem -M -t 10 -v 3 /path/to/reference.fasta {}val_1.fq {}val_2.fq > /path/to/bwa/{}.sam 2> /path/to/bwa/{}.mem.log"`
                                                               
BWA script without notes can be found [here](bwa.sh)

## Install SAMtools using Miniconda 🐍

Create a conda environment to install SAMtools into: 
`conda create -n samtools`

Activate the SAMtools conda environment: 
`conda activate samtools`

Install Trim Galore in the SAMtools conda environment: 
`conda install -c bioconda samtools`

## Convert SAM to BAM files with SAMtools 🔃
Next we will convert our SAM files to BAM files for downstream analyses using SAMtools. 

`-q` Skip alignments with MAPQ smaller than; `-bt` If @SQ lines are absent in the header

#This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

#Specify where conda is installed  

`source /path/to/miniconda3/etc/profile.d/conda.sh`

#Activate conda environment

`conda activate samtools`

#Specify where SAMtools is installed

`/path/to/miniconda3/envs/samtools/bin/samtools`

#Change directory to where files are located

`cd /path/to/files/`

`cat sample_list.txt | parallel "samtools view -q 20 -bt /path/to/reference.fasta {}.sam -o /path/to/bam_files/{}.bam"`

SAMtools view script without notes can be found [here](samtools_view.sh)

##Check Alignment Stats with SAMtools
BWA doesn't output it's own alignment stats so this step will allow us to check how many reads BWA was able to map to our reference.

#This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

#Specify where conda is installed  

`source /path/to/miniconda3/etc/profile.d/conda.sh`

#Activate conda environment

`conda activate samtools`

#Specify where SAMtools is installed

`/path/to/miniconda3/envs/samtools/bin/samtools`

#Change directory to where files are located

`cd /path/to/files/`

`cat /path/to/sample_list.txt | parallel "samtools flagstat {}.bam -O /path/to/bam_files/{}.bam_stat"`

SAMtools flagstat script without notes can be found [here](samtools_flagstat.sh)

## Assign Reads to Read-Groups with Picard Tools 📑

Picard Tools is compatible with GATK, the program we will be using to genotype, so we will use Picard Tools to assign our reads to read groups, based on sequencing lane.

`I` specifies input files, `O` specifies output files, `TMP_DIR` creates a temporary directory, `SO` is the optional sort order to output in, `RGID` is the read group ID, `RGLB` is the read group library, `RGPL` is the read group platform, `RGPU` is the read group platform unit, and `RGSM` is the read group sample name. 

#Download Picard tools jar file.
You can download the jar file to run picard tools [here](https://github.com/broadinstitute/picard/releases/tag/3.3.0)

#This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

#Change directory to where files are located

`cd /path/to/files/`

#Create a temporary directory for intermediate files

`TMP_DIR=$PWD/tmp`

`cat sample_list.txt | parallel "java -jar /path/to/picard.jar AddOrReplaceReadGroups I={}.bam O={}tag.bam TMP_DIR=$PWD/tmp SO=coordinate RGID={}.bam RGLB=1 RGPL=illumina RGPU=1 RGSM={}.bam"`

Picard Tools assign read groups script without notes can be found [here]()



### 🚧 This Pipeline is still in Progress 🏗️
