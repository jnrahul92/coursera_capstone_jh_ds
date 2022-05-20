#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Word Prediction Application"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            strong("Introduction"),
            p(),
            strong("This application is for predicting next word for Coursera Data Science Capstone Project"),
            p("Application uses backoff model using sbo package in R"),
            textInput("text",h3("Query/Phrase"),value = ""),
            sliderInput("slider",h3("Number of Words"),min = 0, max = 10, value = 7)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("wordcloud")
        )
    )
))
