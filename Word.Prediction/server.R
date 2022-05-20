#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(sbo)
library(wordcloud)
library(ggplot2)
library(RColorBrewer)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    load("final_mod.rda")
    p <- sbo_predictor(t)
    observe({
        query <- as.character(input$text)
        pred <- predict(p,query)
        pred <- pred[1:input$slider]
        if(query == ''){
            output$wordcloud <- renderPlot({
                ggplot() + annotate("text",x = 10, y = 10,
                                    size = 10,
                                    label = "Please enter text for prediction") + 
                    theme(axis.title = element_blank(),axis.text = element_blank(),
                          axis.ticks = element_blank(),
                          panel.background = element_rect(fill = "white"))
            })
        }
        else{
            out_df <- data.frame(pred = pred, freq = seq(1000,1,-1000/input$slider)) 
            output$wordcloud <- renderPlot({
                wordcloud(words = out_df$pred,
                          freq = out_df$freq,
                          random.order = FALSE,
                          rot.per = 0,
                          scale = c(1,5),
                          colors = brewer.pal(8,"Dark2")
                )})
        }
    })

})
