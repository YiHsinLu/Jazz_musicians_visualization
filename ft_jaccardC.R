# Jaccard function
dis_jac.c = function(M, C=0){
  M = as.matrix(M)
  library("jaccard")
  n = nrow(M)
  # n*n matrix
  jaccard.c = function (x, y, c=0, center = FALSE, px = NULL, py = NULL) 
  {
    if (length(x) != length(y)) {
      stop("Two fingerprints (x and y) must be of the same length.")
    }
    if (is.null(px) | is.null(py)) {
      px <- mean(x)
      py <- mean(y)
    }
    sumxy <- sum(x & y)+c
    unionxy <- sum(x) + sum(y) - sumxy+2*c
    if (unionxy == 0) {
      j <- (px * py)/(px + py - px * py)
    }
    else {
      j <- sumxy/unionxy
    }
    if (center == FALSE) {
      return(j)
    }
    else {
      return(j - (px * py)/(px + py - px * py))
    }
  }
  af_matrix = matrix(data = 1, nrow = n, ncol = n)
  for(i in 1:(n-1)){
    for(j in (i+1):n){
      if(sum(M[i,])==0&sum(M[j,])==0){
        jac = 0
        af_matrix[i,j] = af_matrix[j,i] = jac
      }else{
        jac = jaccard.c(M[i,],M[j,], c=C)
        af_matrix[i,j] = af_matrix[j,i] = jac
      }
    }
  }
  colnames(af_matrix) = rownames(af_matrix) = rownames(M)
  return(as.data.frame(af_matrix))
}


jaccard.c = function (x, y, c=0, center = FALSE, px = NULL, py = NULL) 
{
  if (length(x) != length(y)) {
    stop("Two fingerprints (x and y) must be of the same length.")
  }
  if (is.null(px) | is.null(py)) {
    px <- mean(x)
    py <- mean(y)
  }
  sumxy <- sum(x & y)+c
  unionxy <- sum(x) + sum(y) - sumxy+2*c
  if (unionxy == 0) {
    j <- (px * py)/(px + py - px * py)
  }
  else {
    j <- sumxy/unionxy
  }
  if (center == FALSE) {
    return(j)
  }
  else {
    return(j - (px * py)/(px + py - px * py))
  }
}