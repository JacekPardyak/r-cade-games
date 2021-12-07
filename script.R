library(shiny)
library(tidyverse)
runGitHub(repo = 'r-cade-games', username = 'JacekPardyak', subdir = 'pong')



# embed tiktok movie in markdown document
remotes::install_github("gadenbuie/tiktokrmd")
library(tiktokrmd)

# plain markdown version
"https://www.tiktok.com/@pl.in.nl/video/7039045605427105029" %>% 
  tiktok_embed() %>% tiktok_md()


# Or as HTML without the full TikTok embedded player shenanigans
"https://www.tiktok.com/@pl.in.nl/video/7039045605427105029" %>% 
  tiktok_embed() %>% tiktok_html(include_player = FALSE)

library(shiny)
library(beepr)

ui <- fluidPage(
  tags$head(tags$script(src = "message-handler.js")),
  actionButton("dobeep", "Play sound")
)

server <- function(input, output, session) {
  observeEvent(input$dobeep, {
    insertUI(selector = "#dobeep",
             where = "afterEnd",
             # beep.wav should be in /www of the shiny app
             ui = tags$audio(src = "inst_sounds_microwave_ping_mono.wav", type = "audio/wav", autoplay = T, controls = NA, style="display:none;")
    )
  })
}

shinyApp(ui, server)



sounds <- c(ping = "microwave_ping_mono.wav",
            coin = "smb_coin.wav",
            fanfare = "victory_fanfare_mono.wav",
            complete = "work_complete.wav",
            treasure = "new_item.wav",
            ready = "ready_master.wav",
            shotgun = "shotgun.wav",
            mario = "smb_stage_clear.wav",
            wilhelm = "wilhelm.wav",
            facebook = "facebook.wav",
            sword = "sword.wav")

