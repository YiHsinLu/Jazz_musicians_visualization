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

time_fill = function(df){
  # parameters
  n = nrow(df)
  # List function
  lappend <- function (lst, ...){
    lst <- c(lst, list(...))
    return(lst)
  }
  time_list = seq(from=1910, to=2020, by=10)
  member_list = list()
  for(i in 1:n){
    if(is.na(df[i,1])){
      time_inter = c()
      member_list = lappend(member_list, time_inter)
    }else{
      ts = df[i,1]
      te = df[i,2]
      time_inter = seq(from=ts, to=te, by=10)
      member_list = lappend(member_list, time_inter)
    } 
  }
  return(list(member = rownames(df), time_list=time_list, member_list = member_list))
}


#########################################################################################

oh_encoding_time = function(df){
  time_fill_list = time_fill(df)
  t = time_fill_list$time_list
  n = nrow(df)
  time_matrix = matrix(data = 0, nrow = n, ncol = length(t))
  rownames(time_matrix) = rownames(df)
  colnames(time_matrix) = t
  for(i in 1:nrow(Mtable_ysa)){
    tlist = time_fill_list$member_list[[i]]
    if(length(tlist)==0){
      time_matrix[i,1]=0
    }else{
      for(ti in 1:length(t)){
        for(tj in 1:length(tlist)){
          if(t[ti]==tlist[tj]){
            time_matrix[i, ti]=1
          }
        }
      }
    }
  }
  time_matrix = as.data.frame(time_matrix)
  return(list(id=rownames(df), time_list=t, df=time_fill_list$time_list, time_matrix=time_matrix))
}
