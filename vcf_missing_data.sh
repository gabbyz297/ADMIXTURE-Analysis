#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -A loni_chiguiro25
#SBATCH -o vcf_miss.out
#SBATCH -e vcf_miss.err


cd /work/gabby297/batch2/vcf_files/
export PERL5LIB=/project/sackettl/software/vcftools/src/perl

/project/sackettl/software/vcftools/bin/vcftools --vcf ALL_HAAM_final_SNP_filtered_q20_rm-outliers.recode.vcf --missing-indv --out ALL_HAAM_final_SNP_filtered_q20_rm-outliers
