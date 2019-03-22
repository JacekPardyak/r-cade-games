library(shiny)
library(shinydashboard)
library(jsonlite)
library(DT)
sidebar <- dashboardSidebar(sidebarMenu(
  menuItem("Woorden", tabName = "woorden", icon = icon("dashboard")),
  menuItem("Werkwoorden", tabName = "werkwoorden", icon = icon("th"))
))

body <- dashboardBody(tabItems(

# tab item woorden ==== 
  tabItem(tabName = "woorden",
          h2("Nederlandse Woorden"),
# row 1 ====    
fluidRow(
  box(
    width = 2,
    selectInput(
      inputId = "lang1",
      label = "Selecteer de brontaal:",
      choices = NULL,
      selected = c("Engelse taal" = "EN")
    )
  ),
  box(
    width = 2,
    selectInput(
      inputId = "lang2",
      label = "Selecteer de doeltaal:",
      choices = NULL,
      selected = c("Nederlandse taal"= "NL")
    )
  ),
  box(
    width = 1,
    selectInput(
      inputId = "topics",
      label = "De themas:",
      choices  = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
      selected = c(0, 1, 2, 3, 4, 5),
      multiple = TRUE
    )
  ),


  box(
    width = 1,
    selectInput(
      inputId = "statuses",
      label = "De status:",
      choices  = c("Bekende" = TRUE, "Onbekende" = FALSE), 
      selected = c(TRUE),
      multiple = TRUE
    )
  ),
  
  
  box(width = 1,
      tags$b("Vooruitgang:"),
      textOutput(outputId = "word_count")),    
  
  box(width = 1,
      actionButton("go1", "Ga gang"))

),
# row 2 ====
fluidRow(
  box(    width = 2,
          tags$b("Een woord voor u:"),
          h3(textOutput("word"))),
box(    width = 2,
  textInput("your_answer",
              "Uw antwoord:", 
            placeholder = "...")),
box(width = 1,
    tags$b("Uw partituur:"),
    textOutput(outputId = "word_score")),

box(width = 1,
    actionButton("showRow", "Controleer")),
box(width = 1,
    actionButton("showAll", "Zie alles")),
box(width = 1,
    actionButton("save", "Bewaar"))
),


# main panel section ====
mainPanel(
  # present table ========
  DTOutput('x1')

)),





# tab item werkwoorden ==== 
  tabItem(
    tabName = "werkwoorden",
    h2("Nederlandse Werkwoorden"),
    # row 1 ====
    fluidRow(
      box(
        width = 2,
        tags$b("Uw werkwoord:"),
        h4( textOutput(outputId = "test_inf"))
      ),      
      box(
        width = 2,
        tags$b("Uw oefening:"),
        h4( textOutput(outputId = "test_help"))
      ),       
      box(width = 2,
          textInput(inputId = "test_answer",
                    label = "Uw aantwoord:")),
      box(width = 1,
          tags$b("Uw partituur:"),
          textOutput(outputId = "test_score")),   
      
      box(width = 1,
          actionButton("test", "Ga gang"))
#     , box(width = 1,
#          actionButton("control", "Controleer"))
      
    ),    
    fluidRow(
      box(
      width = 3,
     tags$b(h2("Controleer"))
      
)
    ),
    
# row 2 ====    
    fluidRow(

      box(width=2,
          selectizeInput(
            inputId = 'infinitive',
            label = "Selecteer de infinitief:",
            choices = NULL,
            selected = NULL,
            multiple = FALSE
          )),
#      box(
#        width = 3,
#        selectInput(
#          inputId = "time1",
#          label = "Selecteer de werkwoordtijd.",
#          choices = NULL,
#          selected = NULL
#        )
#      ),
      box(
        width = 2,
        selectInput(
          inputId = "time",
          label = "Selecteer de werkwoordtijd:",
          choices = NULL
        )
      ),
      box(
        width = 2,
        selectInput(
          inputId = "number",
          label = "Selecteer het aantal:",
          choices = NULL
        )
      ),
      box(
        width = 2,
        selectInput(
          inputId = "person",
          label = "Selecteer de persoon:",
          choices = NULL
        )
      )
    ),

# row 3 ====
fluidRow(
  box(
    width = 4,
    tags$b("Vorm van het werkwoord:"),
    h4( textOutput(outputId = "verb"))
  ),
  box(
    width = 4,
    tags$b("Een voorbeeld:"),
    h2( textOutput(outputId = "example"))
 )
)
)))
# table output    
#    tableOutput("table")

# Put them together into a dashboardPage
dashboardPage(dashboardHeader(title = "Flashcards"),
              sidebar,
              body)