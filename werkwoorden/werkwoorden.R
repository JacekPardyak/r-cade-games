### ====
verbum <- jsonlite::fromJSON(
  txt = paste(readLines("./verbum/werkwoorden.json",
                        encoding = "UTF-8"),
              collapse = ""))
verbum$L <-verbum$V1
#verbum$L <- sapply(verbum$V1, function(x){unlist(strsplit(x, ""))})

verbum$R <- gsub("heeft ", "", verbum$V4)
verbum$R <- gsub("heeft/is ", "", verbum$R)
verbum$R <- gsub("is ", "", verbum$R)

verbum$dist <- mapply(function(x,y) {stringdist::stringdist(x, y, method = "cosine") }, 
                      verbum$L, verbum$R)

plot(verbum$dist)
  
stringdist::stringdist("gelden", "gegelden", method = "osa", weight = c(d = .1,
                                                                        i = .1, s = 1, t = 1))

methods = c("osa", "lv", "dl", "hamming", "lcs", "qgram",
           "cosine", "jaccard", "jw", "soundex")
for(method in methods){
print(stringdist::stringdistmatrix('gelden',c('gegolden', 'gegelden'), method = method))
  
}

verbum$R <- gsub("ge", "", verbum$R)

verbum$R <- sapply(verbum$R, function(x){unlist(strsplit(x, ""))})

verbum$Left <- mapply(function(x,y) {setdiff(x, y)}, verbum$L, verbum$R)
verbum$Right <- mapply(function(x,y) {setdiff(x, y)}, verbum$R, verbum$L)


# ============================================
googledrive::drive_upload(media = "./verbum/czasowniki.xlsx",
             path = "./DeOpmaat/Woordenlijst/czasowniki.xlsx")
googledrive::drive_update(media = "./verbum/czasowniki.xlsx",
                          file = "./DeOpmaat/Woordenlijst/czasowniki.xlsx")
# ============================================
verbs <- readxl::read_excel("verbum/czasowniki.xlsx")
zinnen <- verbs$Voorbeeld
writeLines(zinnen, "./verbum/zinnen.txt")



## =================================================
library("rvest")
url <- "http://www.dutchgrammar.com/pl/?n=Verbs.Ir03"
verbs <- data.frame()
for (i in c(1:19)) {
    print(i)
  chunk <- url %>%
    read_html() %>%
    html_nodes(xpath = paste('//*[@id="wikitext"]/table[', i,']', sep = '')) %>% 
    html_table()
  chunk <- chunk[[1]]
  verbs <- plyr::rbind.fill(verbs, chunk)
}

names(verbs) <- verbs[1,]
verbs <- verbs[-1,]
verbs$X <- as.numeric(verbs$X)
verbs$X <- sprintf( "%02d", verbs$X ) 




