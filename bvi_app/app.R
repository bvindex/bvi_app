

library(shiny)
library(Rbvi)
library(ggplot2)
library(dplyr)
library(tidyr)

ui=fluidPage(
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(fileInput(inputId="indata",
                           label="Choose a file to upload",
                           accept = c(".xslx",
                                      ".csv",
                                      ".xls"))),
    tabsetPanel(tabPanel("Table",
                         mainPanel(tableOutput("table"))),
              tabPanel("Plot",
                       mainPanel(plotOutput("plot")))
              )
    )
  )

# Define server logic required to draw a histogram
server = function(input, output) {
  #Table
   output$table = renderTable({
     inFile = input$indata
     
     if (is.null(inFile)){
       return(NULL)
     }
     
     data=read.csv(inFile$datapath, row.names=1, sep=";")
     bvi(data=data, p=0.95, other=T)
   })
   
   #Plot
   output$plot = renderPlot({
     inFile = input$indata
     
     if (is.null(inFile)){
       return(NULL)
     }
     
     data=read.csv(inFile$datapath, row.names=1, sep=";")
     bvi_plot(bvi(data))
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

