function(input, output, session) {
  dltree <- eventReactive(input$goButton,{
    # proj_dat <- get_inat_obs_project(input$projectID, type="observations", raw=FALSE)
    # spp_list <- unique(proj_dat$Scientific.name)
    # spp_list <- c("Hogna carolinensis", "Erethizon dorsatum", "Cottus bairdii", "Ardea alba", "Taricha granulosa", "Branta canadensis", "Ardea herodias", "Lithobates catesbeianus", "Euphagus cyanocephalus", "Ensatina eschscholtzii", "Rhyacotriton kezeri", "Pelecanus erythrorhynchos", "Melanerpes formicivorus", "Sciurus", "Phalacrocorax auritus", "Larus", "Myocastor coypus", "Cervus canadensis roosevelti")
    # code to make list: write(paste(spp_list, collapse = '", "'), file="5062spp_list.txt")
    
    
    datelife_search(input=spp_list, summary_format="phylo_median")})
  
  output$tree <- renderPlot({
    p <- ggtree(dltree()) + ggtree::geom_tiplab() + coord_cartesian(xlim = c(200,-500), ylim = c(-2,Ntip(dltree())))+ theme_tree2()
    p <- revts(p)
    gggeo_scale(p, neg=TRUE) 
  })
  
}