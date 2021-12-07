# Define server logic required to draw a scene

ball <- reactiveValues()

# Assign values for ball center and move
#ball$x <- sample(c(1:(WIDTH -1)), 1)
#ball$y <- sample(c(1:(HEIGHT -1)), 1)

#ball$dx =  (-1) ^ sample(c(0, 1), 1)
#ball$dy =  (-1) ^ sample(c(0, 1), 1)
#ball$label = c("")
#ball$score = 0
  
shinyServer(function(input, output) {
 
  session <- reactiveValues()
#  session$timer <- reactiveTimer(Inf)
  
  observeEvent(input$go,{
    ball$x <- sample(c(1:(WIDTH -1)), 1)
    ball$y <- sample(c(1:(HEIGHT -1)), 1)
    
    ball$dx =  (-1) ^ sample(c(0, 1), 1)
    ball$dy =  (-1) ^ sample(c(0, 1), 1)
    ball$score = 0

    session$timer <- reactiveTimer(30)
    observeEvent(session$timer(),{
      forward()
    })
  })
  
  forward <- function(){
    sound <- 0
      if (ball$x <= 0 | ball$x >= WIDTH){
        ball$dx = -1 * ball$dx
        #sound <- 1
      }
    
        ball$x = ball$x + ball$dx
        ball$x = min(max(ball$x, 0), WIDTH)

        if (ball$y >= HEIGHT){
          ball$dy = -1 * ball$dy
        #  sound <- 1
        }
        
        if (ball$y <= 0 & ( (ball$x >= input$paddle) & ball$x < (input$paddle + SIZE))){
          ball$dy = -1 * ball$dy
          ball$score <- ball$score + 1
          sound <- 1
        }
        
        ball$y = ball$y + ball$dy
        ball$y = min(max(ball$y, 0), HEIGHT) 
        
        if (ball$y <= 0 & ( (ball$x < input$paddle) | ball$x > (input$paddle + SIZE))){
          session$timer<-reactiveTimer(Inf)
        sound <- 8
        }
        
        #ball$y = ball$y + ball$dy
        #ball$y = min(max(ball$y, 0), HEIGHT) 
        #input$paddle, 
       # beep(sound)
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
   #         text(WIDTH/2, HEIGHT - 15, ball$label, cex=5, col = "white")
    })
    
    output$info <- renderText({
        paste0("x=", ball$x , "\ny=", ball$y,
               "\ndx=", ball$dx , "\ndy=", ball$dy, "\nscore=", ball$score   )
    })
    


})



