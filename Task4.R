
# Load the prediction model

setwd("D:/Coursera - Data Science Specialization/Capstone_Project")
library(tm)
library(dplyr)

nGramAll <- read.csv('n_gram_model/finalpred.csv')

filtstr <- 'all the'
nGramAll[nGramAll$query %in% filtstr,"predict"]

nextWordsApprox <- function(rawstr, n){
  rawstr <- rawstr %>% removeNumbers() %>% removePunctuation() %>% stripWhitespace() %>% tolower()
  rawstrsplit <- strsplit(rawstr, "\\s+")[[1]]
  if(length(rawstrsplit)>5){
    rawstrsplit <- rawstrsplit[(length(rawstrsplit)-5):length(rawstrsplit)]
  }
  rawstr <- paste(rawstrsplit, collapse = " ")
  pred <- nGramAll[nGramAll$query %in% rawstr,"predict"]
  if(length(pred)>0){
    final.pred <- pred
  }
  else{
    rawstr <- paste(rawstrsplit[2:length(rawstrsplit)],collapse = " ")
    pred <- nGramAll[nGramAll$query %in% rawstr,"predict"]
    if(length(pred)>0){
      final.pred <- pred
    }
    else{
      rawstr <- paste(rawstrsplit[3:length(rawstrsplit)],collapse = " ")
      pred <- nGramAll[nGramAll$query %in% rawstr,"predict"]
      if(length(pred)>0){
        final.pred <- pred
      }
      else{
        rawstr <- paste(rawstrsplit[4:length(rawstrsplit)],collapse = " ")
        pred <- nGramAll[nGramAll$query %in% rawstr,"predict"]
        if(length(pred)>0){
          final.pred <- pred
        }
        else{
          rawstr <- paste(rawstrsplit[5:length(rawstrsplit)],collapse = " ")
          pred <- nGramAll[nGramAll$query %in% rawstr,"predict"]
          if(length(pred)>0){
            final.pred <- pred
          }
          else{
            rawstr <- paste(rawstrsplit[6:length(rawstrsplit)],collapse = " ")
            pred <- nGramAll[nGramAll$query %in% rawstr,"predict"]
            if(length(pred)>0){
              final.pred <- pred
            }
            else{
              final.pred <- "the"
            }
          }
        }
      }
    }
  }
  final.pred[1:n]
}

queryStr <- 'I am first'
start <- Sys.time()
nextWordsApprox(queryStr, 5)
Sys.time() - start
