# Jaccard function
dis_jac = function(M){
  M = as.matrix(M)
  library("jaccard")
  n = nrow(M)
  # n*n matrix
  af_matrix = matrix(data = 1, nrow = n, ncol = n)
  for(i in 1:(n-1)){
    for(j in (i+1):n){
      jac = jaccard(M[i,],M[j,])
      af_matrix[i,j] = af_matrix[j,i] = jac
    }
  }
  return(as.data.frame(af_matrix))
}
