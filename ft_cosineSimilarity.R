# cosine similarity function
cos_sim = function(M){
  M = as.matrix(M)
  library("lsa")
  n = nrow(M)
  # n*n matrix
  af_matrix = matrix(data = 1, nrow = n, ncol = n)
  for(i in 1:(n-1)){
    for(j in (i+1):n){
      if(sum(M[i,])==0||sum(M[j,])==0){
        cossim = 0
        af_matrix[i,j] = af_matrix[j,i] = cossim
      }else{
        cossim = cosine(M[i,],M[j,])
        af_matrix[i,j] = af_matrix[j,i] = cossim
      }
    }
  }
  return(as.data.frame(af_matrix))
}
