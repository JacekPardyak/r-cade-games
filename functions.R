if (!require("stringdist")) install.packages("stringdist")
require("stringdist")
#####
Sys.setlocale("LC_ALL", locale = "French")
#######
numerals <- read.table(file="./Collections/numerals.txt",header = TRUE ,sep=" ",
                       encoding = "UTF-8", comment.char = "#")

# verbs <- read.table(file="./Collections/verbs.txt",header = TRUE ,sep=" ",
#                     encoding = "UTF-8", comment.char = "#")

expressions <- read.table(file="./Collections/expressions.txt",header = TRUE ,sep=" ",
                          encoding = "UTF-8", comment.char = "#")

dictionary <- read.table(file="./Collections/dictionary.txt",header = TRUE ,sep=" ",
                         encoding = "UTF-8", comment.char = "#")

# keyboard <- read.table(file="./Collections/keyboard.txt",header = TRUE ,sep=" ",
#                       encoding = "UTF-8", comment.char = "#")
#####

##### Clean text
asstring <- function(x){
  y <- tolower(x)
  y <- gsub(" ","",y)
  y
}
##### Main function

app <- function(collection){
  data <- collection 
  row <- data[sample(nrow(data),1),]
  word <- row[,c(1:2)] # first English, then French
  example <- row[,c(5,4)] # first English, then French
  prompt <- data.frame(EN=c("Your translation of","in the following context"), 
                       FR=c("Votre traduction du","dans le contexte suivant"))
  word.type <- as.character(row[,3])
  index <- sample(1:2,1)
  answer <- readline(prompt =
  sprintf("%s: \"%s\" %s: \n%s" , prompt[1,index], word[1,index], prompt[2,index], example[1,index]))
  score <- stringdist(asstring(answer),asstring(word[1,3-index]),method = "jw")
  score <- round((-1 * score +1)*100,2)
  sprintf("Your answer: '%s' resulted in score: %s points. Translation of: '%s' is: '%s' (%s). For example: %s - %s", answer, score, row[1,1], row[1,2], row[1,3], row[1,4], row[1,5])
}
