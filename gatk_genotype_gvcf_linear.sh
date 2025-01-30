#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 24:00:00
#SBATCH -A loni_chiguiro24
#SBATCH -o gatk_genotype_gvcf.out
#SBATCH -e gatk_genotype_gvcf.err

module load gatk/4.5.0.0

cd /work/gabby297/vcf_files/

gatk GenotypeGVCFs -R /project/sackettl/HAAM-from-OAAM-ref-genome/haam.consensus.called.from.oaam.alignment.V2.fasta -V HAAM_PORC.g.vcf -O HAAM_PORC.vcf
