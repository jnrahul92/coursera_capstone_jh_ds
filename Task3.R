# Load libraries

library(quanteda)
library(readtext)
library(data.table)
library(stringr)
library(quanteda.textstats)

blogs_file <- "train/train_blogs_clean.txt"
news_file <- "train/train_news_clean.txt"
twitter_file <- "train/train_twitter_clean.txt"

blogs <- readLines(blogs_file, skipNul = TRUE)
news <- readLines(news_file, skipNul = TRUE)
twitter <- readLines(twitter_file, skipNul = TRUE)

blogs <- removePunctuation(blogs)
news <- removePunctuation(news)
twitter <- removePunctuation(twitter)

blogs <- stripWhitespace(blogs)
news <- stripWhitespace(news)
twitter <- stripWhitespace(twitter)

blogs <- gsub("â","",blogs)
news <- gsub("â","",news)
twitter <- gsub("â","",twitter)

corp <- corpus(c(blogs, news, twitter),docvars = data.frame(grp = c("blogs","news","twitter")))

rm(blogs, twitter, news)

tokWord <- tokens(corp, what = "word",remove_numbers = T, remove_punct = T,
                  remove_symbols = T, remove_separators = T,
                  remove_twitter = T, remove_url = T)

makeNgrams <- function(inputTokens, n, outName) {
  tokWordNg <- tokens_ngrams(inputTokens, n = n, concatenator = ' ')
  dfmWordNg <- dfm(tokWordNg, tolower = T)
  nGram <- textstat_frequency(dfmWordNg,)
  nGram <- subset(nGram, frequency > 1)
  write.csv(nGram, file = paste0("n_gram_model/",outName, '.csv'), row.names = F)
}

makeNgrams(tokWord, 1L, 'uniGram')
makeNgrams(tokWord, 2L, 'biGram')
makeNgrams(tokWord, 3L, 'triGram')
makeNgrams(tokWord, 4L, 'quadGram')
makeNgrams(tokWord, 5L, 'quinGram')
makeNgrams(tokWord, 6L, 'sixGram')
makeNgrams(tokWord, 7L, 'septGram')

generatePred <- function(inputFile, thresh = 1L) {
  nGram <- read.csv(paste("n_gram_model/",inputFile,sep = ""))
  nGram <- nGram[,c("feature","frequency")]
  nGram$query <- strsplit(nGram$feature," [^ ]+$")
  nGram$predict <- sub('.* (.*)$','\\1', nGram$feature)
  fwrite(nGram, paste0("n_gram_model/",sub('.csv', '', inputFile), 'Pred.csv'))
}

generatePred('biGram.csv')
generatePred('triGram.csv')
generatePred('quadGram.csv')
generatePred('quinGram.csv')
generatePred('sixGram.csv')
generatePred('septGram.csv')

files <- c("n_gram_model/biGramPred.csv","n_gram_model/triGramPred.csv",
           "n_gram_model/quadGramPred.csv","n_gram_model/quinGramPred.csv",
           "n_gram_model/sixGramPred.csv","n_gram_model/septGramPred.csv")

final_model <- data.frame()
for (j in files){
  df <- read.csv(j)
  final_model <- rbind(final_model,df)
}
final_model <- final_model[,c("frequency","query","predict")]
final_model <- final_model[order(final_model$frequency,decreasing = TRUE),]

nGramFilt <- final_model[with(final_model, frequency > 5),]
write.csv(nGramFilt, file = "n_gram_model/finalpred.csv")

nGramUni <- final_model[(!duplicated(final_model$query)) & (final_model$frequency >= 5),]
fwrite(nGramUni, file = 'n_gram_model/predictionTableUni.csv')
