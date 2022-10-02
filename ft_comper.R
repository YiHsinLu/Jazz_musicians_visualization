# take component for percantage

comper = function(x,n=ncol(x)){
  m = x[,1:n]
  for(i in 1:nrow(m)){
    if(sum(m[i,])==0){
      m[i,] = m[i,]
    }else{
      m[i,] = m[i,]/sum(m[i,])
    }
  }
  x[,1:n] = m
  return(x)
}