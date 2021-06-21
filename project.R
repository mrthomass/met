library(shiny)
library(tidyverse)
library(visNetwork)
library(httr)
library(jsonlite)
library(reticulate)
library(shinycssloaders)
source_python("py/help.py")

#this is just the basic shell for the app and a more complex ui is necessary, but the visNet should be prominent.

#individual artist's csv, this can be easily expanded upon
my_artists <- read_csv("data/my_artists.csv") %>% 
  arrange(ARTIST)
#this is not used in the example below since more IDing must take place


interim_artists <- c("Vincent van Gogh", "Raphael", "Eugène Delacroix", "Michelangelo Buonarroti", "Johannes Vermeer", "Paul Cézanne", "Edgar Degas", "Paul Gauguin", "Edouard Manet", "Gustav Klimt", "Peter Paul Rubens", "Titian", "Albrecht Dürer")



ui <- fluidPage(
  titlePanel(
    HTML("<h1><center>Explore the MET's collection<br><hr><br>")
  ),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "inp2", label = "Select Artist: ", choices = interim_artists, selected = "Vincent van Gogh"),
      textOutput(outputId = "out_two")
    ),
    mainPanel(
      withSpinner(
        visNetworkOutput(outputId = "out_one", width = "100%", height = "800px"),
        type = 3, color.background = "white", color = "black", size = .75
      )
    )
  )
)



server <- function(input, output) {
  output$out_one <- renderVisNetwork({
    high <- py$get_highlights(input$inp2)
    g <- py$get_titles(input$inp2)
    
    # low <- py$get_lowlights(input$inp2)
    # this is a place holder for later^
    
    j <- length(high)
    
    
    nodes <- data.frame(
      id = 1:j,
      shape = c("image"),
      image = paste0(high),
      label = paste0(g),
      font.size = 2
    )
   
    
    # edges <- data.frame(from = c(2,4,3,3, 3), to = c(1,2,4,2, 1))
    
    visNetwork(nodes, width = "100%") %>%
    visNodes(shapeProperties = list(useBorderWithImage = FALSE)) %>% 
    visLayout(randomSeed = 5)
  })
  
  output$out_two <- renderText({
    g <- py$get_titles(input$inp2)
  })
}


shinyApp(ui, server)
