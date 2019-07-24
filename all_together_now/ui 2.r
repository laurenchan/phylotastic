pageWithSidebar(
  headerPanel('iNaturalist Tree'),
  sidebarPanel(
#    selectInput('xcol', 'X Variable', names(iris)),
#    selectInput('ycol', 'Y Variable', names(iris),
#                selected=names(iris)[[2]]),
    numericInput('projectID', 'Project ID', 5062, min=1, max=10000),
    actionButton("goButton", "Go!")
 
#    textAreaInput('taxa', "Taxa (comma delimited; spaces or underscores in binomials are ok) or a Tree (Newick format; make sure to end with a semicolon)",
#                 "Rhea americana, Pterocnemia pennata, Struthio camelus", width = 200, height = "auto")),
  ),
  mainPanel(
    plotOutput('tree')
  )
)