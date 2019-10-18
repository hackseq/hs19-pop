setwd("~/R/wd/Projects/hs19-pop/")

library(ggplot2)
library(shiny)
library(dplyr)

drugint <- read.csv("ChChSe-Decagon_polypharmacy.csv")
colnames(drugint) <- c("drug1ID", "drug2ID", "seID", "seName")
drugdict <- read.delim("dictionary_drugs.txt")
drugs <- drugdict$Name ## all the drugs Veenu is going to give us

ui <- fluidPage(
    ## This is where we get our real time data
    selectizeInput(inputId = 'drug.names', label = 'Select candidate drug', 
                   drugs, multiple=TRUE, options = list(maxItems = 3)),
    textOutput("drug.se")
)


server <- function(input, output){
    output$drug.se <- renderText({
        userIDs <- drugdict[drugdict$Name %in% input$drug.names, 1] %>% as.vector()
        if(length(userIDs) >= 2) {
            userIntAB <- drugint[drugint$drug1ID == userIDs[1] & drugint$drug2ID == userIDs[2], 4] %>%
                as.character()
            userIntBA <- drugint[drugint$drug1ID == userIDs[2] & drugint$drug2ID == userIDs[1], 4] %>%
                as.character()
            se <- c(userIntAB, userIntBA)
        }
        if(length(userIDs) >=3) {
            userIntAC <- drugint[drugint$drug1ID == userIDs[1] & drugint$drug2ID == userIDs[3], 4] %>%
                as.character()
            userIntCA <- drugint[drugint$drug1ID == userIDs[3] & drugint$drug2ID == userIDs[1], 4] %>%
                as.character()
            userIntBC <- drugint[drugint$drug1ID == userIDs[2] & drugint$drug2ID == userIDs[3], 4] %>%
                as.character()
            userIntCB <- drugint[drugint$drug1ID == userIDs[3] & drugint$drug2ID == userIDs[2], 4] %>%
                as.character()
            se <- c(se, userIntAC, userIntCA, userIntBC, userIntCB)
        } 
        if(length(se) == 0) {
            "No unintended side effects observed :)"
        } else {
            paste0("The side effects are:", se, collapse = ",")
        }
    })
}

shinyApp(ui=ui, server=server)