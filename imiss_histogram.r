miss <- read.table("ALL_HAAM_final_SNP_filtered_q20_rm-outliers.imiss", header = TRUE)
hist(miss$F_MISS, breaks = 50, xlab = "Proportion of Missing Data", 
     main = "Per-individual missing data")
