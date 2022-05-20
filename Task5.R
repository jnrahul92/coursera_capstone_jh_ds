setwd("D:/Coursera - Data Science Specialization/Capstone_Project")

# Loading sbo package

library(sbo)
library(dplyr)

blogs_file <- "train/train_blogs_clean.txt"
news_file <- "train/train_news_clean.txt"
twitter_file <- "train/train_twitter_clean.txt"

blogs <- readLines(blogs_file, skipNul = TRUE, encoding = "UTF-8")
news <- readLines(news_file, skipNul = TRUE,encoding = "UTF-8")
twitter <- readLines(twitter_file, skipNul = TRUE, encoding = "UTF-8")

allData <- c(blogs, news, twitter)

p <- sbo_predictor(object = allData,
                   N = 5,
                   dict = target ~0.75,
                   .preprocess = preprocess,
                   EOS = ".?!:;",
                   lambda = 0.4,
                   L = 5L,
                   filtered = "<UNK>")

t <- sbo_predtable(object = allData,
                   N = 3,
                   dict = target ~0.75,
                   .preprocess = preprocess,
                   EOS = ".?!:;",
                   lambda = 0.4,
                   L = 3L,
                   filtered = "<UNK>")
save(t, file = "backoff_model/mod_3_gm.rda")

load("backoff_model/mod_3_gm.rda")
p <- sbo_predictor(t)

test_blogs <- readLines("test/test_blogs_clean.txt",skipNul = TRUE, encoding = "UTF-8")
test_news <- readLines("test/test_news_clean.txt",skipNul = TRUE, encoding = "UTF-8")
test_twitter <- readLines("test/test_twitter_clean.txt",skipNul = TRUE, encoding = "UTF-8")

test <- c(test_blogs, test_news, test_twitter)

eval <- eval_sbo_predictor(p, test = test)
eval %>% summarise(accuracy = sum(correct)/n(),
                   uncertainity = sqrt(accuracy * (1- accuracy)/n()))

eval %>% filter(true != "<EOS>") %>% summarise(accuracy = sum(correct)/n(),
                                               uncertainity = sqrt(accuracy * (1- accuracy)/n()))



# Cross -validation to find best model for prediction

makeModel <- function(dat, N = 3, lambda = 0.4, L = 3L){
  sbo_predtable(object = dat,
                N = N,
                dict = target ~0.75,
                .preprocess = preprocess,
                EOS = ".?!:;",
                lambda = lambda,
                L = L,
                filtered = "<UNK>")
}

# 3 gram model to predict 5 words with lambda fixed

t_3gm <- makeModel(dat = allData, N = 5, L = 3L)
save(t_3gm, file = "backoff_model/mod_3_gm.rda")

t_4gm <- makeModel(dat = allData, N = 5, L = 4L)
save(t_4gm, file = "backoff_model/mod_4_gm.rda")

t_5gm <- makeModel(dat = allData, N = 5, L = 5L)
save(t_5gm, file = "backoff_model/mod_5_gm.rda")

t_6gm <- makeModel(dat = allData, N = 5, L = 6L)
save(t_6gm, file = "backoff_model/mod_6_gm.rda")

t_7gm <- makeModel(dat = allData, N = 5, L = 7L)
save(t_7gm, file = "backoff_model/mod_7_gm.rda")

rm(t_3gm,t_4gm,t_5gm, t_6gm, t_7gm)
gc()

# Evaluate 3 gram model

load("backoff_model/mod_3_gm.rda")
p <- sbo_predictor(t_3gm)
eval_sbo_predictor(p, test = test) %>% filter(true != "<EOS>") %>% 
  summarise(accuracy = sum(correct)/n(),
            uncertainity = sqrt(accuracy * (1- accuracy)/n()))
rm(t_3gm)

# Accuracy - 20%


# Evaluate 4 gram model

load("backoff_model/mod_4_gm.rda")
p <- sbo_predictor(t_4gm)
eval_sbo_predictor(p, test = test) %>% filter(true != "<EOS>") %>% 
  summarise(accuracy = sum(correct)/n(),
            uncertainity = sqrt(accuracy * (1- accuracy)/n()))
rm(t_4gm)

# Accuracy - 23.4%

# Evaluate 5 gram model

load("backoff_model/mod_5_gm.rda")
p <- sbo_predictor(t_5gm)
eval_sbo_predictor(p, test = test) %>% filter(true != "<EOS>") %>% 
  summarise(accuracy = sum(correct)/n(),
            uncertainity = sqrt(accuracy * (1- accuracy)/n()))
rm(t_5gm)

# Accuracy - 25%

# Evaluate 6 gram Model

load("backoff_model/mod_6_gm.rda")
p <- sbo_predictor(t_6gm)
eval_sbo_predictor(p, test = test) %>% filter(true != "<EOS>") %>% 
  summarise(accuracy = sum(correct)/n(),
            uncertainity = sqrt(accuracy * (1- accuracy)/n()))
rm(t_6gm)

# Accuracy - 27.2%

# Evaluate 7 gram model

load("backoff_model/mod_7_gm.rda")
p <- sbo_predictor(t_7gm)
eval_sbo_predictor(p, test = test) %>% filter(true != "<EOS>") %>% 
  summarise(accuracy = sum(correct)/n(),
            uncertainity = sqrt(accuracy * (1- accuracy)/n()))
rm(t_7gm)

# Accuracy - 28.7%