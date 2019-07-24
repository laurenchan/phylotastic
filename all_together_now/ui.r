shinyUI(fluidPage(
  titlePanel("title panel"),
  
  sidebarLayout(position = "left",
         sidebarPanel("sidebar panel",
                numericInput('projectID', 'Project ID', 5062, min=1, max=100000),
                actionButton("goButton", "Go"),
                uiOutput("ui")
  #              uiOutput("ui")
         ),
         mainPanel("main panel",
                fluidRow(
                splitLayout(cellWidths = c("50%", "50%"), plotOutput("tree"), plotOutput("gbif_map"))
                )
        )
  )
)
)