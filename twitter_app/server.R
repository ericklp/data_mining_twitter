#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(twitteR)
library(tm)
library(stringr)
library(RColorBrewer)
library(wordcloud)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$wordcloud <- renderPlot({
    
    # PEGAR TODOS OS TWITTS DE ALGUÉM
    #tweets <- userTimeline("@realDonaldTrump", n = 3200)
    #tweets.df <- twListToDF(tweets)
    #tweets.df[190, c("id", "created", "screenName", "replyToSN",
    #                 "favoriteCount", "retweetCount", "longitude", "latitude", "text")]
    
    ## Twitter authentication
    consumer_key <- '3daKPNFMDFR4uXUwRLX2QZzl4'
    consumer_secret <- 'wu2ecNY5JMlUa7sRVcJzVKpOmzxjpRitt95xOguDwKRooJaP6v'
    access_token <- '55242249-MMKs4DTLop00T117PkR8ulGgQRkbxbVLchgRkBvZq'
    access_secret <- 'QtKeLoiyIRCnQvMM4qsDBjUBdzvRuq3shUmJSA6tMSnRq'
    setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

    twitt <- searchTwitter(input$hashtag, n = 10)
    twitt_text = sapply(twitt, function(x) x$getText())
    twitt_text=str_replace_all(twitt_text,"[^[:graph:]]", " ")
    twitt_text=str_replace_all(twitt_text,"[^[:graph:]]", " ")
    twitt_corpus = Corpus(VectorSource(twitt_text))
    
    
    tdm = TermDocumentMatrix(
      twitt_corpus,
      control = list(
        removePunctuation = TRUE,
        stopwords = c(input$hashtag, input$hashtag, stopwords("english")),
        removeNumbers = TRUE, tolower = TRUE)
    )
    
    m = as.matrix(tdm)
    # get word counts in decreasing order
    word_freqs = sort(rowSums(m), decreasing = TRUE) 
    # create a data frame with words and their frequencies
    dm = data.frame(word = names(word_freqs), freq = word_freqs)
    
    wordcloud(dm$word, dm$freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
    
  })
  
})
