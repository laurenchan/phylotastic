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
#    numericInput('rec_limit', "Maximum Records", 100, min=1, max=1000),
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
    plotOutput('tree'),
    shinycustomloader::withLoader(plotOutput('gbif_map'), type = "html", loader = "pacman")
  )
)