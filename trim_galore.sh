#!/bin/bash
#SBATCH -N 1
#SBATCH -n 48
#SBATCH -t 01:00:00
#SBATCH -p workq
#SBATCH -A loni_chiguiro24
#SBATCH -o trim_0323_HAAM_111124.out
#SBATCH -e trim_0323_111124.err


module load parallel/20190222/intel-19.0.5


source /home/gabby297/miniconda3/etc/profile.d/conda.sh

conda activate trim_galore

/home/gabby297/miniconda3/envs/trim_galore/bin/trim_galore

cd /work/gabby297/delaware_pool1/

cat sample_list.txt | parallel "trim_galore --paired -q 20  --dont_gzip  {}_R1_001.fastq.gz {}_R2_001.fastq.gz -o /work/gabby297/trim_galore/"
