wordlist <- jsonlite::fromJSON(
  txt = paste(readLines("wordlist.json",
                        encoding = "UTF-8"),
              collapse = ""))
#wordlist <- wordlist[,c("Th", "NL", "EN", "PL", "Pre")]
  
shinyServer(function(input, output) {
  
  row <- eventReactive(input$generButton, {
    #t <- c(1:2)
    #l <- "NL"
    wordlistSub <- data.frame()
    for (i  in input$themas) {
      res <- wordlist[sapply(wordlist$Th, function(x) i %in% x), ]
      wordlistSub <- rbind(wordlistSub, res)
    }
    wordlistSub <- wordlistSub[!duplicated(wordlistSub), ]
    wordlistSub <- wordlistSub[wordlistSub$Kn == FALSE, ]
    oneRow <- wordlistSub[sample(c(1:nrow(wordlistSub)),1), ]
    oneRow
    
  })

  count <- eventReactive(input$generButton, {
    wordlistSub <- data.frame()
    for (i  in input$themas) {
      res <- wordlist[sapply(wordlist$Th, function(x) i %in% x), ]
      wordlistSub <- rbind(wordlistSub, res)
    }
    wordlistSub <- wordlistSub[!duplicated(wordlistSub), ]
    paste("Known words:", nrow(wordlistSub[wordlistSub$Kn == TRUE, ]), "of",
          nrow(wordlistSub),sep = " ")
  })
  
  
  check <- eventReactive(input$checkButton, {
    tab <- data.table::as.data.table(row())
    tab <- row()[,c("NL", "EN", "PL", "Ex")]
  #  tab <- data.frame(row())
  #  tab <- row()
    tab
  })

  checkZin <- eventReactive(input$checkButton, {
    tab <- data.table::as.data.table(row())
    tab <- row()[,c("Zi")]
    #  tab <- data.frame(row())
    #  tab <- row()
    tab
  })
  
  output$randRes <- renderText({
    words <- row()[1,input$lang][[1]]
    word <- words[sample(1:length(words), 1)]
    word
  })

  output$score <- renderText({
    langTo   <- c("NL", "EN")[!c("NL", "EN") == input$lang]
    score <- adist(row()[1,langTo][[1]], input$answer)
    score <- paste("Your score:", score)
    score
  })
  
  #output$list <- renderPrint({check()})  
  
  
  output$table <- renderDataTable({
    check() })
    
  output$tableZin <- renderDataTable({
      checkZin()  })
  
  output$count <- renderText({
    count()
  })
  
  })