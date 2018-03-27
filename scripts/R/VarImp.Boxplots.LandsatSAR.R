# This script produces boxplots of the variable importance scores from Random Forests
# classifier. The mean decrease on accuracy of each predictor variable is plotted at
# four classification levels.
#
# Script By:      Jose Don T De Alban
# Date Created:   26 Mar 2018
# Last Modified:  27 Mar 2018

# Set Working Directory ------------------

setwd("/Users/dondealban/KC4/")

# Load Required Packages -----------------

library(ggplot2)


# Read Input Data ------------------------

# Read variable importance scores per level

# Level 1
nng2007l1 <- read.csv(file="nng_l1_rf2007t1.csv", header=TRUE, sep=",")
nng2010l1 <- read.csv(file="nng_l1_rf2010t1.csv", header=TRUE, sep=",")
nng2015l1 <- read.csv(file="nng_l1_rf2015t1.csv", header=TRUE, sep=",")
sby2007l1 <- read.csv(file="sby_l1_rf2007t1.csv", header=TRUE, sep=",")
sby2010l1 <- read.csv(file="sby_l1_rf2010t1.csv", header=TRUE, sep=",")
sby2015l1 <- read.csv(file="sby_l1_rf2015t1.csv", header=TRUE, sep=",")
sng2007l1 <- read.csv(file="sng_l1_rf2007t1.csv", header=TRUE, sep=",")
sng2010l1 <- read.csv(file="sng_l1_rf2010t1.csv", header=TRUE, sep=",")
sng2015l1 <- read.csv(file="sng_l1_rf2015t1.csv", header=TRUE, sep=",")
# Level 2
nng2007l2 <- read.csv(file="nng_l2_rf2007t1.csv", header=TRUE, sep=",")
nng2010l2 <- read.csv(file="nng_l2_rf2010t1.csv", header=TRUE, sep=",")
nng2015l2 <- read.csv(file="nng_l2_rf2015t1.csv", header=TRUE, sep=",")
sby2007l2 <- read.csv(file="sby_l2_rf2007t1.csv", header=TRUE, sep=",")
sby2010l2 <- read.csv(file="sby_l2_rf2010t1.csv", header=TRUE, sep=",")
sby2015l2 <- read.csv(file="sby_l2_rf2015t1.csv", header=TRUE, sep=",")
sng2007l2 <- read.csv(file="sng_l2_rf2007t1.csv", header=TRUE, sep=",")
sng2010l2 <- read.csv(file="sng_l2_rf2010t1.csv", header=TRUE, sep=",")
sng2015l2 <- read.csv(file="sng_l2_rf2015t1.csv", header=TRUE, sep=",")
# Level 3
nng2007l3 <- read.csv(file="nng_l3_rf2007t1.csv", header=TRUE, sep=",")
nng2010l3 <- read.csv(file="nng_l3_rf2010t1.csv", header=TRUE, sep=",")
nng2015l3 <- read.csv(file="nng_l3_rf2015t1.csv", header=TRUE, sep=",")
sby2007l3 <- read.csv(file="sby_l3_rf2007t1.csv", header=TRUE, sep=",")
sby2010l3 <- read.csv(file="sby_l3_rf2010t1.csv", header=TRUE, sep=",")
sby2015l3 <- read.csv(file="sby_l3_rf2015t1.csv", header=TRUE, sep=",")
# Level 4
nng2007l4 <- read.csv(file="nng_l4_rf2007t1.csv", header=TRUE, sep=",")
nng2010l4 <- read.csv(file="nng_l4_rf2010t1.csv", header=TRUE, sep=",")
nng2015l4 <- read.csv(file="nng_l4_rf2015t1.csv", header=TRUE, sep=",")
sby2007l4 <- read.csv(file="sby_l4_rf2007t1.csv", header=TRUE, sep=",")
sby2010l4 <- read.csv(file="sby_l4_rf2010t1.csv", header=TRUE, sep=",")
sby2015l4 <- read.csv(file="sby_l4_rf2015t1.csv", header=TRUE, sep=",")

# Combine into one dataframe
level1 <- rbind(nng2007l1,nng2010l1,nng2015l1,sby2007l1,sby2010l1,sby2015l1,sng2007l1,sng2010l1,sng2015l1)
level2 <- rbind(nng2007l2,nng2010l2,nng2015l2,sby2007l2,sby2010l2,sby2015l2,sng2007l2,sng2010l2,sng2015l2)
level3 <- rbind(nng2007l3,nng2010l3,nng2015l3,sby2007l3,sby2010l3,sby2015l3)
level4 <- rbind(nng2007l4,nng2010l4,nng2015l4,sby2007l4,sby2010l4,sby2015l4)

# Change column names
colnames(level1) <- c("Variable","MDA")
colnames(level2) <- c("Variable","MDA")
colnames(level3) <- c("Variable","MDA")
colnames(level4) <- c("Variable","MDA")

