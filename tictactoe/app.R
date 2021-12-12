#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
if (!require("sets")) install.packages("sets")
library(sets)
if (!require("tictactoe")) install.packages("tictactoe")
library(tictactoe)
if (!require("plot.matrix")) install.packages("plot.matrix")
library(plot.matrix)
library("png")
circle <- readPNG("./www/circle.png")
cross   <- readPNG("./www/cross.png")

# I don't know if mapping of cartesian point to board position can be written shorter
#  |A|B|C
# S|
# R|
# P|
A = interval( 0.5, 1.5, "[)")
B = interval( 1.5, 2.5, "[)")
C = interval( 2.5, 3.5, "[]")

S = interval( 0.5, 1.5, "[)")
R = interval( 1.5, 2.5, "[)")
P = interval( 2.5, 3.5, "[]")
get_position <- function(p, q){
    x = interval(p, p, "[]")
    y = interval(q, q, "[]")
    position = 0
    position = ifelse(interval_intersection(A, x) == x & interval_intersection(P, y) == y, 1, position)
    position = ifelse(interval_intersection(A, x) == x & interval_intersection(R, y) == y, 2, position)
    position = ifelse(interval_intersection(A, x) == x & interval_intersection(S, y) == y, 3, position)
    position = ifelse(interval_intersection(B, x) == x & interval_intersection(P, y) == y, 4, position)
    position = ifelse(interval_intersection(B, x) == x & interval_intersection(R, y) == y, 5, position)
    position = ifelse(interval_intersection(B, x) == x & interval_intersection(S, y) == y, 6, position)
    position = ifelse(interval_intersection(C, x) == x & interval_intersection(P, y) == y, 7, position)
    position = ifelse(interval_intersection(C, x) == x & interval_intersection(R, y) == y, 8, position)
    position = ifelse(interval_intersection(C, x) == x & interval_intersection(S, y) == y, 9, position)
    position
    }

# create place for reactive game values
ttt_rv <- reactiveValues()
ttt_rv$position = 0
ttt_rv$game <- ttt_game()
ttt_rv$state = matrix(rep(0, 9), nrow = 3)


# Define UI for application that draws a histogram
ui <- fluidPage(
   # titlePanel("Tic-Tac-Toe Game"),
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            plotOutput("gamePlot", click = "plot_click") ,
            verbatimTextOutput("gameInfo"),
            fluidRow(splitLayout(  style = "border: 1px solid silver;",
                                   cellWidths = 200,
                                   cellArgs = list(style = "padding: 20px"),
            sliderInput("level", "AI strength:",
                        min = 0, max = 5,
                        value = 3),
            radioButtons("mode", "Interface mode:",
                         c("Modern" = "modern",
                           "Classic" = "classic")))),
            actionButton("go", "Reset"),
            width = 5),
        mainPanel(
            #empty
             ))
    )

# Define server logic required to draw a histogram
server <- function(input, output) {
    observeEvent(input$go,{
    #    ttt_rv$position = 0
        ttt_rv$game <- ttt_game()
        ttt_rv$state = matrix(rep(0, 9), nrow = 3)
    })
    
    output$gameInfo <- renderPrint({
        # player logic
        req(input$plot_click)
        ttt_rv$position <- get_position(input$plot_click$x, input$plot_click$y)
        ttt_rv$game$play(ttt_rv$position)
        # check if interactive board match package board
        cat(ttt_rv$game$show_board())
        # computer logic
        if (ttt_rv$game$nextmover == 2) {
            computer <- ttt_ai(level = input$level)
            position = computer$getmove(ttt_rv$game)
            ttt_rv$game$play(position)
        }
        # game initiation and management
        ttt_rv$state <- ttt_rv$game$state
        if (ttt_rv$game$check_result() == 0) {cat("TIE", "\n")}
        if (ttt_rv$game$check_result() == 2) {cat("GAME OVER", "\n")}
        if (ttt_rv$game$check_win(player = 1)) {cat("PLAYER WON")}
        if (ttt_rv$game$check_win(player = 2)) {cat("COMPUTER WON")
        }
     })

     output$gamePlot <- renderPlot({
        state <- ttt_rv$state
        state[state == 0] <- 'board'
        state[state == 1] <- 'player'
        state[state == 2] <- 'computer'
        par(mar=c(5.1, 4.1, 4.1, 5.1)) # adapt margins
        
        if(input$mode == 'modern')
        plot(state, col = colorRampPalette(c("grey", "white", "black")),
             axis.col = NULL , axis.row = NULL,
             xlab = " ", ylab = " ", main = "Tic-Tac-Toe")
        if(input$mode == 'classic') {
            res <- plot(state, col = colorRampPalette(c("#FFFFFF", "#FFFFFE", "#FFFFFD")),
                        axis.col = NULL , axis.row = NULL,
                        xlab = " ", ylab = " ", main = "Tic-Tac-Toe", key = NULL)
            for (i in c(1:length(res$cell.polygon))) {
                args <- res$cell.polygon[[i]]
                if (args$col == "#FFFFFE") {
                    
                    rasterImage(circle, args$x[1], args$y[1], args$x[3], args$y[2])
                } else {
                    if (args$col == "#FFFFFD") {
                        rasterImage(cross, args$x[1], args$y[1], args$x[3], args$y[2])
                    }
                }
            }
            }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
