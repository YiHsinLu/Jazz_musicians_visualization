# PSS function (proximity, significance, singularity)

proxim = function(x,y){
  expvalue = exp(-abs(x-y))
  z = 1-(1/(1+expvalue))
  return(z)
}


signific = function(x,y,rm){
  expvalue = exp(-abs(x-rm)*abs(y-rm))
  z = (1/(1+expvalue))
  return(z)
}

singular = function(x,y,muj){
  expvalue = exp(-abs((x+y)/2-muj))
  z = 1-(1/(1+expvalue))
  return(z)
}

median_vector = function(M, take = 'column'){
  M = as.matrix(M)
  n = nrow(M)
  p = ncol(M)
  if(take == 'column'){
    mv = c()
    for(i in 1:p){
      mv = cbind(mv, median(M[,i]))
    }
  }else if(take == 'row'){
    mv = c()
    for(i in 1:n){
      mv = rbind(mv, median(M[i,]))
    }
  }else{
    stop('Error in take: parameter incorrect.')
  }
  return(as.matrix(mv))
}

mean_vector = function(M, take = 'column'){
  M = as.matrix(M)
  n = nrow(M)
  p = ncol(M)
  if(take == 'column'){
    mv = c()
    for(i in 1:p){
      mv = cbind(mv, mean(M[,i]))
    }
  }else if(take == 'row'){
    mv = c()
    for(i in 1:n){
      mv = rbind(mv, mean(M[i,]))
    }
  }else{
    stop('Error in take: parameter incorrect.')
  }
  return(as.matrix(mv))
}

pss = function(M){
  M = as.matrix(M)
  n = nrow(M)
  # n*n matrix
  af_matrix = matrix(data = 1, nrow = n, ncol = n)
  for(i in 1:(n-1)){
    for(j in (i+1):n){
      if(sum(M[i,])==0||sum(M[j,])==0){
        pss = 0
        af_matrix[i,j] = af_matrix[j,i] = pss
      }else{
        ui = M[i,]
        uj = M[j,]
        rm = median_vector(M, take = 'column')
        muj = mean_vector(M, take = 'column')
        pss = sum(proxim(ui, uj)*signific(ui, uj, rm = rm)*singular(ui, uj, muj = muj))
        af_matrix[i,j] = af_matrix[j,i] = pss
      }
    }
  }
  return(as.data.frame(af_matrix))
}