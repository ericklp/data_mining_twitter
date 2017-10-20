# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).

library(shinythemes)
library(datasets)

shinyUI(fluidPage(theme = "bootstrap.css",
  titlePanel("Twitter API - WordCloud"),
  
  # Generate a row with a sidebar
    # Define the sidebar with one input
    sidebarPanel(
      textInput("hashtag", "Insira Hashtag", value = "", width = NULL, placeholder = NULL),
      hr()
    ),
    # Create a spot for the barplot
    mainPanel(
      plotOutput("wordcloud")
    )
))