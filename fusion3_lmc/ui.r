# Lauren is messing with different options.

pageWithSidebar(
  headerPanel('iNaturalist Tree'),
  sidebarPanel(
    # 3605 is the id for the calbats project
    radioButtons("user_or_proj", "Search by:", inline=TRUE,
        choices = list("Project" = 1, 
                   "User" = 2),
        selected = 1),

    textInput('projectID', 'User or Project ID', "pu-vert-zoo"),
    actionButton("goButton", "Go!"),

    selectInput("taxon", "Choose a taxon to map:", choices = ""),
    actionButton("taxonButton", "Map!")
 
#    textAreaInput('taxa', "Taxa (comma delimited; spaces or underscores in binomials are ok) or a Tree (Newick format; make sure to end with a semicolon)",
#                 "Rhea americana, Pterocnemia pennata, Struthio camelus", width = 200, height = "auto")),
  ),
  mainPanel(
    plotOutput('tree'),
    shinycustomloader::withLoader(plotOutput('gbif_map'), type = "html", loader = "pacman")
  )
)