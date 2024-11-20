#!/bin/bash
#SBATCH -N 1
#SBATCH -n 48
#SBATCH -t 01:00:00
#SBATCH -p workq
#SBATCH -A loni_chiguiro24
#SBATCH -o samtools_flagstat_112024.out
#SBATCH -e samtools_flagstat_112024.err


module load parallel/20190222/intel-19.0.5


source /home/gabby297/miniconda3/etc/profile.d/conda.sh

conda activate samtools

/home/gabby297/miniconda3/envs/samtools/bin/samtools

cd /work/gabby297/bam_files/

cat /work/gabby297/bwa/sample_list.txt | parallel "samtools flagstat {}.bam -O /work/gabby297/bam_files/{}.bam_stat"
