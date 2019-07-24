function(input, output, session) {
  observe({
      updateSelectInput(session, "user_or_proj",) 
  })

  dltree <- eventReactive(input$goButton, {
    # project_info <- get_inat_obs_project(grpid = "calbats", type = "info", raw = F)
    # project_info$title can be used as title for the chronogram or the whole main panel
    # project_info$description can be displayed when hovering over the project name or shown at the top.
    if (input$user_or_proj == "1"){
        proj_dat <- get_inat_obs_project(input$projectID, type="observations", raw=FALSE)
        spp_list <- unique(proj_dat$Scientific.name)
    }
     else
    {
       user_dat <- get_inat_obs_user(input$projectID)
       spp_list <- levels(unique(user_dat$scientific_name))
     }

    # code to make list: write(paste(spp_list, collapse = '", "'), file="5062spp_list.txt")
    tryCatch(
      datelife_search(input=spp_list, summary_format="phylo_median"),
      error=function(e) taxa_get_otol_tree(spp_list))
  })

  observe({
    updateSelectInput(session, "taxon", choices = c(gsub("_", " ", dltree()$tip.label)))
    })
  
  if (!inherits(dltree(), "phylo")){
    #return an apology message or an image of the organisms
    print("Sorry")
  } else{
    dltree_height <- reactive({
      tryCatch(max(ape::branching.times(dltree())), error = function(e) NA)
    })
    output$tree <- renderPlot({
      p <- ggtree(dltree()) + ggtree::geom_tiplab() + 
            coord_cartesian(xlim = c(dltree_height()*0.4,-dltree_height()*1.1), 
            ylim = c(0,ape::Ntip(dltree()))) + theme_tree2()
      p <- revts(p)
      if(is.numeric(dltree_height())){
        gggeo_scale(p, neg=TRUE)
      }
    })
  }
  
  dat <- eventReactive(input$taxonButton, {
  rgbif::occ_search(scientificName= input$taxon, return='data', hasCoordinate=TRUE)
  })
  output$gbif_map <- renderPlot({
    wm <- borders("world", colour="gray50", fill="gray50")
    ggplot() + coord_fixed() + wm + 
      geom_point(data = dat(), aes(x = decimalLongitude, y = decimalLatitude), colour = "darkred", size = 0.5) +
      theme_bw()
  })
}