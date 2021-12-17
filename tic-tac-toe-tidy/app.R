#rm(list = ls())
library(shiny)
library(tidyverse)
library(tictactoe)
library(ggimage)

get_position <- function(x, y) {
  position = 0
  position = ifelse(0.5 <= x &
                      x < 1.5 & 2.5 <= y & y <= 3.5, 1, position)
  position = ifelse(0.5 <= x &
                      x < 1.5 & 1.5 <= y & y < 2.5, 2, position)
  position = ifelse(0.5 <= x &
                      x < 1.5 & 0.5 <= y & y < 1.5, 3, position)
  position = ifelse(1.5 <= x &
                      x < 2.5 & 2.5 <= y & y <= 3.5, 4, position)
  position = ifelse(1.5 <= x &
                      x < 2.5 & 1.5 <= y & y < 2.5, 5, position)
  position = ifelse(1.5 <= x &
                      x < 2.5 & 0.5 <= y & y < 1.5, 6, position)
  position = ifelse(2.5 <= x &
                      x <= 3.5 & 2.5 <= y & y <= 3.5, 7, position)
  position = ifelse(2.5 <= x &
                      x <= 3.5 & 1.5 <= y & y < 2.5, 8, position)
  position = ifelse(2.5 <= x &
                      x <= 3.5 & 0.5 <= y & y < 1.5, 9, position)
  position
}

# create place for reactive game values
ttt_rv <- reactiveValues()
ttt_rv$position = 0
ttt_rv$game <- ttt_game()
ttt_rv$state = matrix(rep(0, 9), nrow = 3)

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  titlePanel("TIC-TAC-TOE"),
  
  fluidRow(
    column(
      7,
      tags$text(
        "To play the game, select the AI strength (0 for the weakest, 5 for the
        strongest) and click on the desired spot in the grid. The computer will 
        make the next move, then you, and so on. To play again, click RESET.
        To begin click RESET twice."
      )
    ),
    column(3,
           sliderInput(
             "level",
             "AI strength:",
             min = 0,
             max = 5,
             value = 3
           )),
    column(2,
           actionButton("go", "RESET"))
  ),
  plotOutput("plot", click = "plot_click"),
  verbatimTextOutput("gameInfo")
)

server <- function(input, output) {
  observeEvent(input$go, {
    ttt_rv$game <- ttt_game()
    ttt_rv$state <- matrix(rep(0, 9), nrow = 3)
    ttt_rv$position <- 0
  })
  
  output$gameInfo <- renderPrint({
    # player logic
    req(input$plot_click)
    ttt_rv$position <-
      get_position(input$plot_click$x, input$plot_click$y)
    ttt_rv$game$play(ttt_rv$position)
    # check if interactive board match package board
    # cat(ttt_rv$game$show_board())
    # computer logic
    if (ttt_rv$game$nextmover == 2) {
      computer <- ttt_ai(level = input$level)
      position = computer$getmove(ttt_rv$game)
      ttt_rv$game$play(position)
    }
    # game initiation and management
    ttt_rv$state <- ttt_rv$game$state
    if (ttt_rv$game$check_result() == 0) {
      cat("NO MOVE", "\n")
    }
    if (ttt_rv$game$check_result() == 1) {
      cat("?????", "\n")
    }
    if (ttt_rv$game$check_result() == 2) {
      cat("GAME OVER", "\n")
    }
    if (ttt_rv$game$check_win(player = 1)) {
      cat("PLAYER WON")
    }
    if (ttt_rv$game$check_win(player = 2)) {
      cat("COMPUTER WON")
    }
  })
  
  
  dat <- reactive({
    ttt_rv$state %>% cbind(paste0("R", c(1:3))) %>% as.data.frame() %>%
      `colnames<-`(c(paste0("C", c(1:3)), "Row")) %>% gather("Column", "State", -Row) %>%
      mutate(State = as.numeric(State)) %>% mutate(image = if_else(
        State == 2,
        './www/circle.svg',
        if_else(State == 1, './www/cross.svg', NULL)
      ))
  })
  
  output$plot <- renderPlot({
    dat() %>% ggplot() +
      aes(x = Column, y = Row, image = image) +
      geom_image(size = 0.2) +
      scale_y_discrete(limits = rev) +
      geom_hline(yintercept = seq(0.5, 3.5, 1) , color = "#428bca", size = 3) +
      geom_vline(xintercept = seq(0.5, 3.5, 1) , color = "#428bca", size = 3) +
      theme_void() + coord_fixed()
  })
}

shinyApp(ui, server)
