# Lauren is messing with different options.

fluidPage(
  headerPanel('iNaturalist Tree'),
  sidebarPanel(width=3,
    # 3605 is the id for the calbats project
    radioButtons("user_or_proj", "Search by:", inline=TRUE,
        choices = list("Project" = 1, 
                   "User" = 2),
        selected = 1),

    textInput('projectID', 'Project or User ID', "calbats"),
    actionButton("goButton", "Get iNaturalist Records!"),
    
    br (), br(),
    
    selectInput("clade", "Choose clade for phylogeny", ""),
    actionButton("phyloButton", "Plot the Tree!"),


    selectInput("taxon", "Choose a taxon to map:", choices = ""),
    actionButton("taxonButton", "Map!"),
 
# Sliders for zooming map    
    sliderInput("latitude", "Latitude",
                min = -90, max = 90, value = c(-90,90)),    
    sliderInput("longitude", "Longitude",
                min = -180, max = 180, value = c(-180, 180))    
  ),

  
  mainPanel(
#    print('inattext'),
    shinycustomloader::withLoader(plotOutput('tree'), type = "html", loader = "dnaspin"),
    shinycustomloader::withLoader(plotOutput('gbif_map'), type = "html", loader = "pacman")
  )
)