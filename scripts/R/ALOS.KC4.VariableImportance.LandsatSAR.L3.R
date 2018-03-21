# This script assesses the variable importance of a Random Forest classification using
# the randomForest package. The objective is to determine the importance of predictor
# variables.
#
# Script By:      Jose Don T De Alban
# Date Created:   03 Mar 2017
# Last Modified:  21 Mar 2018

# Set Working Directory ------------------
setwd("/Users/dondealban/KC4/")

# Set Random Seed ------------------------
set.seed(2015)

# Load Required Packages -----------------
library(randomForest)


# Read Input Data ------------------------

# Read training data per site per year
roi2007 <- read.csv(file="ROI_Train_NNegros_2007_L3.csv", header=TRUE, sep=",")
roi2010 <- read.csv(file="ROI_Train_NNegros_2010_L3.csv", header=TRUE, sep=",")
roi2015 <- read.csv(file="ROI_Train_NNegros_2015_L3.csv", header=TRUE, sep=",")


# Clean and Subset Data ------------------

# 1. Add new Code column based on ClassID column plus constant value of 1
roi2007$Code <- roi2007[,8] + 1
roi2010$Code <- roi2010[,8] + 1
roi2015$Code <- roi2015[,8] + 1

# 2. Select columns
sub2007 <- subset(roi2007, select=c(2:7,9:34,37))
sub2010 <- subset(roi2010, select=c(2:7,9:34,37))
sub2015 <- subset(roi2015, select=c(2:7,9:34,37))

# 3. Add new Type column with land cover type string based on Code values
lookup <- c("CF","OF","MF","BU","AC","PC","FP","IW","GL","FW","SH","WG")
sub2007$Type <- lookup[sub2007$Code]
sub2010$Type <- lookup[sub2010$Code]
sub2015$Type <- lookup[sub2015$Code]

# 4. Add Year column
sub2007$YEAR <- rep(2007, nrow(sub2007))
sub2010$YEAR <- rep(2010, nrow(sub2010))
sub2015$YEAR <- rep(2015, nrow(sub2015))

# 5. Change column names
list <- c("B1","B2","B3","B4","B5","B7","EVI",
          "HH","HH_ASM","HH_CON","HH_COR","HH_DIS","HH_ENT","HH_IDM","HH_SAVG","HH_VAR",
          "HV","HV_ASM","HV_CON","HV_COR","HV_DIS","HV_ENT","HV_IDM","HV_SAVG","HV_VAR",
          "LSWI","NDI","NDTI","NDVI","NLI","RAT","SATVI","CODE","LC_TYPE","YEAR")
colnames(sub2007) <- c(list)
colnames(sub2010) <- c(list)
colnames(sub2015) <- c(list)

# 6. Define factor predictor variables
# LC_TYPE
sub2007$LC_TYPE <- factor(sub2007$LC_TYPE)
sub2010$LC_TYPE <- factor(sub2010$LC_TYPE)
sub2015$LC_TYPE <- factor(sub2015$LC_TYPE)


# Develop Random Forests Objects ---------
# Note: mtry uses default value which is sqrt of number of predictor variables (n=32)

rf2007 <- randomForest(LC_TYPE ~ B1 + B2 + B3 + B4 + B5 + B7 + EVI +
                       HH + HH_ASM + HH_CON + HH_COR + HH_DIS + HH_ENT + HH_IDM + HH_SAVG + HH_VAR +
                       HV + HV_ASM + HV_CON + HV_COR + HV_DIS + HV_ENT + HV_IDM + HV_SAVG + HV_VAR +
                       LSWI + NDI + NDTI + NDVI + NLI + RAT + SATVI, data=sub2007, 
                       ntree=100, importance=TRUE)
rf2010 <- randomForest(LC_TYPE ~ B1 + B2 + B3 + B4 + B5 + B7 + EVI +
                       HH + HH_ASM + HH_CON + HH_COR + HH_DIS + HH_ENT + HH_IDM + HH_SAVG + HH_VAR +
                       HV + HV_ASM + HV_CON + HV_COR + HV_DIS + HV_ENT + HV_IDM + HV_SAVG + HV_VAR +
                       LSWI + NDI + NDTI + NDVI + NLI + RAT + SATVI, data=sub2010, 
                       ntree=100, importance=TRUE)
rf2015 <- randomForest(LC_TYPE ~ B1 + B2 + B3 + B4 + B5 + B7 + EVI +
                       HH + HH_ASM + HH_CON + HH_COR + HH_DIS + HH_ENT + HH_IDM + HH_SAVG + HH_VAR +
                       HV + HV_ASM + HV_CON + HV_COR + HV_DIS + HV_ENT + HV_IDM + HV_SAVG + HV_VAR +
                       LSWI + NDI + NDTI + NDVI + NLI + RAT + SATVI, data=sub2010, 
                       ntree=100, importance=TRUE)

# Calculate Variable Importance ----------

# 1. Variable importance based on permutation importance (mean decrease in accuracy)
rf2007t1 <- importance(rf2007, type=1)
rf2010t1 <- importance(rf2010, type=1)
rf2015t1 <- importance(rf2015, type=1)

# 2. Variable importance based on Gini importance (mean decrease in impurity)
# rf2007t2 <- importance(rf2007, type=2)
# rf2010t2 <- importance(rf2010, type=2)
# rf2015t2 <- importance(rf2015, type=2)


# Save Output Files ----------------------

# Save random forest object results as TXT file
sink("RandomForests-2007.txt", append=FALSE, split=TRUE)
print(rf2007)
print(rf2007t1)
sink()
sink("RandomForests-2010.txt", append=FALSE, split=TRUE)
print(rf2010)
print(rf2010t1)
sink()
sink("RandomForests-2015.txt", append=FALSE, split=TRUE)
print(rf2015)
print(rf2015t1)
sink()

# Save graph of random forest variable importance as PDF file
pdf("RF-Variable-Importance-2007.pdf", width=4, height=8)
dotchart(sort(rf2007t1[,1]), xlab="Mean Decrease in Accuracy")
dev.off()
pdf("RF-Variable-Importance-2010.pdf", width=4, height=8)
dotchart(sort(rf2010t1[,1]), xlab="Mean Decrease in Accuracy")
dev.off()
pdf("RF-Variable-Importance-2015.pdf", width=4, height=8)
dotchart(sort(rf2015t1[,1]), xlab="Mean Decrease in Accuracy")
dev.off()
