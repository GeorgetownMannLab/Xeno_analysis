#####
#this script extracts species, presence/absence of xeno, 
#maximum sea surface temperature (SST), and runs a logistic regression.
#ggplot2 is used to plot the logistic regression and create figure 5.
#####

#extract variables from geographic data
Xeno_Table_Draft_11_15 <- as.data.frame(read.csv("RawData/Geo_data_11_15.csv"))

temp_data <- Xeno_Table_Draft_11_15[,c("Species", "Presence.absence", "max.temp")]

colnames(temp_data)[2]<- "Xeno"

temp_data$Xeno <- as.factor(temp_data$Xeno)
temp_data$Xeno <- ifelse(test=temp_data$Xeno == "Yes", yes=1, no=0)

#run a logistic regression on max SST and xeno presence/absence
logistic <- glm(Xeno ~ max.temp, data=temp_data, family="binomial")
summary(logistic)

#extract key statistics for summary table
p <- summary(logistic)$coefficients[,4]
standard_error <-summary(logistic)$coefficients[,2]
model_coefficient <-summary(logistic)$coefficients[,1]
summary_table <- as.data.frame(t(rbind(model_coefficient, standard_error, p)))
row.names(summary_table) <- c("intercept", "maximum temperature")

#export summary table
#write.csv(summary_table, 'logistic_summary.csv', row.names=TRUE)

#write export file for Figure 5
#pdf("Figure_5.pdf")

#plot the logistic regression
plot_data <- temp_data[c("Xeno", "max.temp")]
library(ggplot2)
ggplot(plot_data, aes(max.temp, Xeno))+
  geom_point(alpha = 0.2) +
  geom_smooth(method = "glm", method.args = list(family = "binomial")) +
  labs(
    x = "Maximum Temperature",
    y = expression(paste(italic("X. globicipitis") , " attachment"))
  )

#dev.off()
