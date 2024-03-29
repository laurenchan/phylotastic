# rinat get data
proj_dat <- get_inat_obs_project("edible-flora", type="observations", raw=FALSE)
proj_dat <- get_inat_obs_project("greater-yellowstone-ecosystem", type="observations", raw=FALSE)
proj_dat <- get_inat_obs_project(1108, type="observations", raw=FALSE)

names(proj_dat)
sub_table<-cbind(proj_dat$Scientific.name, proj_dat$Iconic.taxon.name)

# checks for weird beahviour in greater yellowstone ecosystem project
grep("Phalacrocorax", proj_dat$Scientific.name)
proj_dat$Scientific.name[grep("Phalacrocorax", proj_dat$Scientific.name)]
proj_dat$Iconic.taxon.name[grep("Phalacrocorax", proj_dat$Scientific.name)]
sub_table <- sub_table[!duplicated(sub_table[,1]),]
grep("Nannopterum", sub_table[,1])
grep("Phalacrocorax", tree$tip.label)

grep("Musa", proj_dat$Scientific.name)
sapply(proj_dat, "[", 202)
grep("Hesperophycus", proj_dat$Scientific.name)
sapply(proj_dat, "[", 74)
tree <- tryCatch(datelife_search(input=sub_table[,1], summary_format="phylo_median"), error = function(e) NA) #, get_spp_from_taxon = TRUE)
index <- match(tree$tip.label, gsub(" ", "_", sub_table[,1]))
tree$tax <- sub_table[index, 2]
# tree$tip.label[178]
tree$tip.label[131]
taxon <- "Aves"
taxon <- "Fungi"
taxon <- "Chromista"
tree2 <- ape::drop.tip(tree, tip = tree$tip.label[!tree$tax  %in% taxon])
tree2
tree_height <- max(ape::branching.times(tree))
genus <- sapply(strsplit(tree$tip.label, split = "_"), "[", 1)
species <- sapply(strsplit(tree$tip.label, split = "_"), "[", 2)
paste0("italic(", gsub("_", " ", tree$tip.label), ")")
 p <- ggtree(tree) + ggtree::geom_tiplab(fontface = "italic") + 
      scale_x_continuous(breaks = sort(seq(0, round(tree_height*1.1), 250)*-1), labels  = abs(sort(seq(0, round(tree_height*1.1), 250)*-1))) +
      coord_cartesian(xlim = c(tree_height*0.4,-tree_height*1.1), 
                      ylim = c(-2,ape::Ntip(tree)), expand = FALSE) + theme_tree2()
    p <- revts(p)
    gggeo_scale(p, neg=TRUE) 
    
proj_dat <- get_inat_obs_project(1108, type="info", raw=FALSE)

    