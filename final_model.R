setwd("D:/Coursera - Data Science Specialization/Capstone_Project")

library(sbo)
library(dplyr)

blogs_file <- "train/train_blogs_clean.txt"
news_file <- "train/train_news_clean.txt"
twitter_file <- "train/train_twitter_clean.txt"

blogs <- readLines(blogs_file, skipNul = TRUE, encoding = "UTF-8")
news <- readLines(news_file, skipNul = TRUE,encoding = "UTF-8")
twitter <- readLines(twitter_file, skipNul = TRUE, encoding = "UTF-8")

allData <- c(blogs, news, twitter)
rm(blogs, news, twitter)
gc()

t <- sbo_predtable(object = allData,
                   N = 5,
                   dict = target ~0.75,
                   .preprocess = preprocess,
                   EOS = ".?!:;",
                   lambda = 0.4,
                   L = 10,
                   filtered = c("<UNK>","<EOS>"))

save(t, file = "Word.Prediction/final_mod.rda")
