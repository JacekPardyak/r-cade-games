library(shiny)

shinyUI(fluidPage(
  titlePanel("Nederlands Flash Cards"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "lang", 
                  label = "Language:",
                  choices = c("NL", "EN" ),
                  selected = "EN",
                  multiple = FALSE),
      selectInput(inputId = "themas", 
                  label = "Themas:",
                  choices  = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
                  selected = c(1, 2, 3, 4, 5, 6),
                  multiple = TRUE),
      actionButton("generButton", "Start"),
      actionButton("checkButton", "Check")
    ),
    
    mainPanel(
#      tags$b("# Words to be learned / already learned:"),
      h4(textOutput("count")),
      
            tags$b("Word to be translated:"),
      h4(textOutput("randRes")),
      textInput("answer", "Your answer:", placeholder = "..."),
#      checkboxInput("somevalue", "Known word", FALSE),
#      tags$b(textOutput("score")),
      h4(textOutput("score")),
 #     tags$b(paste("Your score:", textOutput("score"))),
      tags$b("Datails:"),
      dataTableOutput("table"),
      dataTableOutput("tableZin")

     #     tableOutput("table")
      
    )
  )
)
)