#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -A loni_chiguiro25
#SBATCH -o plink1_plink2.out
#SBATCH -e plink1_plink2.err

cd /work/gabby297/batch2/plink_files/

/project/sackettl/software/plink2 --pedmap /work/gabby297/batch2/plink_files/ALL_HAAM_final_q20_no-outliers_miss20  --allow-extra-chr --out ALL_HAAM_final_q20_no-outliers_miss20
