#!/bin/bash

OUTPUT=temp-gvcf


#where you have GATK and Java (required version 17+) installed
export PATH="/project/sackettl/software/gatk-4.4.0.0/:$PATH"
export PATH="/project/sackettl/software/jdk-17.0.6/bin:$PATH"

REFERENCE=$1
INPUT=$2
FILENAME=$(basename -- "$INPUT")
FILENAME_PART="${FILENAME%.*}"
OUT1=/work/gabby297/vcf_files/$FILENAME.g.vcf.gz


gatk --java-options "-Xmx16G -XX:ParallelGCThreads=4" HaplotypeCaller --ERC GVCF -R $REFERENCE -I $INPUT -O $OUT1 --min-base-quality-score 20
