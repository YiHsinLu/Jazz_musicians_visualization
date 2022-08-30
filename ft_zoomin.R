zoomin = function(M, center){
  cpt = M[center, 1:2]
  colnames(cpt) = c('v1', 'v2')
  M[,1] = M[,1]-cpt$v1
  M[,2] = M[,2]-cpt$v2
  return(M)
}