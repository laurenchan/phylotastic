library(rinat)
library(rphylotastic)

proj_dat <- get_inat_obs_project("pu-vert-zoo", type="info", raw=FALSE)
proj_obs <- get_inat_obs_project(proj_dat$id, type="observations")

spp_list <- unique(proj_obs$Scientific.name)

dltree <- datelife_search(input=spp_list, summary_format="phylo_median")
#pttree <- taxa_get_otol_tree(spp_list)


p <- ggtree(dltree) + ggtree::geom_tiplab() + coord_cartesian(xlim = c(200,-500), ylim = c(-2,Ntip(dltree)))+ theme_tree2()
p <- revts(p)
gggeo_scale(p, neg=TRUE) 
