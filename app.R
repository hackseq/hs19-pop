require(ggplot2)
require(shiny)
require(dplyr)
library(shiny)

#if(!exists("ChChSe-Decagon_polypharmacy.csv")) {R.utils::gunzip("ChChSe-Decagon_polypharmacy.csv.gz")}
drugint <- read.csv("ChChSe-Decagon_polypharmacy.csv")
colnames(drugint) <- c("drug1ID", "drug2ID", "seID", "seName")
drugdict <- read.csv("names.csv")
# drugs <- drugdict$Name ## all the drugs Veenu is going to give us
# drugID <- drugdict$ID 

ui <- fluidPage(
  mainPanel(
  tabsetPanel(type = "tabs",
          tabPanel("About", verbatimTextOutput("summary")),
          tabPanel("Summary", verbatimTextOutput("summary"))
          )
    ),
    ## This is where we get our real time data
    selectInput(inputId = 'search.opt', label = 'Select search category', 
                c(DrugNames = "Name", DrugID = "ID"), multiple = F, selectize = T),
    # conditionalPanel(condition = "input.search.opt == 'drug_names'",
    #                  selectizeInput(inputId = 'drug.names', label = 'Select candidate drugs', 
    #                                 drugs, multiple = TRUE, options = list(maxItems = 3))),
    # conditionalPanel(condition = "input.search.opt == 'compound_ID'",
    #                  selectizeInput(inputId = 'drug.ID', label = 'Select candidate drugs', 
    #                                 drugID, multiple = TRUE, options = list(maxItems = 3))),
    uiOutput("menu"),
    verbatimTextOutput("drug.se")
)

server <- function(input, output){
    output$menu <- renderUI({
        selectizeInput(inputId = 'drug', label = 'Select candidate drugs', 
                       sort(drugdict[, input$search.opt]), multiple = TRUE, options = list(maxItems = 3))
    })
    output$drug.se <- renderPrint({
        userIDs <- drugdict[drugdict$Name %in% input$drug, 1] %>% as.vector()
        if(length(userIDs) >= 2) {
            userIntAB <- as.character(drugint[drugint$drug1ID == userIDs[1] & drugint$drug2ID == userIDs[2], 4])
            userIntBA <- as.character(drugint[drugint$drug1ID == userIDs[2] & drugint$drug2ID == userIDs[1], 4])

            se <- c(userIntAB, userIntBA)
        }
        if(length(userIDs) >=3) {
            userIntAC <- as.character(drugint[drugint$drug1ID == userIDs[1] & drugint$drug2ID == userIDs[3], 4])
            userIntCA <- as.character(drugint[drugint$drug1ID == userIDs[3] & drugint$drug2ID == userIDs[1], 4])
            userIntBC <- as.character(drugint[drugint$drug1ID == userIDs[2] & drugint$drug2ID == userIDs[3], 4])
            userIntCB <- as.character(drugint[drugint$drug1ID == userIDs[3] & drugint$drug2ID == userIDs[2], 4])

            se <- c(se, userIntAC, userIntCA, userIntBC, userIntCB)
            #se <- cat(se, sep = "\n")
        } 
        if (!exists("se")) {
            "Please select drug candidates"
        } else if (length(se) == 0) {
            "No unintended side effects observed :)"
        } else {
            paste(se, sep = "\n")
        }
    })
}

shinyApp(ui = ui, server = server)