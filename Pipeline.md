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

This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

Set the maximum heap size to 192 gigabytes 

`java -Xmx192g`

Specify where conda is installed  

`source /path/to/miniconda3/etc/profile.d/conda.sh`

Activate conda environment

`conda activate fastqc`

Specify where FastQC is installed

`/path/to/miniconda3/envs/fastqc/bin/fastqc`

Change directory to where files are located

`cd /path/to/files/`

Use `cat` to call the list of samples parallel will use to call files and `parallel --jobs 16` to run 16 jobs in parallel. Use `{}.fastq.gz` to specify the file type at the end of all the files and use `-o` to specify where the output files should be written. 

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


## Install Trimmomatic using Miniconda 🐍
`trimmomatic` removes adaptors and trims reads based on a specified quality scores. 

Create a conda environment to install Trimmomatic into: 
`conda create -n trimmomatic`

Activate the Trimmomatic conda environment: 
`conda activate trimmomatic`

Install Trimmomatic in the Trimmomatic conda environment: 
`conda install -c bioconda trimmomatic`

## Run Trimmomatic ✂️
`trimmomatic` parameters will depend on FastQC results. High quality sequence data may allow for more stringent paramenters whereas average sequence quality may require you to relax some parameters to prevent throwing out the majority of your reads.

`PE` This option runs trimmomatic in paired end mode for forward and reverse reads. This creates 4 output files 2 for the 'paired'
output where both reads survived the processing, and 2 for corresponding 'unpaired' output where a read survived, but the partner 
read did not. `LEADING` and `TRAILING` removes low quality bases at the beginning and the end of a read. `SLIDINGWINDOW` uses a sliding window of a set number of bases and trims once the average quality falls below the set threshold. 


This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

Specify where conda is installed  

`source /path/to/miniconda3/etc/profile.d/conda.sh`

Activate conda environment

`conda activate trimmomatic`

Specify where Trimmomatic is installed

`/path/to/miniconda3/envs/trimmomatic/bin/trimmomatic`

Change directory to where files are located

`cd /path/to/files/`


`cat sample_list.txt | parallel "trimmomatic PE {}1.fq.gz {}2.fq.gz /path/to/{}.1P.fq /path/to/{}.1U.fq /path/to/{}.2P.fq /path/to/{}.2U.fq LEADING:5 TRAILING:5 SLIDINGWINDOW:4:15 MINLEN:60"`

Trimmomatic script without notes can be found [here](trimmomatic_parallel.sh)

## Run FastQC/MultiQC again to make sure trimming was successful 👍
This can also help determine if there are any samples that you'd like to remove or resequence before further analysis. 

## Index Reference Genome to prep for Genome Alignment 📖
If your reference isn't already indexed, you can use code found [here](Pipeline.md)

## Align Reads to Reference Genome with BWA mem 📖
Trimmed reads will now be aligned to our indexed reference genome using BWA mem. To align using BWA mem your reference genome must be indexed using BWA index. Make sure all indexed outputs are in the same directory. 

`-M` Mark shorter split hits as secondary (for Picard compatibility); `-t` Number of threads; `-v` Control the verbose level of the output. This option has not been fully supported throughout BWA. Ideally, a value 0 for disabling all the output to stderr; 1 for outputting errors only; 2 for warnings and errors; 3 for all normal messages; 4 or higher for debugging. When this option takes value 4, the output is not SAM. [3]

This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

Specify where conda is installed  

`source /path/to/miniconda3/etc/profile.d/conda.sh`

Activate conda environment

`conda activate bwa`

Specify where BWA is installed

`/path/to/miniconda3/envs/bwa/bin/bwa`

Change directory to where files are located

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

This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

Specify where conda is installed  

`source /path/to/miniconda3/etc/profile.d/conda.sh`

Activate conda environment

`conda activate samtools`

Specify where SAMtools is installed

`/path/to/miniconda3/envs/samtools/bin/samtools`

Change directory to where files are located

`cd /path/to/files/`

`cat sample_list.txt | parallel "samtools view -q 20 -bt /path/to/reference.fasta {}.sam -o /path/to/bam_files/{}.bam"`

SAMtools view script without notes can be found [here](samtools_view.sh)

##Check Alignment Stats with SAMtools
BWA doesn't output it's own alignment stats so this step will allow us to check how many reads BWA was able to map to our reference.

This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

Specify where conda is installed  

`source /path/to/miniconda3/etc/profile.d/conda.sh`

Activate conda environment

`conda activate samtools`

Specify where SAMtools is installed

`/path/to/miniconda3/envs/samtools/bin/samtools`

