#!/bin/bash
#SBATCH -N 1
#SBATCH -n 48
#SBATCH -t 24:00:00
#SBATCH -p workq
#SBATCH -A loni_chiguiro24
#SBATCH -o bwa_111924.out
#SBATCH -e bwa_111924.err


module load parallel/20190222/intel-19.0.5


source /home/gabby297/miniconda3/etc/profile.d/conda.sh

conda activate bwa

/home/gabby297/miniconda3/envs/bwa/bin/bwa

cd /work/gabby297/trim_galore/

cat sample_list.txt | parallel "bwa mem -M -t 10 -v 3 /project/sackettl/HAAM-from-OAAM-ref-genome/haam.consensus.called.from.oaam.alignment.V2.fasta {}val_1.fq {}val_2.fq > /work/gabby297/bwa/{}.sam 2> /work/gabby297/bwa/{}.mem.log"
