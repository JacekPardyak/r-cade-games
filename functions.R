require("stringdist")
#####
Sys.setlocale("LC_ALL", locale = "French")
#######
numerals <- read.table(file="./R/Data/numeral.txt",header = TRUE ,sep=" ",
                       encoding = "UTF-8", comment.char = "#")

verbs <- read.table(file="./R/Data/verbs.txt",header = TRUE ,sep=" ",
                    encoding = "UTF-8", comment.char = "#")

expressions <- read.table(file="./R/Data/expressions.txt",header = TRUE ,sep=" ",
                          encoding = "UTF-8", comment.char = "#")

vocabulary <- read.table(file="./R/Data/vocabulary.txt",header = TRUE ,sep=" ",
                         encoding = "UTF-8", comment.char = "#")

keyboard <- read.table(file="./R/Data/keyboard.txt",header = TRUE ,sep=" ",
                       encoding = "UTF-8", comment.char = "#")
#####

##### Clean text
asstring <- function(x){
  y <- tolower(x)
  y <- gsub(" ","",y)
  y
}
##### Main function
app <- function(){
  data <- vocabulary
  random_row <- data[sample(nrow(data),1),]
  answer <- random_row
  random_row <- random_row[,c(1,4)]
  
  index <- sample(ncol(random_row),1)
  word_question <- as.character(random_row[,index])
  word_corr_ans <- as.character(random_row[,ncol(random_row)+1-index])
  prompt <- data.frame(EN=c("Your translation of:"), FR=c("Votre traduction du:"))
  word_your_ans <- readline(prompt =
                              paste(paste(prompt[1,ncol(random_row)+1-index],word_question)," "))
  score <- stringdist(asstring(word_corr_ans),asstring(word_your_ans),method = "jw")
  score <- round((-1 * score +1)*100,2)
  cat(c("Your input:", word_your_ans, "\t\t","Score:",score,"%","\n"))
  
  # cat(c(score,"%"))
  print(answer)
}
##### Not run
#app()

##### Main function 'num'
num <- function(){
  data <- numerals
  random_row <- data[sample(nrow(data),1),]
  answer <- random_row
  number <- random_row[1,3]
  random_row <- random_row[,c(1,4)]
  
  index <- sample(ncol(random_row),1)
  word_question <- as.character(random_row[,index])
  word_corr_ans <- as.character(random_row[,ncol(random_row)+1-index])
  prompt <- data.frame(EN=c("Your translation of:"), FR=c("Votre traduction du:"))
  word_your_ans <- readline(prompt =
                              paste(paste(paste(prompt[1,ncol(random_row)+1-index],word_question),number)," "))
  score <- stringdist(asstring(word_corr_ans),asstring(word_your_ans),method = "jw")
  score <- round((-1 * score +1)*100,2)
  cat(c("Your input:", word_your_ans, "\t\t","Score:",score,"%","\n"))
  
  # cat(c(score,"%"))
  print(answer)
}
##### Not run
#app()
