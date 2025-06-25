library(ggplot2)

cv<- read.table("cv_summary.txt", header = TRUE)

ggplot(cv, aes(x = K, y = CV_Error)) +
  geom_line(color = "black", size = 1) +
  geom_point(size = 8, color = "black") +
  theme_minimal(base_size = 14) +
  labs(x = "Number of Clusters (K)",
       y = "Cross Validation Error") +
  scale_x_continuous(breaks = cv$K) +
  theme_bw()+ theme(axis.text=element_text(size=20), axis.title=element_text(size=18,face="bold"))
