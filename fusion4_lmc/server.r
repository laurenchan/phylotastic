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
        spp_list <- unique(proj_dat$Scientific.name, nmax=input$rec_limit)
    }
     else{
       user_dat <- get_inat_obs_user(input$projectID)
       spp_list <- levels(unique(user_dat$scientific_name), nmax=input$rec_limit)
     }

    # code to make list: write(paste(spp_list, collapse = '", "'), file="5062spp_list.txt")
    datelife_search(input=spp_list, summary_format="phylo_median") #, get_spp_from_taxon = TRUE)
  })
  
    observe({
      updateSelectInput(session, "taxon", choices = c(gsub("_", " ", dltree()$tip.label)))
      })
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
  dat <- eventReactive(input$taxonButton, {
    rgbif::occ_search(scientificName= input$taxon, return='data', hasCoordinate=TRUE)
  })
  output$gbif_map <- renderPlot({
    wm <- borders("world", colour="gray50", fill="gray50")
    ggplot() + #coord_fixed() + 
      wm + 
      geom_point(data = dat(), aes(x = decimalLongitude, y = decimalLatitude), colour = "darkred", size = 0.5) +
# coord_fixed adjusts zoom. clunky but works. 
     coord_fixed(xlim = input$longitude, ylim = input$latitude, expand = FALSE) +
      theme_bw()
  })
}