zoomin = function(M, center, v1, v2){
  cpt = M[center, 1:2]
  M[,1] = M[,1]-cpt$v1
  M[,2] = M[,2]-cpt$v2
  return(M)
}