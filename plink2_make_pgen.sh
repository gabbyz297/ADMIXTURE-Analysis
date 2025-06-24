#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -A loni_chiguiro25
#SBATCH -o plink_pgen.out
#SBATCH -e plink_pgen.err


cd /work/gabby297/batch2/plink_files/

/project/sackettl/software/plink2 --bfile /work/gabby297/batch2/plink_files/ALL_HAAM_final_q20_no-outliers_miss60_LD  --allow-extra-chr --make-pgen --out ALL_HAAM_final_q20_no-outliers_miss60_LD
