# Pearson correlation function
std = function(x){
  return(sqrt(var(x)))
}
pear = function(M){
  M = as.matrix(M)
  n = nrow(M)
  # n*n matrix
  af_matrix = matrix(data = 1, nrow = n, ncol = n)
  for(i in 1:(n-1)){
    for(j in (i+1):n){
      if(sum(M[i,])==0||sum(M[j,])==0){
        pear = 0
        af_matrix[i,j] = af_matrix[j,i] = pear
      }else{
        ui = M[i,]
        uj = M[j,]
        ui_bar = mean(ui)
        uj_bar = mean(uj)
        pear = ((ui-ui_bar)%*%(uj-uj_bar))/(std(ui)*std(uj))
        af_matrix[i,j] = af_matrix[j,i] = pear
      }
    }
  }
  return(as.data.frame(af_matrix))
}
