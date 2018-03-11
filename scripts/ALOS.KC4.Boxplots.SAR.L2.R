# This R script generates box-whisker plots using ggplot2 package to visualise the
# distribution of values for each predictor variable across several land cover types 
# derived from combined Landsat and L-band SAR data covering site in the Philippines.
# This script plots the image values at each ROI taken from from 2007, 2010, and 2015
# PALSAR/PALSAR-2 data (2 polarisations, 3 indices, and 16 GLCM textures).
#
# Script By:      Jose Don T De Alban
# Date Created:   17 Feb 2017
# Last Modified:  10 Mar 2018

# Set Working Directory ------------------

setwd("/Users/dondealban/KC4/")

# Load Required Packages -----------------

library(ggplot2)
library(reshape2)
library(plyr)

# Read Input Data ------------------------

roi2007 <- read.csv(file="ROI_Sibuyan_2007_L2.csv", header=TRUE, sep=",")
roi2010 <- read.csv(file="ROI_Sibuyan_2010_L2.csv", header=TRUE, sep=",")
roi2015 <- read.csv(file="ROI_Sibuyan_2015_L2.csv", header=TRUE, sep=",")

# Clean and Subset Data ------------------

# 1. Add new Code column based on ClassID column plus constant value of 1
  roi2007$Code <- roi2007[,2] + 1
  roi2010$Code <- roi2010[,2] + 1
  roi2015$Code <- roi2015[,2] + 1

# 2. Select columns
  sub2007 <- subset(roi2007, select=c(3:23,26))
  sub2010 <- subset(roi2010, select=c(3:23,26))
  sub2015 <- subset(roi2015, select=c(3:23,26))

# 3. Add new Type column with land cover type string based on Code values
  lookup <- c("FOR","SET","CRP","WET","GRA")
  sub2007$Type <- lookup[sub2007$Code]
  sub2010$Type <- lookup[sub2010$Code]
  sub2015$Type <- lookup[sub2015$Code]

# 4. Add Year column
  year1 <- rep("2007", nrow(sub2007))
  year2 <- rep("2010", nrow(sub2010))
  year3 <- rep("2015", nrow(sub2015))
  sub2007 <- cbind(sub2007, year1)
  sub2010 <- cbind(sub2010, year2)
  sub2015 <- cbind(sub2015, year3)

# 5. Change column names
  list <- c("HH","HH_ASM","HH_CON","HH_COR","HH_DIS","HH_ENT","HH_IDM","HH_SAVG","HH_VAR",
            "HV","HV_ASM","HV_CON","HV_COR","HV_DIS","HV_ENT","HV_IDM","HV_SAVG","HV_VAR",
            "NDI","NLI","RAT","CODE","LC_TYPE","YEAR")
  colnames(sub2007) <- c(list)
  colnames(sub2010) <- c(list)
  colnames(sub2015) <- c(list)

# Combine all data into one dataframe
data <- rbind(sub2007, sub2010, sub2015)

# Generate Plots -------------------------

