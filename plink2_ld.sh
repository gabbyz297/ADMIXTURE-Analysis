#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -A loni_chiguiro25
#SBATCH -o plink_ld.out
#SBATCH -e plink_ld.err


cd /work/gabby297/batch2/plink_files/

/project/sackettl/software/plink2 --pfile ALL_HAAM_final_q20_no-outliers_miss60 --allow-extra-chr --bad-ld --indep-pairwise 50 10 0.2 --out pruned

/project/sackettl/software/plink2 --pfile ALL_HAAM_final_q20_no-outliers_miss60 --allow-extra-chr --extract pruned.prune.in --make-bed --out ALL_HAAM_final_q20_no-outliers_miss60_LD
