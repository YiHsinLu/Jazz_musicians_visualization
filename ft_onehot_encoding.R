# Genreally  one-hot encoding
ohe = function(df){
  member = c()
  for(i in 1:nrow(df)){
    member = union(member, df[i,])
  }
  member = sort(member)
  df_new = matrix(data=0, nrow = nrow(df), ncol = length(member))
  for(i in 1:nrow(df_new)){
    for(j in 1:ncol(df_new)){
      if(df[i,1]==member[j]){
        df_new[i,j] = 1
      }
    }
  }
  arrdf = function(df, colname = c(1:ncol(df)), rowname = c(1:nrow(df))){
    df = as.data.frame(df)
    colnames(df) = colname
    rownames(df) = rowname
    return(df)
  }
  df_new = arrdf(df_new, colname = member, rowname = rownames(df))
  return((df_new))
}