pageWithSidebar(
  headerPanel('iNaturalist Tree'),
  sidebarPanel(
#    selectInput('xcol', 'X Variable', names(iris)),
#    selectInput('ycol', 'Y Variable', names(iris),
#                selected=names(iris)[[2]]),
    # 3605 is the id for the calbats project
    numericInput('projectID', 'Project ID', 5062),
    actionButton("goButton", "Go!"),
    selectInput("taxon", "Choose a taxon to map:", choices = ""),
    actionButton("taxonButton", "Go!")
 
#    textAreaInput('taxa', "Taxa (comma delimited; spaces or underscores in binomials are ok) or a Tree (Newick format; make sure to end with a semicolon)",
#                 "Rhea americana, Pterocnemia pennata, Struthio camelus", width = 200, height = "auto")),
  ),
  mainPanel(
    plotOutput('tree'),
    plotOutput('gbif_map')
  )
)