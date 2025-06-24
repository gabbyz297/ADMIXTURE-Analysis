#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -A loni_chiguiro25
#SBATCH -o plink_pca.out
#SBATCH -e plink_pca.err


cd /work/gabby297/batch2/plink_files/

/project/sackettl/software/plink2 --pfile ALL_HAAM_final_q20_no-outliers_miss20 --allow-extra-chr --read-freq ALL_HAAM_final_q20_no-outliers_miss20.afreq --pca 4  --out ALL_HAAM_final_q20_no-outliers_miss20
~                                                  
