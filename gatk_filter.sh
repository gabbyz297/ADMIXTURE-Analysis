#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 12:00:00
#SBATCH -A loni_chiguiro25
#SBATCH -o gatk_filter.out
#SBATCH -e gatk_filter.err

cd /work/gabby297/batch2/vcf_files/

module load gatk/4.5.0.0

gatk VariantFiltration --variant ALL_HAAM_final_SNP.vcf --output ALL_HAAM_final_SNP_filter.vcf   -R /project/sackettl/HAAM-from-OAAM-ref-genome/haam.consensus.called.from.oaam.alignment.V2.fasta --filter-name "ReadPosRankSum_filter" --filter-expression "ReadPosRankSum < -8.0" --filter-name "MQRankSum_filter" --filter-expression "MQRankSum < -12.5" --filter-name "FS_filter" --filter-expression "FS > 60.0" --filter-name "QD_filter" --filter-expression "QD < 2.0" --genotype-filter-name "DP8filter" --genotype-filter-expression "DP < 8" 2>/dev/null
