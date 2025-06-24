#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -A loni_chiguiro25
#SBATCH -o vcf_plink.out
#SBATCH -e vcf_plink.err


cd /work/gabby297/batch2/vcf_files/
export PERL5LIB=/project/sackettl/software/vcftools/src/perl

/project/sackettl/software/vcftools/bin/vcftools --vcf ALL_HAAM_final_SNP_filtered_q20_rm-outliers_miss60.recode.vcf  --chrom-map chrom-map.txt --out /work/gabby297/batch2/plink_files/ALL_HAAM_final_q20_no-outliers_miss60 --plink
