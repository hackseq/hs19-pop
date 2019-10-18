require(ggplot2)
require(shiny)
require(dplyr)

#if(!exists("ChChSe-Decagon_polypharmacy.csv")) {R.utils::gunzip("ChChSe-Decagon_polypharmacy.csv.gz")}
drugint <- read.csv("ChChSe-Decagon_polypharmacy.csv")
colnames(drugint) <- c("drug1ID", "drug2ID", "seID", "seName")
drugdict <- read.delim("dictionary_drugs.txt")
drugs <- drugdict$Name ## all the drugs Veenu is going to give us

ui <- fluidPage(
    ## This is where we get our real time data
    selectizeInput(inputId = 'drug.names', label = 'Select candidate drug', 
                   drugs, multiple=TRUE, options = list(maxItems = 3)),
    verbatimTextOutput("drug.se")
)

server <- function(input, output){
    output$drug.se <- renderPrint({
        userIDs <- drugdict[drugdict$Name %in% input$drug.names, 1] %>% as.vector()
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
        if(length(se) == 0) {
            "No unintended side effects observed :)"
        } else {
            paste(se, sep = "\n")
        }
    })
}

shinyApp(ui=ui, server=server)
