

library(shiny)
library(Rbvi)
library(ggplot2)
library(dplyr)
library(tidyr)

ui=(fluidPage(
  titlePanel("Biological Value Index calculator"),
  sidebarLayout(
    sidebarPanel(
      fileInput("indata", "Chose a *.csv file to upload",
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )
      ),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Semicolon=";",
                     Comma=",",
                     Tab="\t"),
                   ";")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Table", tableOutput("table")),
        tabPanel("Plot", plotOutput("plot"))
      )
    )
  )
))

options(shiny.maxRequestSize = 1000*1024^2)

# Define server logic required to draw a histogram
server = function(input, output) {
  #Table
   output$table = renderTable({
     inFile = input$indata
     
     if (is.null(inFile)){
       return(NULL)
     }
     
     data = read.csv(inFile$datapath,
                     header = input$header,
                     sep = input$sep,
                     quote = input$quote,
                     row.names = 1)
     
     bvi(data=data, p=0.95, other=T)
   })
   
   #Plot
   output$plot = renderPlot({
     inFile = input$indata
     
     if (is.null(inFile)){
       return(NULL)
     }
     
     data = read.csv(inFile$datapath,
                     header = input$header,
                     sep = input$sep,
                     quote = input$quote,
                     row.names = 1)
     
     plot1=bvi_plot(bvi(data))
     
     plot1+
       theme_bw()+
       scale_fill_brewer(palette="Paired")
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

