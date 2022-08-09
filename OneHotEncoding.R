
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

#############################################################################################

token_split = function(df, g, id=rownames(df)){
  #parameters
  df = cbind(id, df)
  n = nrow(df) #numbers of row
  colnames(df) = c("id", "word") 
  
  #g=1
  #text mining to take the tokens from column--"word" for each row
  df_1g = df%>%
    unnest_tokens(words,word)#turn a block into few tokens
  colnames(df_1g)=c("id","word")
  data(stop_words)
  df_1g = df_1g%>%
    anti_join(stop_words)#delete the stop words
  
  #token list for one-gram
  token1 = df_1g%>%
    group_by()%>%
    count(word,sort=TRUE)%>%
    ungroup()#count the number of the token showed
  
  #g=2
  df_2g <- df %>%
    unnest_tokens(words, word, token = "ngrams", n = 2)
  colnames(df_2g)=c("id","word")
  data(stop_words)
  df_2g = df_2g%>%
    anti_join(stop_words)#delete the stop words
  
  #token list for two-grams
  token2 = df_2g%>%
    group_by()%>%
    count(word,sort=TRUE)%>%
    ungroup()#count the number of the token showed
  
  #list function
  lappend <- function (lst, ...){
    lst <- c(lst, list(...))
    return(lst)
  }
  
  #list of token in each musicians(one-gram)
  token_list_1g = list()
  for(i in id){
    token_pr = subset(df_1g,id==i)[2]
    token_list_1g = lappend(token_list_1g, token_pr)
    token_pr = c()
  }
  
  #list of token in each musicians(two-grams)
  token_list_2g = list()
  for(i in id){
    token_pr = rbind(subset(df_1g,id==i)[2], subset(df_2g,id==i)[2])
    token_list_2g = lappend(token_list_2g, token_pr)
    token_pr = c()
  }
  
  if(g==1){
    return(list(id=id, token_list1=token1$word, df_token_lst=token_list_1g))
  }else{
    return(list(id=id, token_list1=token1$word, token_list2=token2$word, df_token_lst=token_list_2g))
  }
}


#########################################################################################

oh_encoding = function(df,id=rownames(df),tok=c(),g=1){
  tok_slt = token_split(df=df,g=g,id=id)
  n = nrow(df)
  token_matrix = matrix(data = 0, nrow = n, ncol = length(tok))
  rownames(token_matrix) = id
  colnames(token_matrix) = tok
  for(t in tok){
    for (i in 1:n){
      if(grepl(t, tok_slt$df_token_lst[[i]])==TRUE){
        token_matrix[i, t]=1
      }
    }
  }
  token_matrix = as.data.frame(token_matrix)
  return(list(id=id, token_list=tok, df=tok_slt$df_token_lst, token_matrix=token_matrix))
}
