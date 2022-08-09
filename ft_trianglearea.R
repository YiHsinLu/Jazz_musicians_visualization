# Triangle Area measure function
TA = function(M){
  M = as.matrix(M)
  n = nrow(M)
  # n*n matrix
  af_matrix = matrix(data = 1, nrow = n, ncol = n)
  for(i in 1:(n-1)){
    for(j in (i+1):n){
      if(sum(M[i,])==0||sum(M[j,])==0){
        ta = 0
        af_matrix[i,j] = af_matrix[j,i] = ta
      }else{
        ui = M[i,]
        uj = M[j,]
        lui = sqrt(sum(ui^2))
        luj = sqrt(sum(uj^2))
        if(lui<=luj){
          ta = ((ui%*%uj)^2)/(lui*(luj)^3)
          af_matrix[i,j] = af_matrix[j,i] = ta
        }else{
          ta = ((ui%*%uj)^2)/(luj*(lui)^3)
          af_matrix[i,j] = af_matrix[j,i] = ta
        }
      }
    }
  }
  return(as.data.frame(af_matrix))
}
