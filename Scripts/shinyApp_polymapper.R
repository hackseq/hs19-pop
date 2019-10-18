library(ggplot2)
library(shiny)
drugs <- c("A", "B", "C", "D", "E") ## all the drugs Veenu is going to give us

ui <- fluidPage(
  ## This is where we get our real time data
  selectizeInput(inputId = 'Drug.names', label = 'Select candidate drug', 
              drugs, multiple=TRUE, options = list(maxItems = 2))
  
  #plotOutput("allGOPlot")
  
)


server <- function(input, output){
  #output$allGOPlot <- renderPlot({
   # selected.GOdataframe <- complete.GO.dataframe[c(unlist(lapply(input$selected.GOterms, 
                                                              #    function(x){which(complete.GO.dataframe$GO.terms== x)}))), ]
    
   # ggplot(selected.GOdataframe, aes(x=adjusted.p.value, y=GO.terms, colour=group)) + 
    #  geom_point(aes(size=no.genes)) +  xlab("adjusted p.value") + ylab("") + facet_grid(. ~ DE) +
     # theme(axis.text.y = element_text(angle = 20, hjust = 1, size = 10))
 # })
  
}

shinyApp(ui=ui, server=server)