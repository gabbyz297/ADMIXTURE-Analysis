#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 12:00:00
#SBATCH -A loni_chiguiro25
#SBATCH -o gatk_remove_filter.out
#SBATCH -e gatk_remove_filter.err


module load gatk/4.5.0.0

cd /work/gabby297/batch2/vcf_files/

gatk SelectVariants --variant ALL_HAAM_final_SNP_filter.vcf -R /project/sackettl/HAAM-from-OAAM-ref-genome/haam.consensus.called.from.oaam.alignment.V2.fasta  -O ALL_HAAM_final_SNP_filtered.vcf  --exclude-non-variants false --set-filtered-gt-to-nocall true
