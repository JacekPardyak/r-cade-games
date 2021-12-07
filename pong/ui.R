
# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Pong r-cade game"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            actionButton("go", "Play"), actionButton("stop", "Stop"),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("pongPlot"),
            sliderInput("paddle",
                        "Paddle position:",
                        min = 0,
                        max = WIDTH - SIZE,
                        value = WIDTH/2),
            verbatimTextOutput("info")
        )
    )
))
