This is the R function to plot Hyphy ABSREL results into a phylogenetic tree with branch-specific omega (Ka/Ks) values.

The function should be loaded into R console with the following libraries pre-loaded

library(rjson)  
library(ape)  
library(phytools)  
library(phangorn)  
library(RColorBrewer)

If you use this script, please cite:
Zakerzade R, Chang CH, Chatla K, Krishnapura A, Appiah SP, et al. (2025) Diversification and recurrent adaptation of the synaptonemal complex in Drosophila. PLOS Genetics 21(1): e1011549. https://doi.org/10.1371/journal.pgen.1011549

Test data is provided for the gene c(3)G across the Drosophila phylogeny.

The function requires a tree file, the json output from Hyphy ABSREL.


Try running with the test data on your R console:

c3Gtree <- hyphy.tree(treefile = "c3G.species.tree", 
                      jsonfile = "c3G.species.ABSREL.json",
                      outg = "none")
