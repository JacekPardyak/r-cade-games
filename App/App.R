library(shiny)
library(DT)
library(jsonlite)

# user defined functions to load and save data ====
loadData <- function(x) {
 # fromJSON(txt = paste(readLines("wordlist.json",
#                                 encoding = "UTF-8"),
#                       collapse = ""))
  fromJSON(txt = "wordlist.json")
}

saveData <- function(x) {
  text <- toJSON(x, pretty = T)
  writeLines(text, "wordlist.json", useBytes = T)
}

# APPlication section ====
shinyApp(
  # UI section ====
  ui = fluidPage(
    titlePanel("Dutch-English Flash Cards"),
# sidebar section ====    
    sidebarLayout(
      sidebarPanel(
# selection section ====
                selectInput(
          inputId = "lang",
          label = "Choose Source Language:",
          choices = c("NL", "EN", "PL"),
          selected = "EN",
          multiple = FALSE
        ),
        selectInput(
          inputId = "themas",
          label = "Choose Themas:",
          choices  = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
          selected = c(1, 2),
          multiple = TRUE
        ),
        selectInput(
          inputId = "status",
          label = "Choose (un-) knowledge status:",
          choices  = c(TRUE, FALSE),
          selected = c(FALSE),
          multiple = TRUE
        ),
# buttons section ====        
#        actionButton("loadButton", "Load"), 
        actionButton("generButton", "Get"),
        actionButton("checkButton" , "Check"),
        actionButton("saveButton", "Save")
        #,
      ),
# main panel section ====
      mainPanel(
        # present count ========
        h4(textOutput("count")),
        # present word to be translated ========
#        tags$b("Word to be translated:"),
        h4(textOutput("word")),
        # present place to input answer ========
        textInput("answer", "Your answer:", placeholder = "..."),
        # present score ========
        tags$b(textOutput("score")),
        # present table ========
        DTOutput('x1')
      )
    )
  ),
  
  
  # SERVER section ====
  server = function(input, output, session) {
    #    x = loadData()
    wordlist <-  loadData()
    # choose one row
    row <- eventReactive(input$generButton, {
      #t <- c(1:2)
      #l <- "NL"
      wordlistSub <- data.frame()
      for (i  in input$themas) {
        res <- wordlist[sapply(wordlist$Th, function(x)
          i %in% x),]
        wordlistSub <- rbind(wordlistSub, res)
      }
      wordlistSub <- wordlistSub[!duplicated(wordlistSub),]
      wordlistSub <- wordlistSub[wordlistSub$Kn == FALSE,]
      oneRow <- wordlistSub[sample(c(1:nrow(wordlistSub)), 1),]
      oneRow
      
    })
    
    # count known / unknown
    count <- eventReactive(input$generButton, {
      wordlistSub <- data.frame()
      for (i  in input$themas) {
        res <- wordlist[sapply(wordlist$Th, function(x)
          i %in% x),]
        wordlistSub <- rbind(wordlistSub, res)
      }
      wordlistSub <- wordlistSub[!duplicated(wordlistSub),]
      paste("In selection:",
            nrow(wordlistSub[wordlistSub$Kn %in% input$status,]),
            "of",
            nrow(wordlistSub),
            sep = " ")
    })
    # render count
    output$count <- renderText({
      count()
    })
    
    # get the word to be translated
    output$word <- renderText({
      words <- row()[1, input$lang][[1]]
      res <- words[sample(1:length(words), 1)]
      res <- paste("Word to be translated:", res)
      res
    })
    
    # calculate score =========
    output$score <- renderText({
      langTo   <- c("NL", "EN")[!c("NL", "EN") == input$lang]
      score <- adist(row()[1, langTo][[1]], input$answer)
      score <- paste("Your score:", score)
      score
    })
    
    
    
    
    # save changes to file =======
    observeEvent(input$saveButton, {
      saveData(wordlist)
    })
    # load changed data from file =======
    observeEvent(input$loadButton, {
      wordlist <- loadData(x)
    })
    
    
    # render DT table
    output$x1 = renderDT(wordlist,
                         selection = 'none',
                         editable = TRUE)
    
    proxy = dataTableProxy('x1')
    
    observeEvent(input$x1_cell_edit, {
      info = input$x1_cell_edit
      str(info)
      i = info$row
      j = info$col
      v = info$value
      wordlist[i, j] <<- DT::coerceValue(v, wordlist[i, j])
      replaceData(proxy, wordlist, resetPaging = FALSE)  # important
    })
  }
)