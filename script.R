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
