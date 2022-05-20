library(tidytext)
library(tidyverse)

rmProfanity <- function(file, reference,words = NULL){
  file <- tolower(file)
  for (i in 1:length(reference)){
    file <- gsub(pattern = paste("\\b",reference[i],"\\b",sep = ""), replacement = '', x = file)
  }
  if (length(words)>0) {
    for (i in 1:length(words)) {
      file <- gsub(pattern = paste("\\b",words[i],"\\b",sep = ""),replacement = "",x = file)
    }
  }
  return(file)
}
