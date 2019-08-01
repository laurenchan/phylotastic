# Lauren is messing with different options.

fluidPage(
  headerPanel('iNaturalist Projects Tree and Map Generator'),
  sidebarPanel(width=3,
    # 3605 is the id for the calbats project
    radioButtons("user_or_proj", "Search by:", inline=TRUE,
        choices = list("Project" = 1, "User" = 2),
        selected = 1),

    textInput('projectID', 'ID (project or user):', "calbats"),
    actionButton("goButton", "Get everything!"),
    
    br(), br(),
    
    selectInput("clade_tree", "Choose clade for phylogeny", ""),
    actionButton("phyloButton", "Replot the Tree!"),


    selectInput("taxon_map", "Choose a taxon to map:", choices = ""),
    actionButton("taxonButton", "Map!"),
 
# Sliders for zooming map    
    sliderInput("latitude", "Latitude",
                min = -90, max = 90, value = c(-90,90)),    
    sliderInput("longitude", "Longitude",
                min = -180, max = 180, value = c(-180, 180))    
  ),

  
  mainPanel(
#    print('inattext'),
    shinycustomloader::withLoader(plotOutput('tree'), type = "html", loader = "pacman"),
    shinycustomloader::withLoader(plotOutput('gbif_map'), type = "html", loader = "pacman")
  )
)