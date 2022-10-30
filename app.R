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

info = c('all', 'instruments', 'genres', 'years middle', 'years length')
visual = c('PCA', 't-SNE')
load("mu_names.Rdata")

ui <- fluidPage(
  
  # App title ----
  titlePanel("【Visualizing for Jazz Musicians】"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      selectInput("Information", "Which information:", info),
      selectInput("visualization", "Visualizing method:", visual),
      textInput("mu_name", "The musician:")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Histogram ----
      plotlyOutput(outputId = "plot1")
      
    )
  )
)


server <- function(input, output) {
  load("for_app.Rdata")
  output$plot1  <- renderPlotly({
    if(input$Information=='all'){
      if(input$visualization=='PCA'){
        pca_all = prcomp(Jacc_all, scale = TRUE,center = TRUE, retx = T)
        x01 = pca_all$rotation[input$mu_name,1]
        x02 = pca_all$rotation[input$mu_name,2]
        visualpca_all = cbind(pca_all$rotation[,1]-x01, pca_all$rotation[,2]-x02, musicians)
        colnames(visualpca_all) = c('pc1', 'pc2', 'name')
        rownames(visualpca_all) = musicians
        visualpca_all = as.data.frame(visualpca_all)
        visualpca_all = transform(visualpca_all, pc1 = as.numeric(pc1), pc2 = as.numeric(pc2))
        plot1 = ggplot(visualpca_all, aes(x=pc1, y=pc2, label=name))+
          geom_point() +
          geom_text(hjust=0, vjust=0) +
          xlim(-0.02,0.02) +
          ylim(-0.02,0.02)
      }else{
        set.seed(19970608)
        tsne_all = Rtsne(Jacc_all, perplexity = 30, eta = 1000, max_iter = 5000, check_duplicates = FALSE)
        rownames(tsne_all$Y) = musicians
        x01 = tsne_all$Y[input$mu_name,1]
        x02 = tsne_all$Y[input$mu_name,2]
        visualTsne_all = cbind(tsne_all$Y[,1]-x01, tsne_all$Y[,2]-x02, musicians)
        colnames(visualTsne_all) = c('tsne1', 'tsne2', 'name')
        rownames(visualTsne_all) = musicians
        visualTsne_all = as.data.frame(visualTsne_all)
        visualTsne_all = transform(visualTsne_all, tsne1 = as.numeric(tsne1), tsne2 = as.numeric(tsne2))
        plot1 = ggplot(visualTsne_all, aes(x=tsne1, y=tsne2, label=name))+
          geom_point() +
          geom_text(hjust=0, vjust=0) +
          xlim(-2,2) +
          ylim(-2,2)
      }
    }else if(input$Information=='instruments'){
      set.seed(19970608)
      tsne_instc = Rtsne(Jacc_all.inst, check_duplicates = FALSE)
      pca_instc = prcomp(Jacc_all.inst, scale = TRUE,
                         center = TRUE, retx = T)
      visualTsne_instc = cbind(tsne_instc$Y, color_inst$hex)
      colnames(visualTsne_instc) = c('tsne1', 'tsne2', 'hex')
      rownames(visualTsne_instc) = musicians
      visualTsne_instc = as.data.frame(visualTsne_instc)
      visualTsne_instc = transform(visualTsne_instc, tsne1 = as.numeric(tsne1), tsne2 = as.numeric(tsne2))
      visualpca_instc = cbind(pca_instc$rotation[,1:2], color_inst$hex)
      colnames(visualpca_instc) = c('pc1', 'pc2', 'hex')
      rownames(visualpca_instc) = musicians
      visualpca_instc = as.data.frame(visualpca_instc)
      visualpca_instc = transform(visualpca_instc, pc1 = as.numeric(pc1), pc2 = as.numeric(pc2))
      visualTsne_plot.instc = plot_ly(visualTsne_instc, x = ~tsne1, y = ~tsne2,marker = list(color = visualTsne_instc$hex), text = musicians, mode = 'markers', type = 'scatter')
      visualpca_plot.instc = plot_ly(visualpca_instc, x = ~pc1, y = ~pc2, marker = list(color = visualpca_instc$hex), text = musicians, mode = 'markers', type = 'scatter')
      if(input$visualization=='PCA'){
        plot1 = visualpca_plot.instc%>%layout(title = "PCA")
        plot1
      }else{
        plot1 = visualTsne_plot.instc%>%layout(title = "t-SNE")
        plot1
      }
    }else if(input$Information=='genres'){
      set.seed(19970608)
      tsne_genrec = Rtsne(Jacc_all.genre, check_duplicates = FALSE)
      pca_genrec = prcomp(Jacc_all.genre, scale = TRUE,
                          center = TRUE, retx = T)
      visualTsne_genrec = cbind(tsne_genrec$Y, tolower(color_genre[,4]))
      colnames(visualTsne_genrec) = c('tsne1', 'tsne2', 'hex')
      rownames(visualTsne_genrec) = musicians
      visualTsne_genrec = as.data.frame(visualTsne_genrec)
      visualTsne_genrec = transform(visualTsne_genrec, tsne1 = as.numeric(tsne1), tsne2 = as.numeric(tsne2))
      visualpca_genrec = cbind(pca_genrec$rotation[,1:2], tolower(color_genre[,4]))
      colnames(visualpca_genrec) = c('pc1', 'pc2', 'hex')
      rownames(visualpca_genrec) = musicians
      visualpca_genrec = as.data.frame(visualpca_genrec)
      visualpca_genrec = transform(visualpca_genrec, pc1 = as.numeric(pc1), pc2 = as.numeric(pc2), hex = tolower(hex))
      visualTsne_plot.genrec = plot_ly(visualTsne_genrec, x = ~tsne1, y = ~tsne2, marker = list(color = visualTsne_genrec$hex), text = musicians)
      visualpca_plot.genrec = plot_ly(visualpca_genrec, x = ~pc1, y = ~pc2, marker = list(color = visualpca_genrec$hex), text = musicians)
      if(input$visualization=='PCA'){
        plot1 = visualpca_plot.genrec%>%layout(title = "PCA",plot_bgcolor='#e5ecf6')
        plot1
      }else{
        plot1 = visualTsne_plot.genrec%>%layout(title = "t-SNE",plot_bgcolor='#e5ecf6')
        plot1
      }
    }else if(input$Information=='years length'){
      set.seed(19970608)
      tsne_ysalenc = Rtsne(Jacc_all.ysalen, check_duplicates = FALSE)
      pca_ysalenc = prcomp(Jacc_all.ysalen, scale = TRUE,
                           center = TRUE, retx = T)
      visualTsne_ysalenc = cbind(tsne_ysalenc$Y[,1], tsne_ysalenc$Y[,2], ysa_len$n)
      visualTsne_ysalenc = arrdf(visualTsne_ysalenc, colname = c('tsne1', 'tsne2', 'n'), rowname = musicians)
      visualpca_ysalenc = cbind(pca_ysalenc$rotation[,1], pca_ysalenc$rotation[,2], ysa_len$n)
      visualpca_ysalenc = arrdf(visualpca_ysalenc, colname = c('pc1', 'pc2', 'n'), rowname = musicians)
      visualpca_ysalenc = transform(visualpca_ysalenc, pc1 = as.numeric(pc1), pc2 = as.numeric(pc2))
      visualTsne_plot.ysalenc = plot_ly(visualTsne_ysalenc, x = ~tsne1, y = ~tsne2, color = ~n, text = musicians)
      visualpca_plot.ysalenc = plot_ly(visualpca_ysalenc, x = ~pc1, y = ~pc2, color = ~n, text = musicians)
      if(input$visualization=='PCA'){
        plot1 = visualpca_plot.ysalenc%>%layout(title = "PCA")
        plot1
      }else{
        plot1 = visualTsne_plot.ysalenc%>%layout(title = "t-SNE")
        plot1
      }
    }else if(input$Information=='years middle'){
      set.seed(19970608)
      tsne_ysamidc = Rtsne(Jacc_all.ysamid, check_duplicates = FALSE)
      pca_ysamidc = prcomp(Jacc_all.ysamid, scale = TRUE,
                           center = TRUE, retx = T)
      visualTsne_ysamidc = cbind(tsne_ysamidc$Y[,1], tsne_ysamidc$Y[,2], ysa_mid$middle)
      visualTsne_ysamidc = arrdf(visualTsne_ysamidc, colname = c('tsne1', 'tsne2', 'years'), rowname = musicians)
      visualpca_ysamidc = cbind(pca_ysamidc$rotation[,1], pca_ysamidc$rotation[,2], ysa_mid$middle)
      visualpca_ysamidc = arrdf(visualpca_ysamidc, colname = c('pc1', 'pc2', 'years'), rowname = musicians)
      visualpca_ysamidc = transform(visualpca_ysamidc, pc1 = as.numeric(pc1), pc2 = as.numeric(pc2))
      visualTsne_plot.ysamidc = plot_ly(visualTsne_ysamidc, x = ~tsne1, y = ~tsne2, color = ~years, text = musicians)
      visualpca_plot.ysamidc = plot_ly(visualpca_ysamidc, x = ~pc1, y = ~pc2, color = ~years, text = musicians)
      if(input$visualization=='PCA'){
        plot1 = visualpca_plot.ysamidc%>%layout(title = "PCA")
        plot1
      }else{
        plot1 = visualTsne_plot.ysamidc%>%layout(title = "t-SNE")
        plot1
      }
    }
    
  })
}

shinyApp(ui = ui, server = server)