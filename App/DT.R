

require("jsonlite")
wordlist <- fromJSON(
  txt = paste(readLines("./App/wordlist.json",
                        encoding = "UTF-8"),
              collapse = ""))
wordlist$Kn <- as.factor(wordlist$Kn)

text <- toJSON(wordlist, pretty = T)
writeLines(text, "./App/wordlist.json", useBytes = T)

?DT

wordlist$Zin
