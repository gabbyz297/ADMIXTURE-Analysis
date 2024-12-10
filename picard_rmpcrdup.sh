#!/bin/bash
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 148:00:00
#SBATCH -p single
#SBATCH -A loni_chiguiro24
#SBATCH -o picard_rmpcrdup_113024.out
#SBATCH -e picard_rmpcrdup_113024.err

cd /work/gabby297/bam_files/


TMP_DIR=$PWD/temp

for i in /work/gabby297/bam_files/*.tag.bam;  do java -jar /project/sackettl/software/picard.jar MarkDuplicates I=$i O=${i%.tag.bam}.rmdup.bam MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=6000 MAX_RECORDS_IN_RAM=1000000 TMP_DIR=$PWD/temp METRICS_FILE=${i%.tag.bam}.rmdup.metrics ASSUME_SORTED=true; done
