function(input, output, session) {
  dat <- eventReactive(input$goButton,{occ_search(scientificName=input$choices, return='data', hasCoordinate=TRUE)})

  #   dat <- dat  
# proj_dat <- get_inat_obs_project(input$projectID, type="observations", raw=FALSE)
# spp_list <- unique(proj_dat$Scientific.name)
#    spp_list <- c("Rhea americana", "Pterocnemia pennata", "Struthio camelus")
#    spp_list <- c("Hogna carolinensis", "Erethizon dorsatum", "Cottus bairdii", "Ardea alba", "Taricha granulosa", "Branta canadensis", "Ardea herodias", "Lithobates catesbeianus", "Euphagus cyanocephalus", "Ensatina eschscholtzii", "Rhyacotriton kezeri", "Pelecanus erythrorhynchos", "Melanerpes formicivorus", "Sciurus", "Phalacrocorax auritus", "Larus", "Myocastor coypus", "Cervus canadensis roosevelti")
    # code to make list: write(paste(spp_list, collapse = '", "'), file="5062spp_list.txt")

  output$gbif_map <- renderPlot({
    wm <- borders("world", colour="gray50", fill="gray50")
    ggplot() + coord_fixed() + wm + 
      geom_point(data = dat(), aes(x = decimalLongitude, y = decimalLatitude), colour = "darkred", size = 0.5) +
      theme_bw()
  })
}