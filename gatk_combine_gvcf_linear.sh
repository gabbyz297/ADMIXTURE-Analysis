#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 160:00:00
#SBATCH -A loni_chiguiro24
#SBATCH -o gatk_combine_gvcf_PFBS.out
#SBATCH -e gatk_combine_gvcf_PFBS.err

module load gatk/4.5.0.0

cd /work/gabby297/vcf_files/

gatk CombineGVCFs -R /project/sackettl/HAAM-from-OAAM-ref-genome/haam.consensus.called.from.oaam.alignment.V2.fasta \
 -V GASR123_HAAM_Hawaii_PFBS_2591-08447_S158_.rmdup.bam.g.vcf.gz \
 -V GASR124_HAAM_Hawaii_PFBS_2591-08444_S233_.rmdup.bam.g.vcf.gz \
 -V GASR126_HAAM_Hawaii_PFBS_2591-0845S2200.rmdup.bam.g.vcf.gz \
 -V GASR127_HAAM_Hawaii_PFBS_2591-0845S227_.rmdup.bam.g.vcf.gz \
 -V GASR129_HAAM_Hawaii_PFBS_2591-08443_S200_.rmdup.bam.g.vcf.gz \
 -V GASR12HAAM_Hawaii_PFBS_2591-08445_S157_.rmdup.bam.g.vcf.gz \
 -V GASR137_HAAM_Hawaii_PFBS_2591-08485_S230_.rmdup.bam.g.vcf.gz \
 -V GASR13HAAM_Hawaii_PFBS_2591-08489_S215_.rmdup.bam.g.vcf.gz \
 -V GASR148_HAAM_Hawaii_PFBS_2591-08433_S213_.rmdup.bam.g.vcf.gz \
 -V GASR154_HAAM_Hawaii_PFBS_2591-08439_S238_.rmdup.bam.g.vcf.gz \
 -V GASR157_HAAM_Hawaii_PFBS_2591-08494_S1300.rmdup.bam.g.vcf.gz \
 -V GASR163_HAAM_Hawaii_PFBS_1881-73505_S176_.rmdup.bam.g.vcf.gz \
 -V GASR164_HAAM_Hawaii_PFBS_1881-7350S164_.rmdup.bam.g.vcf.gz \
 -V GASR165_HAAM_Hawaii_PFBS_1881-73503_S00.rmdup.bam.g.vcf.gz \
 -V GASR167_HAAM_Hawaii_PFBS_1881-73518_S17.rmdup.bam.g.vcf.gz \
 -V GASR168_HAAM_Hawaii_PFBS_1881-7353S83_00.rmdup.bam.g.vcf.gz \
 -V GASR175_HAAM_Hawaii_PFBS_1881-73584_S.rmdup.bam.g.vcf.gz \
 -V GASR183_HAAM_Hawaii_PFBS_1881-73575_S178_.rmdup.bam.g.vcf.gz \
 -V GASR184_HAAM_Hawaii_PFBS_1881-73574_S169_.rmdup.bam.g.vcf.gz \
 -V GASR185_HAAM_Hawaii_PFBS_1881-73563_S174_.rmdup.bam.g.vcf.gz \
 -V GASR186_HAAM_Hawaii_PFBS_1881-73564_S167_.rmdup.bam.g.vcf.gz \
 -V GASR188_HAAM_Hawaii_PFBS_1881-73549_S177_.rmdup.bam.g.vcf.gz \
 -V GASR189_HAAM_Hawaii_PFBS_1881-7357S166_00.rmdup.bam.g.vcf.gz \
 -V GASR193_HAAM_Hawaii_PFBS_1881-73544_S179_.rmdup.bam.g.vcf.gz \
 -V GASR194_HAAM_Hawaii_PFBS_1881-73558_S1800.rmdup.bam.g.vcf.gz \
 -V GASR195_HAAM_Hawaii_PFBS_1881-73543_S4_.rmdup.bam.g.vcf.gz \
 -O HAAM_PFBS.g.vcf \
