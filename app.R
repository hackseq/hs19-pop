require(ggplot2)
require(shiny)
require(shinydashboard)
require(dplyr)

#if(!exists("ChChSe-Decagon_polypharmacy.csv")) {R.utils::gunzip("ChChSe-Decagon_polypharmacy.csv.gz")}
drugint <- read.csv("ChChSe-Decagon_polypharmacy.csv")
colnames(drugint) <- c("drug1ID", "drug2ID", "seID", "seName")
drugdict <- read.csv("names.csv")
# drugs <- drugdict$Name ## all the drugs Veenu is going to give us
# drugID <- drugdict$ID 

### ---------- UI conection -------------- ####
ui <- dashboardPage(
    
    ### Title --------------
    dashboardHeader(title = "PolyMapper"), 
    
    ### Sidebar --------------
    ## This is where we want to add the selective modules for the two different webpages
    dashboardSidebar(
        sidebarMenuOutput("menu")
    ),
    
    #### Body --------------
    ### This is where the main 'body' of the webpage goes
    dashboardBody(
        tabItems(
            ### Body for the About page: 
            tabItem(tabName = "about", p("PolyMapper is a tool that assess polypharmacy risks and side effects based on overlapping pathways and real-time unintended side effects data.")), 
            ### Body for the PolyMapp page:
            tabItem(tabName = "polym", p(verbatimTextOutput("drug.se")))
        )
    )
    #verbatimTextOutput("drug.se"))
)

### ---------- Server conection -------------- ####
server <- function(input, output) {
    output$menu <- renderMenu({
        sidebarMenu(
            menuItem("About", tabName = "about", icon = icon("universal-access")),
            menuItem("PolyMapper", tabName = "polym", icon = icon("capsules")),
                helpText("Select search term category"),
                selectInput(inputId = 'search.opt', label = 'Select search category',
                            c(DrugNames = "Name", DrugID = "ID"), multiple = F, selectize = T),
                helpText("Select up to three drugs"),
                uiOutput("drugSelect")
        )
    })

    output$drugSelect <- renderUI({
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
