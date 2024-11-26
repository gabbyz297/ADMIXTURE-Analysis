#!/bin/bash
#SBATCH -N 1
#SBATCH -n 48
#SBATCH -t 02:00:00
#SBATCH -p workq
#SBATCH -A loni_chiguiro24
#SBATCH -o picard_readgroup_112624.out
#SBATCH -e picard_readgroup_112624.err


module load parallel/20190222/intel-19.0.5


cd /work/gabby297/bam_files/

TMP_DIR=$PWD/tmp

cat sample_list.txt | parallel "java -jar /project/sackettl/software/picard.jar AddOrReplaceReadGroups I={}.bam O={}tag.bam TMP_DIR=$PWD/tmp SO=coordinate RGID={}.bam RGLB=1 RGPL=illumina RGPU=1 RGSM={}.bam"
~                                                           
