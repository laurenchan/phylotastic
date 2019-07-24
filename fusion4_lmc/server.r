function(input, output, session) {
  observe({
      updateSelectInput(session, "user_or_proj",) 
  })
   spp_table <- eventReactive(input$goButton, {
     print("inat button")
    if (input$user_or_proj == "1"){
        proj_dat <- get_inat_obs_project(input$projectID, type="observations", raw=FALSE)
 #       spp_to_plot <- unique(proj_dat$Scientific.name, nmax=input$rec_limit)
        sub_table<-cbind(proj_dat$Scientific.name, proj_dat$Iconic.taxon.name)
    }else{
        user_dat <- get_inat_obs_user(input$projectID)
#       spp_to_plot <- levels(unique(user_dat$scientific_name), nmax=input$rec_limit)
        sub_table<-cbind(as.character(user_dat$scientific_name), as.character(user_dat$iconic_taxon_name))
     }
    print("iNaturalist Records Pulled")
    sub_table
})
    observe({
      updateSelectInput(session, "clade", choices = c("", unique(sub_table[,2])))
    })
    
    spp_list <- reactive({
      if (!input$clade == ""){
        spp_to_plot <- spp_table()[spp_table()[,2]==input$clade,1]
      } else{
        spp_to_plot <- spp_list[,1]
      }
      spp_to_plot
    })

  
   dltree <- eventReactive(input$phyloButton,{
     datelife_search(input=spp_list(), summary_format="phylo_median") #, get_spp_from_taxon = TRUE)
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
    ggplot() + wm + 
      geom_point(data = dat(), aes(x = decimalLongitude, y = decimalLatitude), colour = "darkred", size = 0.5) +
# coord_fixed adjusts zoom. clunky but works. 
     coord_fixed(xlim = input$longitude, ylim = input$latitude, expand = FALSE) +
      theme_bw()
  })
}