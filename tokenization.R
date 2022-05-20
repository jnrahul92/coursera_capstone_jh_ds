# Load the libraries

library(tidyverse)
library(tidytext)


tokenization <- function(file){
  library(tidyverse)
  library(tidytext)
  wordFreq <- tibble(1:length(file),
                     text = file) %>% unnest_tokens(word,text) %>% count(word,sort = TRUE)
  wordFreq
}
