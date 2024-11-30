#!/bin/bash
#!/bin/bash
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 48:00:00
#SBATCH -p single
#SBATCH -A loni_chiguiro24
#SBATCH -o picard_readgroup_112624.out
#SBATCH -e picard_readgroup_112624.err

cd /work/gabby297/bam_files/

TMP_DIR=$PWD/tmp

for i in /work/gabby297/bam_files/GA*.bam; do java -jar /project/sackettl/software/picard.jar AddOrReplaceReadGroups I=$i O=${i%.bam}.tag.bam MAX_RECORDS_IN_RAM=1000000 TMP_DIR=$PWD/tmp SO=coordinate RGID=${i%.bam} RGLB=1 RGPL=illumina RGPU=1 RGSM=${i%.bam}; done                                
