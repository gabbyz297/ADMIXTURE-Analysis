#!/bin/bash
#SBATCH -p single
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 10:00:00
#SBATCH -A loni_chiguiro25
#SBATCH -o admixture_crossval.out
#SBATCH -e admixture_crossval.err


# Load GNU parallel
module load parallel/20190222/intel-19.0.5

# Activate conda environment
source /home/gabby297/miniconda3/etc/profile.d/conda.sh
conda activate admixture

cd /work/gabby297/batch2/admixture/

echo -e "K\tCV_Error" > cv_summary.txt

run_admixture() {
    K=$1
    echo "Running K=$K" >&2
    admixture --cv=10 -j2 /work/gabby297/batch2/plink_files/ALL_HAAM_final_q20_no-outliers_miss60_LD.bed ${K} > log_K${K}.out 2>&1

    # Extract last field (CV error value)
    CV_ERR=$(grep "CV error" log_K${K}.out | awk '{print $NF}')

    if [[ -z "$CV_ERR" ]]; then
        echo -e "${K}\tFAILED" > cv_K${K}.txt
    else
        echo -e "${K}\t${CV_ERR}" > cv_K${K}.txt
    fi
}

export -f run_admixture

# Run 4 jobs in parallel using 2 threads each
parallel -j 4 run_admixture ::: {2..12}

# Merge CV results
