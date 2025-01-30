#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 47
#SBATCH -t 168:00:00
#SBATCH -A loni_chiguiro24
#SBATCH -o gatk_create_gvcf_121124.out
#SBATCH -e gatk_create_gvcf_121124.err

export JOBS_PER_NODE=4

module load parallel/20190222/intel-19.0.5

cd /work/gabby297/bam_files/rmdup/

parallel --colsep '\,' \
        --progress \
        --joblog logfile.haplotype_gvcf.$SLURM_JOBID \
        -j $JOBS_PER_NODE \
        --workdir $SLURM_SUBMIT_DIR \
        -a bams-to-haplotype-call8.txt \
        /work/gabby297/scripts/gatk_create_gvcf.sh {$1}
~                                                       
