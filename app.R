## Load essential libraries
require(ggplot2)
require(shiny)
require(shinydashboard)
require(dplyr)
require(imager)
​
## Read in unintended side effect data
#if(!exists("ChChSe-Decagon_polypharmacy.csv")) {R.utils::gunzip("ChChSe-Decagon_polypharmacy.csv.gz")}
drugint <- read.csv("ChChSe-Decagon_polypharmacy.csv")
colnames(drugint) <- c("drug1ID", "drug2ID", "seID", "seName")
## Read in drug dictionary to match compound IDs and drug names
drugdict <- read.csv("/names.csv")
paths <- read.table("path_info.txt", sep = "\t", header = TRUE)
​
### ---------- UI conection -------------- ####
ui <- dashboardPage(
  
  ### Title --------------
  dashboardHeader(title = "PolyMapper"), 
  
  ### Sidebar --------------
  ## This is where we want to add the selective modules for the two different webpages
  dashboardSidebar(
    sidebarMenu(id="menu1",
                menuItem("About", tabName = "about", icon = icon("universal-access")),
                menuItem("PolyMapper", tabName = "polym", icon = icon("capsules")),
                conditionalPanel(
                  condition = "input.menu1 == 'polym'",
                  sidebarMenuOutput("menu")
                )
    )
  ),
  
  #### Body --------------
  ### This is where the main 'body' of the webpage goes
  dashboardBody(
    tabItems(
      ### Body for the About page: 
      tabItem(tabName = "about", 
              p("PolyMapper is a tool that assess polypharmacy risks and side effects based on overlapping pathways and real-time unintended side effects data.")), 
      ### Body for the PolyMapp page:
      tabItem(tabName = "polym", 
              tabBox(
                title = "Details on each drug",
                #color = "teal", 
                #solidHeader = TRUE,
                #collapsible = TRUE,
                # The id lets us use input$tabset1 on the server to find the current tab
                id = "t1.dInfo",
                tabPanel("Drug1", "drug1 info", imageOutput("drugImage1")),
                tabPanel("Drug2", "drug2 info", imageOutput("drugImage2")), 
                tabPanel("Drug3", "drug3 info", imageOutput("drugImage3"))
              ),
              fluidRow(
                box(title = "Plotyly Pathway plot", 
                    status = "warning", plotlyOutput("plotly.1")),
                box(title = "Side effect lists",
                    status = "warning", 
                    side = "right",
                    textOutput("drug.se"))
              )
      )
    )
  )
)
​
### ---------- Server conection -------------- ####
server <- function(input, output) {
  
  ### Sidebar --------------
  ## Tab menu for the About and PolyMapper tool pages
  output$menu <- renderMenu({
    sidebarMenu(
      helpText("Select search term category"),
      selectInput(inputId = 'search.opt', label = 'Select search category',
                  c(DrugNames = "Name", DrugID = "ID"), multiple = F, selectize = T),
      helpText("Select up to three drugs"),
      uiOutput("drugSelect")      
    )
    
  })
  ## Dynamic menu based on the search category user selected
  output$drugSelect <- renderUI({
    selectizeInput(inputId = 'drug', label = 'Select candidate drugs',
                   sort(drugdict[, input$search.opt]), multiple = TRUE, options = list(maxItems = 3))
  })
  
  ### Body --------------
  ## Extracted the side effects based on the drugs selected
  output$drug.se <- renderText({
    userIDs <- drugdict[drugdict$Name %in% input$drug, 1] %>% as.vector()
    ## In the case of 2 drugs
    if(length(userIDs) >= 2) {
      userIntAB <- as.character(drugint[drugint$drug1ID == userIDs[1] & drugint$drug2ID == userIDs[2], 4])
      userIntBA <- as.character(drugint[drugint$drug1ID == userIDs[2] & drugint$drug2ID == userIDs[1], 4])
      
      se <- c(userIntAB, userIntBA)
    }
    ## In the case of 3 drugs
    if(length(userIDs) >=3) {
      userIntAC <- as.character(drugint[drugint$drug1ID == userIDs[1] & drugint$drug2ID == userIDs[3], 4])
      userIntCA <- as.character(drugint[drugint$drug1ID == userIDs[3] & drugint$drug2ID == userIDs[1], 4])
      userIntBC <- as.character(drugint[drugint$drug1ID == userIDs[2] & drugint$drug2ID == userIDs[3], 4])
      userIntCB <- as.character(drugint[drugint$drug1ID == userIDs[3] & drugint$drug2ID == userIDs[2], 4])
      se <- c(se, userIntAC, userIntCA, userIntBC, userIntCB)
    }
    ## Print out a list of side effects
    if (!exists("se")) {
      "Please select drug candidates"
    } else if (length(se) == 0) {
      "No unintended side effects observed :)"
    } else {
      paste0(se, collapse = ", ")
    }
  })
  output$drugImage1 <- renderPlot({
    userIDs <- drugdict[drugdict$Name %in% input$drug, 1] %>% as.vector()
    img <- paste0("/home/paolaap/Documents/UBC/Projects/hackseq19/Drugs/", userIDs[1], ".jpg")
    #list(src = img, height = 240, width = 300)
    plot(load.image(img), axes = FALSE)
  })
  output$drugImage2 <- renderPlot({
    userIDs <- drugdict[drugdict$Name %in% input$drug, 1] %>% as.vector()
    img <- paste0("/home/paolaap/Documents/UBC/Projects/hackseq19/Drugs/", userIDs[2], ".jpg")
    plot(load.image(img), axes = FALSE)
  })
  output$drugImage3 <- renderPlot({
    userIDs <- drugdict[drugdict$Name %in% input$drug, 1] %>% as.vector()
    img <- paste0("/home/paolaap/Documents/UBC/Projects/hackseq19/Drugs/", userIDs[3], ".jpg")
    plot(load.image(img), axes = FALSE)
  })
  
  output$plotly.1 <- renderPlotly({
    ## so we translate whatever search option the user is using to their CIDs
    drugCIDs <- drugdict[drugdict[, input$search.opt] %in% input$drug,1]
    drugPaths <- paths[paths$drugID %in% drugCIDs,]
    druggy <- as.data.frame(summary(as.factor(drugPaths$paths)))
    names(druggy) <- c( "Interaction")
​
   plot_ly(x = druggy$Interaction, y = row.names(druggy), type = 'bar', orientation = 'h')%>%
      layout(title = 'Shared pathways',
             xaxis = list(title = 'Likelihood of interaction [1-3]'),
             yaxis = list(title = 'Pathways'))
  
             
  })
  
}
​
### ---------- Shiny App -------------- ####
shinyApp(ui = ui, server = server)
