#packages

library(knitr)
library(dplyr)
library(flextable)
library(magrittr)
library(kableExtra)
library(tidytext)
library(tidyverse)
library(plot.matrix)
library(stringr)
library(micropan)
library(ggpubr)
library(highcharter)

#Read the data_matrix
M_table=read.csv('D:/jazz/Musician_table.csv',row.names = 1, header= TRUE)

#Read abstract
abstract = read.csv('D:/jazz/Mus_abstract.csv')
colnames(abstract)=c("name","word")

#one-gram
abstract_1gram = abstract%>%
  unnest_tokens(words,word)

colnames(abstract_1gram)=c("name","word")
data(stop_words)
abstract_1gram = abstract_1gram%>%
  anti_join(stop_words)

tokens = abstract_1gram%>%
  group_by()%>%
  count(word,sort=TRUE)%>%
  ungroup()

#two-grams
abstract_2gram <- abstract %>%
  unnest_tokens(words, word, token = "ngrams", n = 2)

colnames(abstract_2gram)=c("name","word")
data(stop_words)
abstract_2gram = abstract_2gram%>%
  anti_join(stop_words)

tokens_2gram = abstract_2gram%>%
  group_by()%>%
  count(word,sort=TRUE)%>%
  ungroup()

#create the musician tokens matrix
#list of musicians
musicians = rownames(M_table)

#list function
lappend <- function (lst, ...){
  lst <- c(lst, list(...))
  return(lst)
}

#list of token in each musicians
token_list = list()
for(mu_n in musicians){
  token_pr = rbind(subset(abstract_1gram,name==mu_n)[2], subset(abstract_2gram,name==mu_n)[2])
  token_list = lappend(token_list, token_pr)
  token_pr = c()
}

#read the table of tkoens that I hand-pick chosed
token_sel = rbind(read.csv('D:/jazz/tokens_1gram.csv', header = TRUE)[1],read.csv('D:/jazz/token_2gram.csv', header = TRUE)[1])
token_sel = token_sel$word

#musicians*tokens matrix
token_matrix = as.data.frame(matrix(data = 0, nrow = length(musicians), ncol = length(token_sel)))
rownames(token_matrix) = musicians
colnames(token_matrix) = token_sel
for(tokens_i in token_sel){
  for(mu_i in 1:length(musicians)){
    if(grepl(tokens_i, token_list[[mu_i]])==TRUE){
      token_matrix[mu_i, tokens_i]=1
    }
  }
}

#disitance matrix by jaccard
mus_dist_jac = distJaccard(token_matrix)

#dimension reduction(MDS)
mds_musicians <- mus_dist_jac %>%      
  cmdscale() %>%
  as_tibble()
colnames(mds_musicians) <- c("Dim.1", "Dim.2")

#plot by highcharter
hchart(mds_musicians, "scatter", hcaes(x = Dim.1, y = Dim.2, group = musicians))

#color by instrument
#list of instrument
instrument = read.csv('D:/jazz/instrument.csv', header = TRUE)$word

instrument_matrix = as.data.frame(matrix(data = "others", nrow = length(musicians), ncol = 1))
rownames(instrument_matrix) = musicians
colnames(instrument_matrix) = "instrument"
for(inst_i in instrument){
  for(mu_i in 1:length(musicians)){
    if(grepl(inst_i, token_list[[mu_i]])==TRUE){
      instrument_matrix[mu_i, 1]=inst_i
    }
  }
}


mds_musicians_ins = cbind(mds_musicians, instrument_matrix)
hchart(mds_musicians_ins, "scatter", hcaes(x = Dim.1, y = Dim.2, group = instrument))