# HH
sarHH <- ggplot() + geom_boxplot(aes(y = HH, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHH <- sarHH + labs(title="HH Sigma0 Backscatter of Land Cover Types", x="Land Cover Type", y="Value (dB)", fill="Year")
sarHH <- sarHH + scale_y_continuous()

# HH ASM
sarHH_ASM <- ggplot() + geom_boxplot(aes(y = HH_ASM, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHH_ASM <- sarHH_ASM + labs(title="HH Angular Second Moment Texture Backscatter of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHH_ASM <- sarHH_ASM + scale_y_continuous()

# HH CON
sarHH_CON <- ggplot() + geom_boxplot(aes(y = HH_CON, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHH_CON <- sarHH_CON + labs(title="HH Contrast Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHH_CON <- sarHH_CON + scale_y_continuous()

# HH COR
sarHH_COR <- ggplot() + geom_boxplot(aes(y = HH_COR, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHH_COR <- sarHH_COR + labs(title="HH Correlation Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHH_COR <- sarHH_COR + scale_y_continuous()

# HH DIS
sarHH_DIS <- ggplot() + geom_boxplot(aes(y = HH_DIS, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHH_DIS <- sarHH_DIS + labs(title="HH Dissimilarity Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHH_DIS <- sarHH_DIS + scale_y_continuous()

# HH ENT
sarHH_ENT <- ggplot() + geom_boxplot(aes(y = HH_ENT, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHH_ENT <- sarHH_ENT + labs(title="HH Entropy Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHH_ENT <- sarHH_ENT + scale_y_continuous()

# HH IDM
sarHH_IDM <- ggplot() + geom_boxplot(aes(y = HH_IDM, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHH_IDM <- sarHH_IDM + labs(title="HH Homogeneity Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHH_IDM <- sarHH_IDM + scale_y_continuous()

# HH SAVG
sarHH_SAVG <- ggplot() + geom_boxplot(aes(y = HH_SAVG, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHH_SAVG <- sarHH_SAVG + labs(title="HH Mean Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHH_SAVG <- sarHH_SAVG + scale_y_continuous()

# HH VAR
sarHH_VAR <- ggplot() + geom_boxplot(aes(y = HH_VAR, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHH_VAR <- sarHH_VAR + labs(title="HH Variance Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHH_VAR <- sarHH_VAR + scale_y_continuous()

# HV
sarHV <- ggplot() + geom_boxplot(aes(y = HV, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHV <- sarHV + labs(title="HV Sigma0 Backscatter of Land Cover Types", x="Land Cover Type", y="Value (dB)", fill="Year")
sarHV <- sarHV + scale_y_continuous()

# HV ASM
sarHV_ASM <- ggplot() + geom_boxplot(aes(y = HV_ASM, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHV_ASM <- sarHV_ASM + labs(title="HV Angular Second Moment Texture Backscatter of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHV_ASM <- sarHV_ASM + scale_y_continuous()

# HV CON
sarHV_CON <- ggplot() + geom_boxplot(aes(y = HV_CON, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHV_CON <- sarHV_CON + labs(title="HV Contrast Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHV_CON <- sarHV_CON + scale_y_continuous()

# HV COR
sarHV_COR <- ggplot() + geom_boxplot(aes(y = HV_COR, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHV_COR <- sarHV_COR + labs(title="HV Correlation Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHV_COR <- sarHV_COR + scale_y_continuous()

# HV DIS
sarHV_DIS <- ggplot() + geom_boxplot(aes(y = HV_DIS, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHV_DIS <- sarHV_DIS + labs(title="HV Dissimilarity Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHV_DIS <- sarHV_DIS + scale_y_continuous()

# HV ENT
sarHV_ENT <- ggplot() + geom_boxplot(aes(y = HV_ENT, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHV_ENT <- sarHV_ENT + labs(title="HV Entropy Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHV_ENT <- sarHV_ENT + scale_y_continuous()

# HV IDM
sarHV_IDM <- ggplot() + geom_boxplot(aes(y = HV_IDM, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHV_IDM <- sarHV_IDM + labs(title="HV Homogeneity Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHV_IDM <- sarHV_IDM + scale_y_continuous()

# HV SAVG
sarHV_SAVG <- ggplot() + geom_boxplot(aes(y = HV_SAVG, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHV_SAVG <- sarHV_SAVG + labs(title="HV Mean Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHV_SAVG <- sarHV_SAVG + scale_y_continuous()

# HV VAR
sarHV_VAR <- ggplot() + geom_boxplot(aes(y = HV_VAR, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarHV_VAR <- sarHV_VAR + labs(title="HV Variance Texture of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarHV_VAR <- sarHV_VAR + scale_y_continuous()

# NDI
sarNDI <- ggplot() + geom_boxplot(aes(y = NDI, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarNDI <- sarNDI + labs(title="NDI Values of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarNDI <- sarNDI + scale_y_continuous()

# NLI
sarNLI <- ggplot() + geom_boxplot(aes(y = NLI, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarNLI <- sarNLI + labs(title="NLI Values of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarNLI <- sarNLI + scale_y_continuous()

# RATIO
sarRAT <- ggplot() + geom_boxplot(aes(y = RAT, x = LC_TYPE, fill=factor(YEAR)), data=data, outlier.shape = 1, outlier.size = 1)
sarRAT <- sarRAT + labs(title="HH/HV Ratio Values of Land Cover Types", x="Land Cover Type", y="Value", fill="Year")
sarRAT <- sarRAT + scale_y_continuous()

# Save Output Plots to File --------------

ggsave(sarHH, file="Boxplot-HH.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHH_ASM, file="Boxplot-HH-ASM.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHH_CON, file="Boxplot-HH-CON.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHH_COR, file="Boxplot-HH-COR.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHH_DIS, file="Boxplot-HH-DIS.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHH_ENT, file="Boxplot-HH-ENT.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHH_IDM, file="Boxplot-HH-IDM.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHH_SAVG, file="Boxplot-HH-SAVG.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHH_VAR, file="Boxplot-HH-VAR.pdf", width=19.89, height=15, units="cm", dpi=300)

ggsave(sarHV, file="Boxplot-HV.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHV_ASM, file="Boxplot-HV-ASM.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHV_CON, file="Boxplot-HV-CON.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHV_COR, file="Boxplot-HV-COR.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHV_DIS, file="Boxplot-HV-DIS.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHV_ENT, file="Boxplot-HV-ENT.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHV_IDM, file="Boxplot-HV-IDM.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHV_SAVG, file="Boxplot-HV-SAVG.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarHV_VAR, file="Boxplot-HV-VAR.pdf", width=19.89, height=15, units="cm", dpi=300)

ggsave(sarNDI, file="Boxplot-NDI.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarNLI, file="Boxplot-NLI.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(sarRAT, file="Boxplot-RT1.pdf", width=19.89, height=15, units="cm", dpi=300)
