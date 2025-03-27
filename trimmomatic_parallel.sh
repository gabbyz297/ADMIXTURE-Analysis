#!/bin/bash
#SBATCH -N 1
#SBATCH -n 48
#SBATCH -t 04:00:00
#SBATCH -p workq
#SBATCH -A loni_chiguiro25
#SBATCH -o trim_0323_HAAM_111124.out
#SBATCH -e trim_0323_111124.err


module load parallel/20190222/intel-19.0.5


source /home/gabby297/miniconda3/etc/profile.d/conda.sh

conda activate trimmomatic

/home/gabby297/miniconda3/envs/trimmomatic/bin/trimmomatic

cd /work/gabby297/batch2/

cat sample_list.txt | parallel "trimmomatic PE {}1.fq.gz {}2.fq.gz /work/gabby297/batch2/trimmomatic/{}.1P.fq /work/gabby297/batch2/trimmomatic/{}.1U.fq /work/gabby297/batch2/trimmomatic/{}.2P.fq /work/gabby297/batch2/trimmomatic/{}.2U.fq LEADING:5 TRAILING:5 SLIDINGWINDOW:4:15 MINLEN:60"
