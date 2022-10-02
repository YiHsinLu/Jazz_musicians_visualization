# Arrange to data frame with row name and column name
arrdf = function(df, colname = c(1:ncol(df)), rowname = c(1:nrow(df))){
  df = as.data.frame(df)
  colnames(df) = colname
  rownames(df) = rowname
  return(df)
}