## library needed rjson, phangorn, ape, phytools, RColorBrewer
library(rjson)
library(ape)
library(phytools)
library(phangorn)
library(RColorBrewer)
## function to plot hyphy kaks results on tree and return modified tree object with p-values and omega values
hyphy.tree <- function(treefile, jsonfile, outg) {
  tree<- read.tree(treefile)
  json <- fromJSON(file = jsonfile)
  #  tree <- drop.tip(tree, grep(outg, tree$tip.label))
  #plotBranchbyTrait(tree,tree$edge.length,"edges", palette =  colorRampPalette(brewer.pal("RdYlGn", n = 4)),show.tip.label=TRUE)
  treetxt <- paste(json$input$trees$`0`, ";", sep = "")
  tree2 <- read.tree(text = treetxt)
  #  tree2 <- drop.tip(tree2, grep(outg, tree2$tip.label))
  tree2$node.label[1] <- "base"
  #plotBranchbyTrait(tree2,tree2$edge.length,"edges", palette =  colorRampPalette(brewer.pal("RdYlGn", n = 4)),show.tip.label=TRUE)
  #nodelabels(tree2$node.label)
  polynode <- unlist(sapply((length(tree2$tip.label)+1):(length(tree2$tip.label)+tree2$Nnode), function(x) {length(Children(tree2, x))}))
  names(polynode) <- (length(tree2$tip.label)+1):(length(tree2$tip.label)+tree2$Nnode)
  polyname <- tree2$node.label
  tree22 <- tree2
  tree22$edge.length <- NULL
  pv <- sapply(names(json$`branch attributes`$`0`), 
               function(x){
                 xlist <- json$`branch attributes`$`0`[[x]]
                 return(xlist$`Uncorrected P-value`)})
  ##extracting omega values from hyphy json
  om <- sapply(names(json$`branch attributes`$`0`), 
               function(x){
                 xlist <- json$`branch attributes`$`0`[[x]]
                 return(xlist$`Baseline MG94xREV omega ratio`)})
  om[om > 10] <- 10
  om[om < 0.1] <- 0.1
  om <- log10(om)
  ##identifying edges for omega values
  X <- tree$edge
  c1 <- rep("", nrow(X))
  c1[X[,1] > length(tree$tip)] <- tree$node.label[X[X[,1] > length(tree$tip), 1]-length(tree$tip)]
  c1[X[,1] <= length(tree$tip)] <- tree$tip[X[X[,1]%in%1:length(tree$tip),1]]
  c2 <- rep("", nrow(X))
  c2[X[,2] > length(tree$tip)] <- tree$node.label[X[X[,2] > length(tree$tip), 2]-length(tree$tip)]
  c2[X[,2] <= length(tree$tip)] <- tree$tip[X[X[,2]%in%1:length(tree$tip),2]]
  names(tree$edge.length) <- c2
  om <- om[match(names(tree$edge.length), names(om))]
  names(om) <- c2
  pv <- pv[match(names(tree$edge.length), names(pv))]
  names(pv) <- c2
  allnames <- c(tree$tip.label, tree$node.label)
  for (nod in c2[is.na(om)]) {
    sisnod <- allnames[getSisters(tree, which(allnames == nod))]
    om[names(om) == nod] <- unname(om[names(om) == sisnod])
    pv[names(om) == nod] <- unname(pv[names(om) == sisnod])
  }
  treeom <- tree
  treeom$edge.length <- om
  treepv <- tree
  treepv$edge.length <- pv
  if (any(grepl(outg, tree$tip.label))) {
    outgdex <- grep(outg, tree$tip.label)
    tree <- reroot(tree, outgdex, 0.2*tree$edge.length[grep(outg,names(tree$edge.length))])
    rootdex <- which(tree$edge[,2] == getSisters(tree, grep(outg, tree$tip.label)))
    treeom <- reroot(treeom, outgdex)
    treeom$edge.length[grep(outg,names(treeom$edge.length))] <- unname(treeom$edge.length[rootdex])
    treepv <- reroot(treepv, outgdex)
    treepv$edge.length[grep(outg,names(treepv$edge.length))] <- unname(treepv$edge.length[rootdex])
  }
  treeom$edge.length[is.na(treeom$edge.length)] <- 0
  colpal <- colorRampPalette(rev(brewer.pal("RdYlBu", n = 9)))
  plotBranchbyTrait(tree, treeom$edge.length, "edges", palette =  colpal, 
                    show.tip.label=TRUE, xlims = c(-1,1))
  add.scale.bar(lwd = 2)
  treepv$edge.length[is.na(treepv$edge.length)] <- 1
  if (sum(treepv$edge.length < 0.05)) {
    stars <- ifelse(treepv$edge.length[which(treepv$edge.length < 0.05)] < 0.005, "**", "*")
    
    edgelabels(text = stars, which(treepv$edge.length < 0.05), frame = "none", adj = c(0.5,0.75), cex = 2)
  }
  
  
  tree$omega <- treeom$edge.length
  tree$pval <- treepv$edge.length
  return(tree)
}