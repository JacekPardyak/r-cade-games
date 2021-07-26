# ================================
verbs <- jsonlite::fromJSON(txt = "werkwoorden.json")

verbs <- verbs[order(verbs$INF),]

text <- jsonlite::toJSON(verbs, pretty = T)

writeLines(text, "werkwoorden.json", useBytes = T)
verbs <- jsonlite::fromJSON(txt = "verbsN.json")



input <- list()
input$infinitive <- "gaan"
input$time <- "OTT"
input$number <- "SIN"
input$person <- "PE1"

dict <- data.frame(times = c(rep("OTT", 6),
                            rep("OVT", 6),
                            rep("VTT", 6)),
                   numbers = rep(
                            c(c(rep("SIN",3)),
                            c(rep("PLU",3))), 3),
                   persons = rep(c(
                            "PE1", "PE2","PE3"), 6)) 

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

names(verbs[row_index,])                            
                            

# random row in dict
rand_ind <- dict[sample(1:nrow(dict),1),] 

# random row
index = sample(1:nrow(verbs), 1)
verb_row <- verbs[index,]
# get infinite from row() ==== 
test_verb <- verb_row[,"INF"]
# get good answer
verb_answer <- verb_row[1,rand_ind$times][1,rand_ind$numbers][1,rand_ind$persons]




verbs <- verbs[verbs$INF == input$infinitive,]
verbs$OTT$SIN$PE1



verbs[verbs$INF == input$infinitive,
      input$time][,input$number][,input$person]




wordsSub <- data.frame()
for (topic  in input$topics) {
  res <- words[sapply(words$Th, function(x)
    topic %in% x),]
  wordsSub <- rbind(wordsSub, res)}             

index = sample(1:nrow(wordsSub), 1)
row <- wordsSub[index,]

rownames(row)

output$word <- row[, input$lang1][[1]]
output$answer <- row[, input$lang2][[1]]


library(DT)
datatable(resJSON)
