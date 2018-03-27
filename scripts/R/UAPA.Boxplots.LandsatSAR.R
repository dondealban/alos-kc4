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
library(reshape2)


# Read Input Data ------------------------

uapal1 <- read.csv(file="UAPA_L1.csv", header=TRUE, sep=",")
uapal2 <- read.csv(file="UAPA_L2.csv", header=TRUE, sep=",")
uapal3 <- read.csv(file="UAPA_L3.csv", header=TRUE, sep=",")
uapal4 <- read.csv(file="UAPA_L4.csv", header=TRUE, sep=",")

# Unbiased estimates
adjl1 <- read.csv(file="UAPA_L1_Adj.csv", header=TRUE, sep=",")
adjl2 <- read.csv(file="UAPA_L2_Adj.csv", header=TRUE, sep=",")

# Manipulate Data ------------------------

# Convert wide format data frame into long format data frame
ml1 <- melt(uapal1, id.vars=c("CATEGORY","SITE","LEVEL","YEAR"))
ml2 <- melt(uapal2, id.vars=c("CATEGORY","SITE","LEVEL","YEAR"))
ml3 <- melt(uapal3, id.vars=c("CATEGORY","SITE","LEVEL","YEAR"))
ml4 <- melt(uapal4, id.vars=c("CATEGORY","SITE","LEVEL","YEAR"))
ml1adj <- melt(adjl1, id.vars=c("CATEGORY","SITE","LEVEL","YEAR"))
ml2adj <- melt(adjl2, id.vars=c("CATEGORY","SITE","LEVEL","YEAR"))

# Rename column names
colnames(ml1) <- c("Category","Site","Level","Year","Acc.Type","Acc.Value")
colnames(ml2) <- c("Category","Site","Level","Year","Acc.Type","Acc.Value")
colnames(ml3) <- c("Category","Site","Level","Year","Acc.Type","Acc.Value")
colnames(ml4) <- c("Category","Site","Level","Year","Acc.Type","Acc.Value")
colnames(ml1adj) <- c("Category","Site","Level","Year","Acc.Type","Acc.Value")
colnames(ml2adj) <- c("Category","Site","Level","Year","Acc.Type","Acc.Value")

# Replace zeroes with NA
ml1[ml1==0] <- NA
ml2[ml2==0] <- NA
ml3[ml3==0] <- NA
ml4[ml4==0] <- NA
ml1adj[ml1adj==0] <- NA
ml2adj[ml2adj==0] <- NA

# Generate Plots -------------------------

plotL1 <- ggplot() + geom_boxplot(aes(y=Acc.Value, x=Category, fill=Acc.Type), data=ml1, outlier.shape = 1, outlier.size = 1)
plotL1 <- plotL1 + labs(x="Land Cover Category", y="Accuracy (x 100%)")
plotL1 <- plotL1 + scale_fill_manual(values=c("light blue","light green"), name="", labels=c("UA","PA"))
plotL1 <- plotL1 + scale_y_continuous()
plotL1

plotL2 <- ggplot() + geom_boxplot(aes(y=Acc.Value, x=Category, fill=Acc.Type), data=ml2, outlier.shape = 1, outlier.size = 1)
plotL2 <- plotL2 + labs(x="Land Cover Category", y="Accuracy (x 100%)")
plotL2 <- plotL2 + scale_fill_manual(values=c("light blue","light green"), name="", labels=c("UA","PA"))
plotL2 <- plotL2 + scale_y_continuous()
plotL2

plotL3 <- ggplot() + geom_boxplot(aes(y=Acc.Value, x=Category, fill=Acc.Type), data=ml3, outlier.shape = 1, outlier.size = 1)
plotL3 <- plotL3 + labs(x="Land Cover Category", y="Accuracy (x 100%)")
plotL3 <- plotL3 + scale_fill_manual(values=c("light blue","light green"), name="", labels=c("UA","PA"))
plotL3 <- plotL3 + scale_y_continuous()
plotL3

plotL4 <- ggplot() + geom_boxplot(aes(y=Acc.Value, x=Category, fill=Acc.Type), data=ml4, outlier.shape = 1, outlier.size = 1)
plotL4 <- plotL4 + labs(x="Land Cover Category", y="Accuracy (x 100%)")
plotL4 <- plotL4 + scale_fill_manual(values=c("light blue","light green"), name="", labels=c("UA","PA"))
plotL4 <- plotL4 + scale_y_continuous()
plotL4

plotL1a <- ggplot() + geom_boxplot(aes(y=Acc.Value, x=Category, fill=Acc.Type), data=ml1adj, outlier.shape = 1, outlier.size = 1)
plotL1a <- plotL1a + labs(x="Land Cover Category", y="Accuracy (x 100%)")
plotL1a <- plotL1a + scale_fill_manual(values=c("light blue","light green"), name="", labels=c("UA","PA"))
plotL1a <- plotL1a + scale_y_continuous()
plotL1a

plotL2a <- ggplot() + geom_boxplot(aes(y=Acc.Value, x=Category, fill=Acc.Type), data=ml2adj, outlier.shape = 1, outlier.size = 1)
plotL2a <- plotL2a + labs(x="Land Cover Category", y="Accuracy (x 100%)")
plotL2a <- plotL2a + scale_fill_manual(values=c("light blue","light green"), name="", labels=c("UA","PA"))
plotL2a <- plotL2a + scale_y_continuous()
plotL2a


# Save Output Plots to File --------------

ggsave(plotL1, file="UAPA-Boxplot-L1.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(plotL2, file="UAPA-Boxplot-L2.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(plotL3, file="UAPA-Boxplot-L3.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(plotL4, file="UAPA-Boxplot-L4.pdf", width=19.89, height=15, units="cm", dpi=300)

ggsave(plotL1a, file="UAPA-Boxplot-L1-Adj.pdf", width=19.89, height=15, units="cm", dpi=300)
ggsave(plotL2a, file="UAPA-Boxplot-L2-Adj.pdf", width=19.89, height=15, units="cm", dpi=300)
