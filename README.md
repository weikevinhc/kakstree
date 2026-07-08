This is the R function to plot Hyphy ABSREL results into a phylogenetic tree with branch-specific omega (Ka/Ks) values. Omega value is plotted in log(10) scale. Branches with significant p-values will have 1 or 2 stars. Note, the significance here is based on hyphy's inference on whether certain parts of the gene experienced episodic positive selection at a given branch, and NOT the significance for levels of selection gene-wide.

The function should be loaded into R console with the following libraries pre-loaded

library(rjson)  
library(ape)  
library(phytools)  
library(phangorn)  
library(RColorBrewer)

Usage:
hyphy.tree(treefile, jsonfile, outg, p, superp)
treefile: treefile used as input for Hyphy ABSREL
jsonfile: json output of Hyphy ABSREL
outg: name of outgroup if you want to change the tree to.
p: p-value cutoff for showing significant branches. Default is 0.01.
superp: p-value cutoff for showing double stars for extremely low p-value. Default is 0.1*p.

If you use this function, please cite:  
Zakerzade R, Chang CH, Chatla K, Krishnapura A, Appiah SP, et al. (2025) Diversification and recurrent adaptation of the synaptonemal complex in Drosophila. PLOS Genetics 21(1): e1011549. https://doi.org/10.1371/journal.pgen.1011549

Test data is provided for the gene c(3)G across the Drosophila phylogeny.

The function requires a tree file, the json output from Hyphy ABSREL.


Try running with the test data on your R console:

c3Gtree <- hyphy.tree(treefile = "c3G.species.tree", 
                      jsonfile = "c3G.species.ABSREL.json",
                      outg = "none",
                      p = 0.01,
                      superp = 0.001)

