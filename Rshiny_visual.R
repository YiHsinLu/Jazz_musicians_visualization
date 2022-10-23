# Packages
library(imputeTS)
library(knitr)
library(dplyr)
library(flextable)
library(magrittr)
library(kableExtra)
library(tidytext)
library(tidyverse)
library(plot.matrix)
library(stringr)
library(ggpubr)
library(highcharter)
library(ggpubr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(viridisLite)
library(Rtsne)
library(qvalue)
library(jaccard)
library(lsa)
library(patchwork)
library(shiny)

# 
# Define UI for app that draws a histogram ----

info = c('instruments', 'genres', 'years middle', 'years length')
visual = c('PCA', 't-SNE')

ui <- fluidPage(
  
  # App title ----
  titlePanel("【Visualizing for Jazz Musicians】"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      selectInput("constant", "c in Jaccard:", c('0','1')),
      selectInput("visualization", "Visualizing method:", visual),
      selectInput("Information", "Which information:", info)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)


server <- function(input, output) {
  load("D:/jazz_visual/visualization_plot.RData")
  output$distPlot <- renderPlot({
    if(input$constant=='0'){
      if(input$visualization=='PCA'){
        if(input$Information=='instruments'){
          visualpca_plot.inst
        }else if(input$Information=='genres'){
          visualpca_plot.genre
        }else if(input$Information=='years middle'){
          visualpca_plot.ysamid
        }else if(input$Information=='years length'){
          visualpca_plot.ysalen
        }
      }else if(input$visualization=='t-SNE'){
        if(input$Information=='instruments'){
          visualTsne_plot.inst
        }else if(input$Information=='genres'){
          visualTsne_plot.genre
        }else if(input$Information=='years middle'){
          visualTsne_plot.ysamid
        }else if(input$input$Information=='years length'){
          visualTsne_plot.ysalen
        }
      }
    }else if(input$constant=='1'){
      if(input$visualization=='PCA'){
        if(input$Information=='instruments'){
          visualpca_plot.instc
        }else if(input$Information=='genres'){
          visualpca_plot.genrec
        }else if(input$Information=='years middle'){
          visualpca_plot.ysamidc
        }else if(input$Information=='years length'){
          visualpca_plot.ysalenc
        }
      }else if(input$visualization=='t-SNE'){
        if(input$Information=='instruments'){
          visualTsne_plot.instc
        }else if(input$Information=='genres'){
          visualTsne_plot.genrec
        }else if(input$Information=='years middle'){
          visualTsne_plot.ysamidc
        }else if(input$Information=='years length'){
          visualTsne_plot.ysalenc
        }
      }
    }
  })
}

shinyApp(ui = ui, server = server)