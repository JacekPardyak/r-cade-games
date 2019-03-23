words <- fromJSON(txt = "./data/woordenlijst.json")
verbs <- fromJSON(txt = "./data/werkwoorden.json")

function(input, output, session) { 
  # INF - infinitief: werken, lezen
  # OTT - onvoltooid tegenwoordige tijd: ik werk, ik lees
  # OVT - onvoltooid verleden tijd: ik werkte, ik las
  # VTT - voltooid tegenwoordige tijd: ik heb gewerkt, ik heb gelezen
  #voltooid verleden tijd (vvt): ik had gewerkt, ik had gelezen
  #onvoltooid tegenwoordige toekomende tijd (ottt): ik zal werken, ik zal lezen
  #voltooid tegenwoordige toekomende tijd (vttt): ik zal gewerkt hebben, ik zal gelezen hebben
  #onvoltooid verleden toekomende tijd (ovtt): ik zou werken, ik zou lezen
  #voltooid verleden toekomende tijd (vvtt): ik zou gewerkt hebben, ik zou gelezen hebben
 

### all words tab ====
# languages ====  

  observe({
    langs <- c("Engelse taal" = "EN",
               "Nederlandse taal"   = "NL",
               "Poolse taal"  = "PL")
    
    updateSelectInput(
      session = session,
      inputId = "lang1",
      choices = langs,
      selected = input$lang1
    )
    
    updateSelectInput(
      session = session,
      inputId = "lang2",
      choices = langs[langs != input$lang1] ,
      selected = input$lang2
    )
    
  })    
  
# random row index ==========
  
  word_row <- eventReactive(input$go1,{
            wordsSub1 <- data.frame()
            for (status  in input$statuses) {
              res <- words[sapply(words$ST, function(x)
                status %in% x),]
              wordsSub1 <- rbind(wordsSub1, res)}  
            
            wordsSub2 <- data.frame()
            for (topic  in input$topics) {
              res <- wordsSub1[sapply(wordsSub1$TH, function(x)
                topic %in% x),]
            wordsSub2 <- rbind(wordsSub2, res)}             
            
            index = sample(1:nrow(wordsSub2), 1)
            wordsSub2[index,]
                       })
  # get word ====
  output$word <- renderText({
    index <- length(word_row()[, input$lang1][[1]])
    word_row()[, input$lang1][[1]][sample(1: index, 1)]
    })  
  

  
  
  # calculate score =========
  output$word_score <- renderText({
    adist(input$your_answer, word_row()[, input$lang2][[1]])
    })
  

  # get count for known/unknown ====
  output$word_count <- renderText({ 
    wordsSub <- data.frame()
    for (topic  in input$topics) {
      res <- words[sapply(words$TH, function(x)
        topic %in% x),]
      wordsSub <- rbind(wordsSub, res)}
    paste(nrow(wordsSub[wordsSub$ST == "TRUE",]), 
          "/",
          nrow(wordsSub))})
    
 
  # render full DT table ======
  # observeEvent(input$showAll, { 
  # output$x1 = renderDT(
  #   expr = datatable(
  #     data = words,
  #     rownames = FALSE,
  #     colnames <- c("Thema" = 1, "NL"= 2, "EN"= 3,
  #                    "PL"= 4, "Status"= 5, "Extra"= 6,
  #                                    "Voorbeeld"= 7),
  #     selection = 'none',
  #     editable = TRUE))
  # })

  observeEvent(input$showAll, { 
    output$x1 = renderDT( words,
        rownames = FALSE,
        colnames <- c("Thema" = 1, "NL"= 2, "EN"= 3,
                      "PL"= 4, "Status"= 5, "Extra"= 6,
                      "Voorbeeld"= 7),
        selection = 'none',
        editable = TRUE)
  })
  
  # render empty DT table for start
  observeEvent(input$go1, {  
    output$x1 = renderDT(words[rownames(NULL),],
                         selection = 'none',
                         editable = FALSE,
                         rownames = FALSE,
                         colnames <- c("Thema" = 1, "NL"= 2, "EN"= 3,
                                       "PL"= 4, "Status"= 5, "Extra"= 6,
                                       "Voorbeeld"= 7))
  })

  # render DT table with answer =======
  observeEvent(input$showRow, {
    output$x1 = renderDT(words[rownames(word_row()),],
                         selection = 'none',
                         editable = FALSE,
                         rownames = FALSE,
                         colnames <- c("Thema" = 1, "NL"= 2, "EN"= 3,
                                       "PL"= 4, "Status"= 5, "Extra"= 6,
                                       "Voorbeeld"= 7))
    })
  # update changes
  proxy = dataTableProxy('x1')
  observeEvent(input$x1_cell_edit, {
    info = input$x1_cell_edit
    str(info)
    i = info$row
    j = info$col + 1
    v = info$value
    words[i, j] <<- DT::coerceValue(v, words[i, j])
    replaceData(proxy, words, resetPaging = FALSE)  # important
  }) 

# save changes  
  observeEvent(input$save, {
    text <- toJSON(words, pretty = T)
    writeLines(text, "woordenlijst.json", useBytes = T)
  })  
  
### werkwoorden tab ====  
  dict <- data.frame(times = c(rep("OTT", 6),
                               rep("OVT", 6),
                               rep("VTT", 6)),
                     numbers = rep(
                       c(c(rep("SIN",3)),
                         c(rep("PLU",3))), 3),
                     persons = rep(c("PE1", "PE2","PE3"), 6),
                     helps = c(
                       paste(c("Ik", "Jij", "Hij", "Wij", "Jullie", "Zij"), "(nu)", sep = " "),
                       paste(c("Ik", "Jij", "Hij", "Wij", "Jullie", "Zij"), "(vroeger)", sep = " "),
                       paste(c("Ik", "Jij", "Hij", "Wij", "Jullie", "Zij"), "(altijd)", sep = " ")))  
  
# update infinitive, time, number & person  ======== 
  
  updateSelectizeInput(  session = session,
                         inputId = 'infinitive',
                         choices = verbs$INF,
                         server = TRUE)
  updateSelectizeInput(  session = session,
                         inputId = 'time',
                         choices = c("Onvoltooid Tegenwoordige Tijd" = "OTT",
                                     "Onvoltooid Verleden Tijd" = "OVT", 
                                     "Voltooid Tegenwoordige Tijd" = "VTT") ,
                         server = TRUE)
  updateSelectizeInput(  session = session,
                         inputId = "number",
                         choices = c("Enkelvoud"= "SIN", "Meervoud" = "PLU"),
                         server = TRUE)
  updateSelectizeInput(  session = session,
                         inputId = "person",
                         choices = c("Eerste persoon" = "PE1", "Tweede persoon" = "PE2", "Derde persoon" = "PE3"),
                         server = TRUE)
  
  

# get inflected verb form ====
output$verb <- renderText({
  temp <- verbs[verbs$INF == input$infinitive , input$time][,input$number][,input$person]
  if(length(temp) > 0)
           paste(temp[[1]], collapse = "; ")    
  })  
  
# get example with inflected verb form ====
  output$example <- renderText({
   temp <- verbs[verbs$INF == input$infinitive ,
          input$time][,"EXA"]
   if(length(temp) > 0)
     paste(temp[[1]], collapse = "; ")  
  })
    
  
  # get random row  ==========
  verb_row <- eventReactive(input$test,
                            {
                              
                              row_index <- sample(1:nrow(verbs), 1)
                              time_ind <- sample(c("OTT", "OVT", "VTT"), 1)
                              number_ind <- sample(c("SIN", "PLU"), 1)
                              person_ind <- sample(c("PE1", "PE2","PE3"), 1)
                              inf <-  verbs[row_index,"INF"]                  
                              vrb <- verbs[row_index,][, time_ind][, number_ind][, person_ind]
                              hlp <- as.character(dict[dict$times == time_ind &
                                                         dict$numbers == number_ind &
                                                         dict$persons == person_ind  , ]$helps)
                              c(inf = inf, vrb = vrb, hlp = hlp)
                            })


# get infinite from row() ==== 
output$test_inf <- renderText({unlist(
  verb_row()["inf"])})  
# get help from row() ====  
  output$test_help <- renderText({unlist(
    verb_row()["hlp"])}) 
  
# random row in 'dict'    

# get answer from row() ==== 
#  output$test_answer <- renderText({verb_row})    
  

# calculate score =========
output$test_score <- renderText({

    adist(input$test_answer, verb_row()["vrb"][[1]])

})

# get answer ====
 

x <-     eventReactive(input$go4,
                     {
 row()[,input$time2][,input$number][,input$person]
                     })

#output$word3 <- renderText({x()})
# get table

#  df <- eventReactive(input$go2, {
#    cbind(verbs[ , "INF"],
#          verbs[ , input$time2][,"SIN"], verbs[ , input$time2][,"PLU"], verbs[ , "EXE"])
#  })
#  output$table <- renderTable({
#    df()})
  

  }



