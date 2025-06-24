
pca <- read.table("ALL_HAAM_final_q20_no-outliers_miss60_LD.eigenvec",header=F)

pca2 <- read.table("ALL_HAAM_final_q20_no-outliers_miss60.eigenvec",header=F)

eigenval = scan("ALL_HAAM_final_q20_no-outliers_miss60_LD.eigenval")

pve <- data.frame(PC = 1:4, pve = eigenval/sum(eigenval)*100)

library(ggplot2)

ggplot(pca, aes(x= V3,y= V4, color=pca2$V7))  +
  xlab("PC 1 (25.62%)") + ylab("PC 2 (25.09%)") +
  geom_point(size=8) +
  scale_color_manual(name= "Population", values=c("#E69F00", "#56B4E9", "#009E73",
  "#F0E442",  "#0072B2", "#D55E00", "#CC79A7", "#999999", "#9AD0F3", "#F7C59F", 
  "#7CAE00", "#C77CFF")) +
  
  theme_bw()+ theme(axis.text=element_text(size=20), axis.title=element_text(size=18,face="bold"),
                    legend.title=element_text(size=18)) +
 ggtitle("PCA <60% missing data (N=47) LD Pruned")
