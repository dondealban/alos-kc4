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
roi2007 <- read.csv(file="ROI_Train_NNegros_2007_L1.csv", header=TRUE, sep=",")
roi2010 <- read.csv(file="ROI_Train_NNegros_2010_L1.csv", header=TRUE, sep=",")
roi2015 <- read.csv(file="ROI_Train_NNegros_2015_L1.csv", header=TRUE, sep=",")

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
lookup <- c("FOR","NON")
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


# Develop Random Forests Object ----------
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


# SAVE OUTPUTS TO FILE

# Save random forest package results as txt file

sink("output-rf-randomforest-SetA1995.txt", append=FALSE, split=TRUE)
print(rfSetA1995l)
print(rfSetA1995lt1)
print(rfSetA1995lt2)
print(rfSetA1995s)
print(rfSetA1995st1)
print(rfSetA1995st2)
print(rfSetA1995ls)
print(rfSetA1995lst1)
print(rfSetA1995lst2)
sink()
sink("output-rf-randomforest-SetA2015.txt", append=FALSE, split=TRUE)
print(rfSetA2015l)
print(rfSetA2015lt1)
print(rfSetA2015lt2)
print(rfSetA2015s)
print(rfSetA2015st1)
print(rfSetA2015st2)
print(rfSetA2015ls)
print(rfSetA2015lst1)
print(rfSetA2015lst2)
sink()
sink("output-rf-randomforest-SetB2015.txt", append=FALSE, split=TRUE)
print(rfSetB2015l)
print(rfSetB2015lt1)
print(rfSetB2015lt2)
print(rfSetB2015s)
print(rfSetB2015st1)
print(rfSetB2015st2)
print(rfSetB2015ls)
print(rfSetB2015lst1)
print(rfSetB2015lst2)
sink()

# Save graph of random forest variable importance as pdf file

# Set A 1995
pdf("output-rf-varimp-graph-SetA1995-landsat.pdf", width=7, height=5.5)
varImpPlot(rfSetA1995l)
dev.off()
pdf("output-rf-varimp-graph-SetA1995-sar.pdf", width=7, height=5.5)
varImpPlot(rfSetA1995s)
dev.off()
pdf("output-rf-varimp-graph-SetA1995-landsat-sar.pdf", width=7, height=5.5)
varImpPlot(rfSetA1995ls)
dev.off()

# Set A 2015
pdf("output-rf-varimp-graph-SetA2015-landsat.pdf", width=7, height=5.5)
varImpPlot(rfSetA2015l)
dev.off()
pdf("output-rf-varimp-graph-SetA2015-sar.pdf", width=7, height=5.5)
varImpPlot(rfSetA2015s)
dev.off()
pdf("output-rf-varimp-graph-SetA2015-landsat-sar.pdf", width=7, height=5.5)
varImpPlot(rfSetA2015ls)
dev.off()

# Set B 2015
pdf("output-rf-varimp-graph-SetB2015-landsat.pdf", width=7, height=5.5)
varImpPlot(rfSetB2015l)
dev.off()
pdf("output-rf-varimp-graph-SetB2015-sar.pdf", width=7, height=5.5)
varImpPlot(rfSetB2015s)
dev.off()
pdf("output-rf-varimp-graph-SetB2015-landsat-sar.pdf", width=9, height=7.5)
varImpPlot(rfSetB2015ls)
dev.off()