# For combined facet grid plot, add level as column
lvl1 <- rep("Level 1", nrow(level1))
lvl2 <- rep("Level 2", nrow(level2))
lvl3 <- rep("Level 3", nrow(level3))
lvl4 <- rep("Level 4", nrow(level4))
level1_new <- cbind(level1, lvl1)
level2_new <- cbind(level2, lvl2)
level3_new <- cbind(level3, lvl3)
level4_new <- cbind(level4, lvl4)
colnames(level1_new) <- c("Variable","MDA","Level")
colnames(level2_new) <- c("Variable","MDA","Level")
colnames(level3_new) <- c("Variable","MDA","Level")
colnames(level4_new) <- c("Variable","MDA","Level")
all_levels <- rbind(level1_new, level2_new, level3_new, level4_new)


# Generate Plots -------------------------

old_list <- c("B1","B2","B3","B4","B5","B7","EVI",
              "HH","HH_ASM","HH_CON","HH_COR","HH_DIS","HH_ENT","HH_IDM","HH_SAVG","HH_VAR",
              "HV","HV_ASM","HV_CON","HV_COR","HV_DIS","HV_ENT","HV_IDM","HV_SAVG","HV_VAR",
              "LSWI","NDI","NDTI","NDVI","NLI","RAT","SATVI")
new_list <- c("BLUE","GREEN","RED","NIR","SWIR1","SWIR2","EVI",
              "HH","HH ASM","HH CON","HH COR","HH DIS","HH ENT","HH IDM","HH SAVG","HH VAR",
              "HV","HV ASM","HV CON","HV COR","HV DIS","HV ENT","HV IDM","HV SAVG","HV VAR",
              "LSWI","NDI","NDTI","NDVI","NLI","RAT","SATVI")

plotL1 <- ggplot() + geom_boxplot(aes(y=MDA, x=Variable), data=level1, outlier.shape = 1, outlier.size = 1)
plotL1 <- plotL1 + labs(x="Predictor Variables", y="Mean Decrease in Accuracy")
plotL1 <- plotL1 + scale_y_continuous()
plotL1 <- plotL1 + theme(axis.text.x = element_text(angle=90, hjust=1))

plotL2 <- ggplot() + geom_boxplot(aes(y=MDA, x=Variable), data=level2, outlier.shape = 1, outlier.size = 1)
plotL2 <- plotL2 + labs(x="Predictor Variables", y="Mean Decrease in Accuracy")
plotL2 <- plotL2 + scale_y_continuous()
plotL2 <- plotL2 + theme(axis.text.x = element_text(angle=90, hjust=1))

plotL3 <- ggplot() + geom_boxplot(aes(y=MDA, x=Variable), data=level3, outlier.shape = 1, outlier.size = 1)
plotL3 <- plotL3 + labs(x="Predictor Variables", y="Mean Decrease in Accuracy")
plotL3 <- plotL3 + scale_y_continuous()
plotL3 <- plotL3 + theme(axis.text.x = element_text(angle=90, hjust=1))

plotL4 <- ggplot() + geom_boxplot(aes(y=MDA, x=Variable), data=level4, outlier.shape = 1, outlier.size = 1)
plotL4 <- plotL4 + labs(x="Predictor Variables", y="Mean Decrease in Accuracy")
plotL4 <- plotL4 + scale_y_continuous()
plotL4 <- plotL4 + theme(axis.text.x = element_text(angle=90, hjust=1))

plotALL <- ggplot() + geom_boxplot(aes(y=MDA, x=Variable), data=all_levels, outlier.shape = 1, outlier.size = 1)
plotALL <- plotALL + labs(x="Predictor Variables", y="Mean Decrease in Accuracy")
plotALL <- plotALL + facet_grid(Level~.)
plotALL <- plotALL + scale_y_continuous()
plotALL <- plotALL + theme(axis.text.x = element_text(angle=90, hjust=1))

plotALL <- ggplot() + geom_boxplot(aes(y=MDA, x=Variable), data=all_levels, outlier.shape = 1, outlier.size = 1)
plotALL <- plotALL + labs(x="Predictor Variables", y="Mean Decrease in Accuracy")
plotALL <- plotALL + facet_grid(Level~.)
plotALL <- plotALL + scale_y_continuous()
plotALL <- plotALL + scale_x_discrete(breaks=c(old_list), labels=c(new_list))
plotALL <- plotALL + theme(axis.text.x = element_text(angle=90, hjust=1))


# Save Output Plots to File --------------

ggsave(plotL1, file="VarImp-Boxplot-L1.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(plotL2, file="VarImp-Boxplot-L2.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(plotL3, file="VarImp-Boxplot-L3.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(plotL4, file="VarImp-Boxplot-L4.pdf", width=19.89, height=15, units="cm", dpi=300)

ggsave(plotALL, file="VarImp-Boxplot-ALLv1.pdf", width=15, height=19.89, units="cm", dpi=300)
ggsave(plotALL, file="VarImp-Boxplot-ALLv2.pdf", width=24, height=30.89, units="cm", dpi=300)