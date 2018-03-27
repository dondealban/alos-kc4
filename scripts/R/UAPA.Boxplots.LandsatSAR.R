# This script produces boxplots to visualise the user's and producer's accuracies obtained
# for each land cover category at a particular classification level. The accuracies of each 
# category is plotted at four classification levels.
#
# Script By:      Jose Don T De Alban
# Date Created:   27 Mar 2018
# Last Modified:  

# Set Working Directory ------------------

setwd("/Users/dondealban/KC4/")

# Load Required Packages -----------------

library(ggplot2)


# Read Input Data ------------------------

uapal1 <- read.csv(file="UAPA_L1.csv", header=TRUE, sep=",")
uapal2 <- read.csv(file="UAPA_L2.csv", header=TRUE, sep=",")
uapal3 <- read.csv(file="UAPA_L3.csv", header=TRUE, sep=",")
uapal4 <- read.csv(file="UAPA_L4.csv", header=TRUE, sep=",")


# Generate Plots -------------------------

plotL1 <- ggplot() + geom_boxplot(aes(y=UA, x=CATEGORY, fill=SITE), data=uapal1, outlier.shape = 1, outlier.size = 1)
plotL1 <- plotL1 + labs(x="Land Cover Category", y="Accuracy (x 100%)")
plotL1 <- plotL1 + scale_y_continuous()
plotL1 <- plotL1 + theme(axis.text.x = element_text(angle=90, hjust=1))

