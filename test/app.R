library(shiny)
library(beepr)

ui <- fluidPage(
    tags$head(tags$script(src = "message-handler.js")),
    actionButton("dobeep", "Play sound"),
    sliderInput("integer", "Integer:",
                min = 0, max = 10,
                value = 9),
)

server <- function(input, output, session) {
    
    observe(
        {
            if(input$integer == 1){
                insertUI(selector = "#dobeep",
                         where = "afterEnd",
                         # beep.wav should be in /www of the shiny app
                         ui = tags$audio(src = "inst_sounds_microwave_ping_mono.wav", 
                                         type = "audio/wav", autoplay = T, controls = NA, 
                                         style="display:none;"))
                         }
            
        }
    )
    
    observeEvent(input$dobeep, {
        insertUI(selector = "#dobeep",
                 where = "afterEnd",
                 # beep.wav should be in /www of the shiny app
                 ui = tags$audio(src = "inst_sounds_microwave_ping_mono.wav", type = "audio/wav", autoplay = T, controls = NA, style="display:none;")
        )
    })
}

shinyApp(ui, server)