cor = function(x){
  #x      = x[,3:ncol(x)] 
  n      = nrow(x)
  p      = ncol(x)
  one    = matrix(1,n,n)
  
  h      = diag(1,n,n)-one/n             #centering the matrix
  a      = x-matrix(apply(x,2,mean),n,p,byrow=T) #substracts mean
  d      = diag(1/sqrt(colSums(a^2)/n))
  xs     = h%*%as.matrix(x)%*%d         #standardized data
  xs1    = xs/sqrt(n)
  xs2    = t(xs1)%*%xs1
  eig    = eigen(xs2) #spectral decomposition
  lambda = eig$values
  gamma  = eig$vectors
  
  w      = gamma*(matrix(sqrt(lambda),nrow=nrow(gamma),ncol=ncol(gamma),byrow=T)) #coordinates of food
  w      = w[,1:2]  
  w      = round(w,3)
  
  z1     = xs1%*%gamma #coordinates of families
  z2     = sqrt(n/p)*z1 
  z      = z2[,1:2] 
  z      = round(z,3)
  
  namew  = colnames(x)
  namez  = rownames(x)
  return(list(w = w, z = z, namew = namew, namez = namez))
}
