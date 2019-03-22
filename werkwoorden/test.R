# ======================
library(readxl)
resCSV<- read_excel("werkwoorden/werkwoordenForJSON.xlsx")


nrow = nrow(resCSV)
df <- data.frame(PE1 = rep(NA, nrow),
                 PE2 = rep(NA, nrow),
                 PE3 = rep(NA, nrow))
res <- data.frame(INF = rep(NA, nrow),
                  EXE = rep(NA, nrow))
res$OTT <- data.frame(TEMP = rep(NA, nrow))
res$OTT$SIN <- df
res$OTT$PLU <- df
res$OTT$TEMP <- NULL
res$OVT <- data.frame(TEMP = rep(NA, nrow))
res$OVT$SIN <- df
res$OVT$PLU <- df
res$OVT$TEMP <- NULL
res$VTT <- data.frame(TEMP = rep(NA, nrow))
res$VTT$SIN <- df
res$VTT$PLU <- df
res$VTT$TEMP <- NULL

# do substitution
res$INF <- resCSV$INF
res$EXE <- resCSV$EXE
## OTT
res$OTT$SIN$PE1 <- resCSV$OTT.SIN.PE1
res$OTT$SIN$PE2 <- resCSV$OTT.SIN.PE2
res$OTT$SIN$PE3 <- resCSV$OTT.SIN.PE3
res$OTT$PLU$PE1 <- resCSV$OTT.PLU.PE1
res$OTT$PLU$PE2 <- resCSV$OTT.PLU.PE2
res$OTT$PLU$PE3 <- resCSV$OTT.PLU.PE3
## OVT
res$OVT$SIN$PE1 <- resCSV$OVT.SIN.PE1
res$OVT$SIN$PE2 <- resCSV$OVT.SIN.PE2
res$OVT$SIN$PE3 <- resCSV$OVT.SIN.PE3
res$OVT$PLU$PE1 <- resCSV$OVT.PLU.PE1
res$OVT$PLU$PE2 <- resCSV$OVT.PLU.PE2
res$OVT$PLU$PE3 <- resCSV$OVT.PLU.PE3
## VTT
res$VTT$SIN$PE1 <- resCSV$VTT.SIN.PE1
res$VTT$SIN$PE2 <- resCSV$VTT.SIN.PE2
res$VTT$SIN$PE3 <- resCSV$VTT.SIN.PE3

res$VTT$PLU$PE1 <- resCSV$VTT.PLU.PE1
res$VTT$PLU$PE2 <- resCSV$VTT.PLU.PE2
res$VTT$PLU$PE3 <- resCSV$VTT.PLU.PE3


resJSON <- jsonlite::toJSON(res, pretty = T)
writeLines(resJSON, "./werkwoorden/werkwoorden.json", useBytes = T)

# ================================


resJSON <- jsonlite::fromJSON(txt = "./werkwoorden/werkwoorden.json")


library(DT)
datatable(resJSON)


