#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
library(phytools)
tree<- read.tree(args[1])
tree$node.label <- paste(rep("Node", tree$Nnode), 1:tree$Nnode, sep = "")
write.tree(tree, file = paste(args[1], "noded", sep = "."))