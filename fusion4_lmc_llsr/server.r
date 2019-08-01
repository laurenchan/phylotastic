function(input, output, session) {

# Pull species list and taxonomy, construct tree with datelife, and store spp taxonomy in tree as $tax
   dl_tree <- eventReactive(input$goButton, {
    if (input$user_or_proj == "1"){
        proj_dat <- get_inat_obs_project(input$projectID, type="observations", raw=FALSE)
 #       spp_to_plot <- unique(proj_dat$Scientific.name, nmax=input$rec_limit)
        sub_table <- cbind(proj_dat$Scientific.name, proj_dat$Iconic.taxon.name)
    } else {
        user_dat <- get_inat_obs_user(input$projectID)
#       spp_to_plot <- levels(unique(user_dat$scientific_name), nmax=input$rec_limit)
        sub_table <- cbind(as.character(user_dat$scientific_name), as.character(user_dat$iconic_taxon_name))
    }
     
    # Sub_table is a two column table of species and taxonomy
    # sub_table
    tree <- tryCatch(datelife_search(input=sub_table[,1], summary_format="phylo_median"), error = function(e) NA) #, get_spp_from_taxon = TRUE)
    if(inherits(tree, "phylo")){
      index <- match(tree$tip.label, gsub(" ", "_", sub_table[,1]))
      tree$tax <- sub_table[index, 2]
    }
    observe({
      updateSelectInput(session, "clade_tree", choices = c("", unique(tree$tax)))
    })
    
    observeEvent(input$phyloButton, {
      if (!input$clade_tree == ""){
        tree <- ape::drop.tip(dl_tree(), tip = dl_tree()$tip.label[input$clade_tree %in% dl_tree()$tip.label])
      }
    })
    # print(tree)
    tree
  })
  

  
#   dltree <- eventReactive(input$phyloButton,{
#     datelife_search(input=spp_list(), summary_format="phylo_median") #, get_spp_from_taxon = TRUE)
#   })
    # observe({
    #   updateSelectInput(session, "clade_tree", choices = c("", unique(dl_tree()$tax)))
    # })
    # 
    # dl_tree <- eventReactive(input$phyloButton, {
    #   if (!input$clade_tree == ""){
    #     tree <- ape::drop.tip(dl_tree(), tip = dl_tree()$tip.label[input$clade_tree %in% dl_tree()$tip.label])
    #   } else {
    #     tree <- dl_tree()
    #   }
    #   tree
    # })
   
   observe({
      updateSelectInput(session, "taxon_map", choices = c(gsub("_", " ", dl_tree()$tip.label)))
  })

   dltree_height <- reactive({
      max(ape::branching.times(dl_tree()))
  })
  output$tree <- renderPlot({
    p <- ggtree(dl_tree()) + ggtree::geom_tiplab() + 
      coord_cartesian(xlim = c(dltree_height()*0.4,-dltree_height()*1.1), 
                      ylim = c(0,ape::Ntip(dl_tree()))) + theme_tree2()
    p <- revts(p)
    gggeo_scale(p, neg=TRUE) 
  })
  dat <- eventReactive(input$taxonButton, {
    rgbif::occ_search(scientificName= input$taxon_map, return='data', hasCoordinate=TRUE)
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