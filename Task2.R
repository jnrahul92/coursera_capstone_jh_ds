# Libraries
setwd("D:/Coursera - Data Science Specialization/Capstone_Project")

library(tidytext)
library(tidyverse)
library(quanteda)
library(readtext)
library(quanteda.textplots)
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


#blogs <- removeWords(blogs, stopwords("english"))
#news <- removeWords(news, stopwords("english"))
#twitter <- removeWords(twitter,stopwords("english"))

blogs <- stripWhitespace(blogs)
news <- stripWhitespace(news)
twitter <- stripWhitespace(twitter)

blogs <- gsub("â","",blogs)
news <- gsub("â","",news)
twitter <- gsub("â","",twitter)

corp <- corpus(c(blogs, news, twitter),docvars = data.frame(grp = c("blogs","news","twitter")))

sumCorp <- summary(corp)

word <- ggplot(data = sumCorp, aes(x = grp, y = Tokens, fill = grp)) + geom_col() + guides(fill = "none") + 
  scale_y_continuous(expand = c(0,0)) + ylab("Word Counts")

sentence <- ggplot(data = sumCorp, aes(x = grp, y = Sentences, fill = grp)) + geom_col() + guides(fill = "none") +
  scale_y_continuous(expand = c(0,0))

plot_grid(word, sentence, labels = "AUTO")

tokenWord <- tokens(corp, what = "word", remove_numbers = TRUE,
                remove_punct = TRUE, remove_separators = TRUE, remove_symbols = TRUE,
                remove_url = TRUE)
tokenSent <- tokens(corp, what = "sentence",remove_numbers = TRUE,
                    remove_punct = TRUE, remove_separators = TRUE, remove_symbols = TRUE,
                    remove_url = TRUE)

dfm_corp <- dfm(tokenWord, tolower = TRUE)
dfm_corp %>% dfm_group(groups = grp) %>% dfm_trim(min_termfreq = 2000) %>% textplot_wordcloud(comparison = TRUE)

features_dfm_corp <- textstat_frequency(dfm_corp, n = 50)
features_dfm_corp$feature <- with(features_dfm_corp, reorder(feature,-frequency))

ggplot(features_dfm_corp,aes(x = feature, y = frequency)) + geom_point() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

freq_grouped <- textstat_frequency(dfm(tokenWord),
                                   groups = grp, n =25)
ggplot(freq_grouped, aes(x = feature , y = frequency, col = group)) + geom_point()


dfm_weight_corp <- dfm_weight(dfm_corp, scheme = "prop")
freq_weight <- textstat_frequency(dfm_weight_corp, n = 10, groups = grp)
ggplot(data = freq_weight, aes(x = nrow(freq_weight):1, y = frequency)) + geom_point() + 
  facet_wrap(~group, scales = "free") + coord_flip() + scale_x_continuous(breaks = nrow(freq_weight):1,
                                                                          labels = freq_weight$feature) +
  labs(x = NULL, y = "Relative frequency")


token_words_2grams <- tokens_ngrams(tokenWord, n = 2L, concatenator = " ")
dfm_corp_2gm <- dfm(token_words_2grams, tolower = TRUE)
top2gAll <- textstat_frequency(dfm_corp_2gm, n = 20)
top2gAll$feature <- with(top2gAll, reorder(feature, -frequency))
ggplot(top2gAll,aes(x = feature, y = frequency)) + geom_point() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

token_words_3grams <- tokens_ngrams(tokenWord, n = 3L, concatenator = " ")
dfm_corp_3gm <- dfm(token_words_3grams, tolower = TRUE)
top3gAll <- textstat_frequency(dfm_corp_3gm, n = 20)
top3gAll$feature <- with(top3gAll, reorder(feature, -frequency))
ggplot(top3gAll,aes(x = feature, y = frequency)) + geom_point() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Word Coverage

features_dfm_corp_all <- textstat_frequency(dfm_corp)
features_dfm_corp_all$feature <- with(features_dfm_corp_all, reorder(feature,-frequency))
totalWords <- sum(features_dfm_corp_all$frequency)
features_dfm_corp_all$weight <- features_dfm_corp_all$frequency / totalWords
wordN <- 0
coverageCount <- 0

for (i in 1:totalWords){
  if(coverageCount <= 0.5){
    coverageCount <- coverageCount + features_dfm_corp_all[i,"weight"]
    wordN <- i
  }
  else{
    break
  }
}

print(paste(wordN," needed for 50% coverage"))

wordN <- 0
coverageCount <- 0

for (i in 1:totalWords){
  if(coverageCount <= 0.9){
    coverageCount <- coverageCount + features_dfm_corp_all[i,"weight"]
    wordN <- i
  }
  else{
    break
  }
}

print(paste(wordN," needed for 50% coverage"))

