function(input, output, session) {

# Pull species list and taxonomy, construct tree with datelife, and store spp taxonomy in tree as $tax
   dl_tree <- eventReactive(input$goButton, {
    if (input$user_or_proj == "1"){
        project_name <- tolower(gsub(" ", "-", input$projectID))
        proj_dat <- get_inat_obs_project(project_name, type="observations", raw=FALSE)
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
    # eventReactive(input$phyloButton, {
    #   if (input$clade_tree != ""){
    #     tree <- ape::drop.tip(dl_tree(), tip = dl_tree()$tip.label[input$clade_tree %in% dl_tree()$tip.label])
    #   }
    # })
    # print(tree)
    tree$tip.label <- gsub("_", " ", tree$tip.label)
    tree
  })
   
    eventReactive(input$phyloButton, {
      if (input$clade_tree != ""){
        tree <- ape::drop.tip(dl_tree(), tip = dl_tree()$tip.label[input$clade_tree %in% dl_tree()$tip.label])
      }
    })

   
   observe({
      updateSelectInput(session, "taxon_map", choices = c(gsub("_", " ", dl_tree()$tip.label)))
  })

   dltree_height <- reactive({
      max(ape::branching.times(dl_tree()))
  })
  output$tree <- renderPlot({
    # how to figure breaks out smartly-ish
    # bbs <- 
    p <- ggtree(dl_tree()) + ggtree::geom_tiplab(label = dl_tree()$tip.label, fontface = "italic") + 
      # scale_x_continuous(breaks = sort(seq(0, round(dltree_height()*1.1), bbs)*-1), 
      #                    labels  = abs(sort(seq(0, round(dltree_height()*1.1), bbs)*-1))) +
      coord_cartesian(xlim = c(dltree_height()*0.4,-dltree_height()*1.1), 
                      ylim = c(0,ape::Ntip(dl_tree()))) + theme_tree2()
    p <- revts(p)
    gggeo_scale(p, neg=TRUE) 
    # box("plot", col = "red")
  }, height = function(){
               dl_tree() %>%
               tree_plot_height()
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