Change directory to where files are located

`cd /path/to/files/`

`cat /path/to/sample_list.txt | parallel "samtools flagstat {}.bam -O /path/to/bam_files/{}.bam_stat"`

SAMtools flagstat script without notes can be found [here](samtools_flagstat.sh)

## Assign Reads to Read-Groups with Picard Tools 📑

Picard Tools is compatible with GATK, the program we will be using to genotype, so we will use Picard Tools to assign our reads to read groups, based on sequencing lane.

`I` specifies input files, `O` specifies output files, `TMP_DIR` creates a temporary directory, `SO` is the optional sort order to output in, `RGID` is the read group ID, `RGLB` is the read group library, `RGPL` is the read group platform, `RGPU` is the read group platform unit, and `RGSM` is the read group sample name. 

Download Picard tools jar file.
You can download the jar file to run picard tools [here](https://github.com/broadinstitute/picard/releases/tag/3.3.0)

Change directory to location of BAM files

`cd /path/to/bam_files/`

Create temporary directory for intermediate files

`TMP_DIR=$PWD/tmp`

Use for loop to loop through directory of BAM files and assign reads to read groups.

`for i in /path/to/bam_files/*.bam; do java -jar /path/to/picard.jar AddOrReplaceReadGroups I=$i O=${i%.bam}.tag.bam MAX_RECORDS_IN_RAM=1000000 TMP_DIR=$PWD/tmp SO=coordinate RGID=${i%.bam} RGLB=1 RGPL=illumina RGPU=1 RGSM=${i%.bam}; done`

Picard Tools assign read groups script without notes can be found [here](picard_readgroups.sh)

## Remove PCR Duplicates with Picard tools ✂️


Since Picard tools is compatible with GATK we will use it to remove PCR artifacts as well. 

`MAX_FILE_HANDLES_FOR_READ_ENDS_MAP` Maximum number of file handles to keep open when spilling read ends to disk, `MAX_RECORDS_IN_RAM` When writing files that need to be sorted, this will specify the number of records stored in RAM before spilling to disk, `TMP_DIR` One or more directories with space available to be used by this program for temporary storage of working files, `METRICS_FILE` File to write duplication metrics to, `ASSUME_SORTED` If true, assume that the input file is coordinate sorted even if the header says otherwise.

Change directory to location of BAM files

`cd /path/to/bam_files/`

Set temporary working directory

`TMP_DIR=$PWD/temp`

Use for loop to loop through BAM files and remove PCR duplicates 

`for i in /path/to/bam_files/*.tag.bam;  do java -jar /path/to/picard.jar MarkDuplicates I=$i O=${i%.tag.bam}.rmdup.bam MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=6000 MAX_RECORDS_IN_RAM=1000000 TMP_DIR=$PWD/temp METRICS_FILE=${i%.tag.bam}.rmdup.metrics ASSUME_SORTED=true; done`

Picard Tools assign remove PCR duplicate script without notes can be found [here](picard_rmpcrdup.sh)

## Index filtered files using Samtools :open_book:
Next filtered files will be indexed for realignment with `samtools`

This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

Specify where conda is installed  

`source /path/to/miniconda3/etc/profile.d/conda.sh`

Activate conda environment

`conda activate samtools`

Specify where SAMtools is installed

`/path/to/miniconda3/envs/samtools/bin/samtools`

Change directory to where files are located

`cd /path/to/files/`

`cat sample_list.txt | parallel "samtools index {}.bam -o {}.index.bam"`

SAMtools index script without notes can be found [here](samtools_view.sh)

## Create GVCF files using GATK :file_folder:
Next we will convert filtered BAM files to GVCF files which will create VCF formatted files without genotypes

### Create GATK script to run in parallel
We will write a script calling GATK that we will use later when we run our parallel script. This is the most computationally intense step which requires us to use parallel a little differently than in previous scripts.

`#!/bin/bash`

Create temp directory to save space

`OUTPUT=temp-gvcf`

Specify where you have GATK and Java (required version 17+) installed
`export PATH="/path/to/gatk-4.4.0.0/:$PATH"`
`export PATH="/path/to/jdk-17.0.6/bin:$PATH"`

Specifity flags for GATK scripts

`REFERENCE=$1`
`INPUT=$2`
`FILENAME=$(basename -- "$INPUT")`
`FILENAME_PART="${FILENAME%.*}"`
`OUT1=/path/to/vcf_files/$FILENAME.g.vcf.gz`

Write GATK script in linear format using flags specified above

`gatk --java-options "-Xmx16G -XX:ParallelGCThreads=4" HaplotypeCaller --ERC GVCF -R $REFERENCE -I $INPUT -O $OUT1 --min-base-quality-score 20`

GATK create GVCF file linear script without notes can be found [here](gatk_create_gvcf_linear.sh)

### Create a text file with list of paths to reference genome and each sample's file 🗃️

Run on command line

`REFERENCE=/path/to/reference.fasta`

`for BAM in /path/to/*.bam; do echo "$REFERENCE,$BAM" >> bams-to-haplotype-call.txt; done`

### Create parallel script to run GATK HaplotypeCaller 📁
We will use GATK HaplotypeCaller to create a GVCF file for each BAM file

Run 4 jobs at a time
`export JOBS_PER_NODE=4`

This script will be run in parallel

`module load parallel/20190222/intel-19.0.5`

Change directory to where files are located 🗃

`cd /path/to/files/`

`parallel --colsep '\,' \
        --progress \
        --joblog logfile.haplotype_gvcf.$SLURM_JOBID \
        -j $JOBS_PER_NODE \
        --workdir $SLURM_SUBMIT_DIR \
        -a bams-to-haplotype-call.txt \
        /path/to/gatk_create_gvcf.sh {$1}`

GATK create GVCF file parallel without notes can be found [here](gatk_create_gvcf_parallel.sh)

## Combine GVCF files for Genotyping 📦
Now that we have our GVCF files we can combine them into a multi-sample GVCF file to group samples by population (or however else you'd like) and genotype them together. 

This script will run linear

Change directory to location of GVCF files
`cd /path/to/files/`

List samples to be combined in your GVCF file using the `-V` flag

`gatk CombineGVCFs -R /path/to/reference.fa -V sample_1.g.vcf.gz -V sample_2.g.vcf.gz -O all_samples.g.vcf`

GATK combine GVCF script without notes can be found [here](gatk_combine_gvcf_linear.sh)

## Genotype GVCF Files 🧬
It's finally time to genotype! We will create our multi-sample VCF file with GATK.

This script will run linear

Change directory to location of combined GVCF file
`cd /path/to/files/`

`gatk CombineGVCFs -R /path/to/reference.fa -V all_samples.g.vcf -O all_samples.vcf`

GATK genotype GVCF script without notes can be found [here](gatk_genotype_gvcf_linear.sh)

## Select SNPs with GATK 🫵
GATK allows you to select for specific variants using `SelectVariants` to select SNPs MNPs or INDELS.

Change directory to location of genotyped combined VCF file
`cd /path/to/files/`

Select SNPs usung the `select-type-to-include` flag. Use `exclude-non-variants` to exclude non-polymorphic sites. `set-filtered-gt-to-nocall` converts filtered sites to ./. or no calls. 
`/path/to/gatk-4.1.2.0/gatk SelectVariants --variant /path/to/file/combined.vcf -R /path/to/reference/.fa --output /path/to/file/file2.vcf --select-type-to-include SNP --exclude-non-variants true --set-filtered-gt-to-nocall true`

GATK select SNP script without notes can be found [here](gatk_select_variants.sh)

## Flag variants with GATK
GATK allows for several different highly customizable filters for quality controlling your genotyped VCF file, from removing sites with low coverage to removing sequencing artifacts. 

`ReadPosRankSum` compares whether positions of reference and alternate alleles are different within reads, `MQRankSum` compares mapping qualities of reads supporting the reference allele and alternate allele, `FS` Phred-scaled probability that there is strand bias at the site. `FS` value will be close to 0 when there is little to no strand bias at the site, `QD` is the variant confidence divided by the unfiltered depth of samples. This normalizes the variant quality in order to avoid inflation caused when there is deep coverage, `DP` is genotype depth of coverage

Change directory to location of VCF file
`cd /path/to/files/`

Call your VCF file and you reference genome

`/path/to/gatk-4.1.2.0/gatk VariantFiltration --variant /path/to/file/file.vcf --output /path/to/file/file.vcf -R /path/to/reference/.fa`

Create filters and their threshold cutoffs

`--filter-name "ReadPosRankSum_filter" \ --filter-expression "ReadPosRankSum < -8.0" \ --filter-name "MQRankSum_filter" \ --filter-expression "MQRankSum < -12.5" \ --filter-name "FS_filter" \ --filter-expression "FS > 60.0" \ --filter-name "QD_filter" \ --filter-expression "QD < 2.0" \ --genotype-filter-name "DP8filter" \ --genotype-filter-expression "DP < 8" 2>/dev/null`

GATK filter script without notes can be found [here](gatk_filter.sh)

## Removed flagged variants with GATK 🗑️
`SelectVariants` will remove all the variants that were flagged by `VariantFiltration`

Load Java
`module load jdk/1.8.0_262/intel-19.0.5`

Change directory to location of VCF file
`cd /path/to/files/`

`/path/to/gatk-4.1.2.0/gatk SelectVariants -R /path/to/reference/.fa --variant /path/to/file/file.vcf --output /path/to/file/file.vcf --set-filtered-gt-to-nocall true`

GATK filtered variants script without notes can be found [here](gatk_filtered_variants.sh)

## Determine the frequecy of missing data with VCFtools 🎯

Set the PERL5LIB environment variable to run VCFtools’ Perl scripts.
`export PERL5LIB=/path/to/vcftools/src/perl` 


`/path/to/vcftools/bin/vcftools --vcf /path/to/file/file.vcf --missing-indv --out /path/to/file/file`

This script will output the frequency of missing data for each sample in the VCF file `F_MISS` in a `.imiss` file. This output file can be used to create a histogram to visualize the frequency of missing data and aid in deciding a missingness threshold for filtering.

VCFtools missing data script without notes can be found [here](vcf_missing_data.sh)

## Visualize frequency of missing data in R

Load in `.imiss` file
`miss <- read.table("file.imiss", header = TRUE)`

Plot histogram
`hist(miss$F_MISS, breaks = 50, xlab = "Proportion of Missing Data", 
     main = "Per-individual missing data")`

Histogram script without notes can be found [here](imiss_histogram.r)

## Remove individuals based on missingness threshold 🗑️

Now that we have the frequency of missing day per individiual, a missingness threshold can be determined. The script below can be run on the command line to create a file listing samples that do not meet your missingness threshold.

Set threshold (e.g., 60% missing = 0.6)
`THRESHOLD=0.6`

Extract sample names with missingness > $THRESHOLD
`awk -v thresh=$THRESHOLD 'NR > 1 && $5 > thresh {print $1}' file.imiss > remove_above_${THRESHOLD}.txt`

This file can now be input into VCFtools script to remove individuals with missing data frequency above your set threshold

Change directory to location of files
`cd /path/to/files/`

Set the PERL5LIB environment variable to run VCFtools’ Perl scripts
`export PERL5LIB=/project/sackettl/software/vcftools/src/perl`

`/path/to/vcftools/bin/vcftools --vcf file.vcf --remove "remove_above_0.6.txt" --recode --recode-INFO-all --out file_filtered`

VCFtools remove individuals script without notes can be found [here](vcf_rm_indvs.sh)

## Convert final VCF file to PLINK 1.9 files with VCFtools

PLINK will be used to run a PCA and ADMIXTURE accepts PLINK input files

To convert to PLINK file format, a chromosome mapping files is necessary. The mapping file can be made based on the chromosomes listed in your VCF file using the command line script below

`grep -v '^#' file.vcf | cut -f1 | uniq | awk '{print $0"\t"$0}' > chrom-map.txt`

Now we're ready to create PLINK files 

Change directory to loaction of files
`cd /path/to/files/`

Set the PERL5LIB environment variable to run VCFtools’ Perl scripts
`export PERL5LIB=/project/sackettl/software/vcftools/src/perl`

`/path/to/vcftools/bin/vcftools --vcf file.vcf  --chrom-map chrom-map.txt --out file --plink`

VCF to PLINK 1.9 script without notes can be found [here](vcf2plink1.9.sh)

## Convert PLINK 1.9 to PLINK 2.0

We will be running our PCA in PLINK 2.0 but VCFtools currently only converts VCF files to PLINK 1.9 so we need this extra step to get to PLINK 2.0

Change directory to loaction of files
`cd /path/to/files/`

Do not include the file extension in the input or output 
`/path/to/plink2 --pedmap filename  --allow-extra-chr --out filename`

PLINK 1.9 to PLINK 2.0 script without notes can be found [here](plink1.9_plink2.0.sh)

## Calcuate allele frequencies (for sample sizes <50)

This creates a table with allele frequencies output as a `.afreq` file, to account for differences in minor allele frequencies. PLINK 2.0 will require this file for small datasets

Change directory to loaction of files
`cd /path/to/files/`

`/path/to/plink2 --pfile filename --allow-extra-chr --freq --out filename`

PLINK 2.0 read frequency script without notes can be found [here]()

## Run PCA in PLINK 2.0

Now we can use the `.afreq` file in our PCA script

Change directory to loaction of files
`cd /path/to/files/`
### 🚧 This Pipeline is still in Progress 🏗️
