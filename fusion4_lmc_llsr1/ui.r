# This version:
# accepts poject names with upper case and spaces instead of hyphens
# plots the whole tree for all species found 

# Still to do:
# list the species that do not appear on tree, maybe on a second tab

fluidPage(
  headerPanel('iNaturalist Project Tree and Map Generator'),
  # write a little description here:
  h4("Welcome!"),
  p("In here, you can search an iNaturalist project by name or number ID, and get
    a tree (dated relative to geologic time) of species registered in the iNaturalist project. 
    You can also map other registered occurrences through time and space of the species in the tree.", span(" 
    The tree with branch lengths proportional to geologic time is 
    obtained with the Datelife software, and occurrence data points are retrieved 
    from the Global Biodiversity Information Facility.", style = "color:gray")),
    br(), 
  sidebarPanel(width=3,
    # 3605 is the id for the calbats project
    radioButtons("user_or_proj", "Search by:", inline=TRUE,
        choices = list("Project" = 1, "User" = 2),
        selected = 1),

    textInput('projectID', 'Project/user ID (name or number):', "san francisco community gardens"),
    actionButton("goButton", "Get species and tree!"),
    
    br(), br(),
    
    selectInput("clade_tree", "Subset the tree by clade:", ""),
    # actionButton("phyloButton", "Give me the tree again!"), # we do not really need a button here, because the act of choosing takes some time and it will not react util th euser clicks on a clade name
    
    br(), br(),
    
    selectInput("taxon_map", "Choose a taxon to map:", choices = ""),
    actionButton("taxonButton", "Map species!"),
    
    br(), br(),
    
 
# Sliders for zooming map    
    sliderInput("latitude", "Latitude",
                min = -90, max = 90, value = c(-90,90)),    
    sliderInput("longitude", "Longitude",
                min = -180, max = 180, value = c(-180, 180))    
  ),

  
  mainPanel(
#    print('inattext'),
    shinycustomloader::withLoader(plotOutput('gbif_map'), type = "html", loader = "pacman"),
    shinycustomloader::withLoader(plotOutput('tree'), type = "html", loader = "pacman")
  )
)