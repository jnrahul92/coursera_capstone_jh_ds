blogs <- readLines("final/en_US/en_US.blogs.txt")
twitter <- readLines("final/en_US/en_US.twitter.txt")
news <- readLines("final/en_US/en_US.news.txt")

max_twit = 0
max_blog = 0
max_news = 0

for (i in seq(length(blogs))){
  if(nchar(blogs[i]) > max_blog){
    max_blog = nchar(blogs[i])
  }
}

for (i in seq(length(twitter))){
  if(nchar(twitter[i]) > max_twit){
    max_twit = nchar(twitter[i])
  }
}

for (i in seq(length(news))){
  if(nchar(news[i]) > max_news){
    max_news = nchar(news[i])
  }
}

love_len = 0
hate_len = 0

for (i in seq(length(twitter))){
  if(grepl("love",twitter[i])){
    love_len = love_len +  1
  }
}

for (i in seq(length(twitter))){
  if(grepl("hate",twitter[i])){
    hate_len = hate_len +  1
  }
}

for (i in seq(length(twitter))){
  if(grepl("biostats",twitter[i])){
    print(twitter[i])
  }
}

len = 0
for (i in seq(length(twitter))){
  if(grepl("A computer once beat me at chess, but it was no match for me at kickboxing",twitter[i])){
    len = len +1
  }
}
