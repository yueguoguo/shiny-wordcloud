library(shiny)

fluidPage(
  
  # Application title
  
  titlePanel("Solar power prediction"),
  
  sidebarLayout(
    
    # Sidebar with a slider and selection inputs
    
    sidebarPanel(
      dateRangeInput(
        'date_range',
        label='Date range input: yyyy-mm-dd',
        start=as.Date("2013-12-10"), 
        end=as.Date("2016-11-23")
      )
      
    ),
    
    # Show Word Cloud
    
    mainPanel(
      plotOutput("plot")
    )
  )
)