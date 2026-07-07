This is the R function to plot Hyphy ABSREL results into a phylogenetic tree with branch-specific omega (Ka/Ks) values.

The function should be loaded into R with the following libraries pre-loaded

library(rjson)  
library(ape)  
library(phytools)  
library(phangorn)  
library(RColorBrewer)


Test data is provided for the gene c(3)G across the Drosophila phylogeny.

The function requires a tree file, the json output from Hyphy ABSREL.


Try running with the test data on your R console:

c3Gtree <- hyphy.tree(treefile = "c3G.species.tree", 
                      jsonfile = "c3G.species.ABSREL.json",
                      outg = "none")
