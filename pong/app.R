#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
HEIGHT = 300
WIDTH = 300 
SIZE = 30

ball <- reactiveValues()

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$head(tags$script(src = "message-handler.js")),
  # Application title
    titlePanel("Pong r-cade game"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            actionButton("go", "Play"), actionButton("stop", "Stop"),  
            h5(strong("Game stats:")),
            verbatimTextOutput("info"),
            h5(strong("More info:")),
            tags$a(href="https://github.com/JacekPardyak/r-cade-games", "Click here!"),
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("pongPlot"),
            sliderInput("paddle",
                        "Paddle position:",
                        min = 0,
                        max = WIDTH - SIZE,
                        value = WIDTH/2,
                        step = 10)
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    session <- reactiveValues()
    #  session$timer <- reactiveTimer(Inf)
    
    observeEvent(input$go,{
        ball$x <- sample(c(1:(WIDTH -1)), 1)
        ball$y <- sample(c(1:(HEIGHT -1)), 1)
        
        ball$dx =  (-1) ^ sample(c(0, 1), 1)
        ball$dy =  (-1) ^ sample(c(0, 1), 1)
        ball$score = 0
        ball$label = ""
        
        session$timer <- reactiveTimer(30)
        observeEvent(session$timer(),{
            forward()
        })
    })
    
    forward <- function(){
        if (ball$x <= 0 | ball$x >= WIDTH){
            ball$dx = -1 * ball$dx
        }
        
        ball$x = ball$x + ball$dx
        ball$x = min(max(ball$x, 0), WIDTH)
        
        if (ball$y >= HEIGHT){
            ball$dy = -1 * ball$dy
        }
        
        if (ball$y <= 0 & ( (ball$x >= input$paddle) & ball$x < (input$paddle + SIZE))){
            ball$dy = -1 * ball$dy
            ball$score <- ball$score + 1
        }
        
        ball$y = ball$y + ball$dy
        ball$y = min(max(ball$y, 0), HEIGHT) 
        
        if (ball$y <= 0 & ( (ball$x < input$paddle) |
                            ball$x > (input$paddle + SIZE))){
          ball$x = WIDTH/2
          ball$y = HEIGHT/2
          ball$label = "GAME OVER"
          session$timer<-reactiveTimer(Inf)
        }
        
        if(ball$y >= HEIGHT | ball$x <= 0 | ball$x >= WIDTH |
           (ball$y <= 0 & ( (ball$x >= input$paddle) & ball$x < (input$paddle + SIZE)))){
          insertUI(selector = "#go",
                   where = "afterEnd",
                   # beep.wav should be in /www of the shiny app
                   ui = tags$audio(src = "microwave_ping_mono.wav", 
                                   type = "audio/wav", autoplay = T, controls = NA, 
                                   style="display:none;"))
        }
        
        if(ball$x == WIDTH/2 & ball$y == HEIGHT/2){
          insertUI(selector = "#go",
                   where = "afterEnd",
                   # beep.wav should be in /www of the shiny app
                   ui = tags$audio(src = "facebook.wav", 
                                   type = "audio/wav", autoplay = T, controls = NA, 
                                   style="display:none;"))
        }
    }
    
    observeEvent(input$stop,{
        session$timer<-reactiveTimer(Inf)
    })
    
    output$pongPlot <- renderPlot({
        par(mar = rep(1, 4), bg = "black")
        plot.new()
        plot.window(xlim = c(0, WIDTH), ylim = c(0, HEIGHT))
        
        # court
        lines(
            x = c(WIDTH, WIDTH, 0, 0),
            y = c(0, HEIGHT, HEIGHT, 0),
            type = "l",
            lwd = 5,
            col = "white"
        )
        # ball
        points(
            x = ball$x, 
            y = ball$y,
            pch = 15,
            cex = 5,
            col = "white"
        )
        # paddle - slider
        lines(
            x = c(input$paddle, input$paddle + SIZE),
            y = c(0, 0),
            type = "l",
            lwd = 5,
            col = "white"
        )
        # text
        text(WIDTH/2, 2 * HEIGHT/3, ball$label, cex=7, col = "white")
    })
    
    output$info <- renderText({
        paste0("x=", ball$x , "\ny=", ball$y,
               "\ndx=", ball$dx , "\ndy=", ball$dy, "\nscore=", ball$score   )
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
