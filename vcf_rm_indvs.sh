#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 05:00:00
#SBATCH -A loni_chiguiro25
#SBATCH -o vcf_rm_indv.out
#SBATCH -e vcf_rm_indv.err

cd /work/gabby297/batch2/vcf_files/
export PERL5LIB=/project/sackettl/software/vcftools/src/perl

/project/sackettl/software/vcftools/bin/vcftools --vcf ALL_HAAM_final_SNP_filtered_q20_rm-outliers.recode.vcf --remove "remove_above_0.2.txt" --recode --recode-INFO-all --out /work/gabby297/batch2/vcf_files/ALL_HAAM_final_SNP_filtered_q20_rm-outliers_miss20
