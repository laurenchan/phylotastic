# Lauren is messing with different options.

fluidPage(
  headerPanel('iNaturalist Tree'),
  sidebarPanel(
    # 3605 is the id for the calbats project
    radioButtons("user_or_proj", "Search by:", inline=TRUE,
        choices = list("Project" = 1, 
                   "User" = 2),
        selected = 1),

    textInput('projectID', 'Project or User ID', "pu-vert-zoo"),
    actionButton("goButton", "Go!"),
    
    

    selectInput("taxon", "Choose a taxon to map:", choices = ""),
    actionButton("taxonButton", "Map!"),
 
    
    sliderInput("latitude", "Latitude",
                min = -90, max = 90, value = c(-40,40)),    
    sliderInput("longitude", "Longitude",
                min = -180, max = 180, value = c(-100, 100))    
  ),

  
  mainPanel(
    plotOutput('tree'),
    shinycustomloader::withLoader(plotOutput('gbif_map'), type = "html", loader = "pacman")
  )
)