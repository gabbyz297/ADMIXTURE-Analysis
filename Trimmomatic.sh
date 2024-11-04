#!/bin/bash
#SBATCH -N 1
#SBATCH -n 48
#SBATCH -t 04:00:00
#SBATCH -p workq
#SBATCH -A loni_chiguiro24
#SBATCH -o trim_pool2_HAAM_103024.out
#SBATCH -e trim_pool2_103024.err


module load parallel/20190222/intel-19.0.5


source /home/gabby297/miniconda3/etc/profile.d/conda.sh

conda activate trimmomatic

/home/gabby297/miniconda3/envs/trimmomatic/bin/trimmomatic

cd /work/gabby297/delaware_pool2/

cat sample_list.txt | parallel "trimmomatic PE {}_R1_001.fastq.gz {}_R2_001.fastq.gz /work/gabby297/trimmomatic/{}.1U.fq.gz /work/gabby297/trimmomatic/{}.1P.fq.gz /work/gabby297/trimmomatic/{}.2U.fq.gz /work/gabby297/trimmomatic/{}.2P.fq.gz ILLUMINACLIP:/project/sackettl/software/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:5:20 MINLEN:50"
