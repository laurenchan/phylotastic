function(input, output, session) {

    spp_list <- eventReactive(input$goButton,{
      proj_dat <- get_inat_obs_project(input$projectID, type="observations", raw=FALSE)
      unique(proj_dat$Scientific.name)
    })

    dltree <- eventReactive(input$goButton, {
      datelife_search(input=spp_list, summary_format="phylo_median")
    })
    
    output$ui <- renderUI({
      selectInput("taxon", "Choose a taxon:", choices = spp_list())
      })

    
    output$tree <- renderPlot({
      
      p <- ggtree(spp_info$dltree()) + ggtree::geom_tiplab() + coord_cartesian(xlim = c(200,-500), ylim = c(-2,Ntip(dltree())))+ theme_tree2()
      p <- revts(p)
      gggeo_scale(p, neg=TRUE) 
    })
    
  output$gbif_map <- renderPlot({
    wm <- borders("world", colour="gray50", fill="gray50")
    ggplot() + coord_fixed() + wm + 
      geom_point(data = dat(), aes(x = decimalLongitude, y = decimalLatitude), colour = "darkred", size = 0.5) +
      theme_bw()
  })
}