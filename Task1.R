# Setting the working directory

setwd("D:/Coursera - Data Science Specialization/Capstone_Project")

# Download Data-set

if(!file.exists("Coursera-SwiftKey.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip",
                destfile = "D:\\Coursera - Data Science Specialization/Capstone_Project/Coursera-SwiftKey.zip")
  unzip("Coursera-SwiftKey.zip")
}

twitter_file <- 'final/en_US/en_US.twitter.txt'
blogs_file <- "final/en_US/en_US.blogs.txt"
news_file <- "final/en_US/en_US.news.txt"

# Creating training data-set

train_twitter = c()
train_blogs = c()
train_news = c()

twitter_con <- file(twitter_file,"r")

while(TRUE){
  line = readLines(twitter_con,1000)
  if(length(line) == 0){
    break
  }
  if(rbinom(prob = 0.1,n = 1,size = 1)==1){
    train_twitter = c(train_twitter,line)
  }
}
close(twitter_con)

blogs_con <- file(blogs_file,"r")

while (TRUE) {
  line = readLines(blogs_con,1000)
  if(length(line) == 0){
    break
  }
  if(rbinom(prob = 0.1,n = 1,size = 1)==1){
    train_blogs = c(train_blogs,line)
  }
}

close(blogs_con)

news_con <- file(news_file,"r")

while (TRUE) {
  line = readLines(news_con,1000)
  if(length(line) == 0){
    break
  }
  if(rbinom(prob = 0.1,n = 1,size = 1)==1){
    train_news = c(train_news,line)
  }
}
close(news_con)

# Saving Training Dataset

if(!file.exists("train")){
  dir.create("train")
}

if(!file.exists("train/train_news.txt")){
  write.table(train_news, file = "train/train_news.txt",sep = "\t", row.names = FALSE,col.names = FALSE)
}

if(!file.exists("train/train_blogs.txt")){
  write.table(train_blogs, file = "train/train_blogs.txt",sep = "\t", row.names = FALSE,col.names = FALSE)
}

if(!file.exists("train/train_twitter.txt")){
  write.table(train_twitter, file = "train/train_twitter.txt",sep = "\t", row.names = FALSE,col.names = FALSE)
}

train_news = readLines("train/train_news.txt")
badlist <- readLines("badwords.txt")

source("profanity_filtering.R")
train_news_clean <- rmProfanity(file = train_news, reference = badlist)
train_blogs_clean <- rmProfanity(file = train_blogs,reference = badlist)
train_twitter_clean <- rmProfanity(file = train_twitter, reference = badlist)

if(!file.exists("train/train_news_clean.txt")){
  write.table(train_news_clean, file = "train/train_news_clean.txt",sep = "\t", row.names = FALSE,col.names = FALSE)
}

if(!file.exists("train/train_blogs_clean.txt")){
  write.table(train_blogs_clean, file = "train/train_blogs_clean.txt",sep = "\t", row.names = FALSE,col.names = FALSE)
}

if(!file.exists("train/train_twitter_clean.txt")){
  write.table(train_twitter_clean, file = "train/train_twitter_clean.txt",
              sep = "\t", row.names = FALSE,col.names = FALSE)
}


# Creating a test set

test_twitter = c()
test_blogs = c()
test_news = c()

twitter_con <- file(twitter_file,"r")

while(TRUE){
  line = readLines(twitter_con,1000)
  if(length(line) == 0){
    break
  }
  if(rbinom(prob = 0.01,n = 1,size = 1)==1){
    test_twitter = c(test_twitter,line)
  }
}
close(twitter_con)

blogs_con <- file(blogs_file,"r")

while (TRUE) {
  line = readLines(blogs_con,1000)
  if(length(line) == 0){
    break
  }
  if(rbinom(prob = 0.01,n = 1,size = 1)==1){
    test_blogs = c(test_blogs,line)
  }
}

close(blogs_con)

news_con <- file(news_file,"r")

while (TRUE) {
  line = readLines(news_con,1000)
  if(length(line) == 0){
    break
  }
  if(rbinom(prob = 0.1,n = 1,size = 1)==1){
    test_news = c(test_news,line)
  }
}
close(news_con)

# Saving Training Dataset

if(!file.exists("test")){
  dir.create("test")
}

if(!file.exists("test/test_news.txt")){
  write.table(test_news, file = "test/test_news.txt",sep = "\t", row.names = FALSE,col.names = FALSE)
}

if(!file.exists("test/test_blogs.txt")){
  write.table(test_blogs, file = "test/test_blogs.txt",sep = "\t", row.names = FALSE,col.names = FALSE)
}

if(!file.exists("test/test_twitter.txt")){
  write.table(test_twitter, file = "test/test_twitter.txt",sep = "\t", row.names = FALSE,col.names = FALSE)
}

badlist <- readLines("badwords.txt")

source("profanity_filtering.R")
test_news_clean <- rmProfanity(file = test_news, reference = badlist)
test_blogs_clean <- rmProfanity(file = test_blogs,reference = badlist)
test_twitter_clean <- rmProfanity(file = test_twitter, reference = badlist)

if(!file.exists("test/test_news_clean.txt")){
  write.table(test_news_clean, file = "test/test_news_clean.txt",sep = "\t", row.names = FALSE,col.names = FALSE)
}

if(!file.exists("test/test_blogs_clean.txt")){
  write.table(test_blogs_clean, file = "test/test_blogs_clean.txt",sep = "\t", row.names = FALSE,col.names = FALSE)
}

if(!file.exists("test/test_twitter_clean.txt")){
  write.table(test_twitter_clean, file = "test/test_twitter_clean.txt",
              sep = "\t", row.names = FALSE,col.names = FALSE)
}
