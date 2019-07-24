function(input, output, session) {
  dltree <- eventReactive(input$goButton, {
    proj_dat <- get_inat_obs_project(input$projectID, type="observations", raw=FALSE)
    spp_list <- unique(proj_dat$Scientific.name)
    # spp_list <- c("Rhea americana", "Pterocnemia pennata", "Struthio camelus")
    # spp_list <- c("Hogna carolinensis", "Erethizon dorsatum", "Cottus bairdii", "Ardea alba", "Taricha granulosa", "Branta canadensis", "Ardea herodias", "Lithobates catesbeianus", "Euphagus cyanocephalus", "Ensatina eschscholtzii", "Rhyacotriton kezeri", "Pelecanus erythrorhynchos", "Melanerpes formicivorus", "Sciurus", "Phalacrocorax auritus", "Larus", "Myocastor coypus", "Cervus canadensis roosevelti")
    # code to make list: write(paste(spp_list, collapse = '", "'), file="5062spp_list.txt")
    datelife_search(input=spp_list, summary_format="phylo_median")
  })
  observe({
    updateSelectInput(session, "taxon", choices = c("all", gsub("_", " ", dltree()$tip.label))
  )})
  dltree_height <- reactive({
    max(ape::branching.times(dltree()))
  })
  output$tree <- renderPlot({
    p <- ggtree(dltree()) + ggtree::geom_tiplab() + 
      coord_cartesian(xlim = c(dltree_height()*0.4,-dltree_height()*1.1), 
                      ylim = c(0,ape::Ntip(dltree()))) + theme_tree2()
    p <- revts(p)
    gggeo_scale(p, neg=TRUE) 
  })
  dat <- reactive({
    print(input$taxon)
    if("all" %in% input$taxon){
      taxon_now <- dltree()$tip.label
    }
    print(taxon_now)
      # else {
    #   taxon_now <- input$taxon
    # }
    # taxon_now <- ifelse("all" %in% input$taxon, dltree$tip.label, input$taxon)
    rgbif::occ_search(scientificName= taxon_now, return='data', hasCoordinate=TRUE)
    # rgbif::occ_search(scientificName= input$taxon, return='data', hasCoordinate=TRUE)
  })
  output$gbif_map <- renderPlot({
    if(length(dat()) == 0){
      suppressWarnings(plot(x = 1:10, type='n',axes=FALSE,ann=FALSE, xpd = TRUE))
      text(x=5, y = 5, labels = "Choose a species to get occurrences from")
    }
    if(length(dat()) > 0){
    wm <- borders("world", colour="gray50", fill="gray50")
    ggplot() + coord_fixed() + wm + 
      geom_point(data = dat(), aes(x = decimalLongitude, y = decimalLatitude), colour = "darkred", size = 0.5) +
      theme_bw()
    }
  })
}