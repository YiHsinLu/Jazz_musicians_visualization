# PSS function (proximity, significance, singularity)

#proxim = function(x,y){
#  expvalue = exp(-abs(x-y))
#  z = 1-(1/(1+expvalue))
#  return(z)
#}
#
#
#singular = function(x,y){
#  z = x
#  for(k in 1:length(x)){
#    muj = mean(M[,k])
#    expvalue = 0
#    xi = x[k]
#    yi = y[k]
#    rm = median(c(xi,yi))
#    expvalue = exp(-abs((xi-yi)/2-muj))
#    z[k] = 1/(1+expvalue)
#  }
#  return(z)
#}
#
#signific = function(x,y){
#  z = x
#  for(k in 1:length(x)){
#    expvalue = 0
#    xi = x[k]
#    yi = y[k]
#    rm = median(M[,k])
#    expvalue = exp(-abs(xi-rm)*abs(yi-rm))
#    z[k] = 1/(1+expvalue)
#  }
#  return(z)
#}

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
        prox = 1-(1/(1+exp(-abs(ui-uj))))
        signific = c()
        for(k in 1:length(ui)){
          rm = median(M[,k])
          signific_k = 1/(1+exp(-abs(ui[k]-rm)*abs(uj[k]-rm)))
          signific = rbind(signific, signific_k)
        }
        signific = as.matrix(signific)
        singular = c()
        for(k in 1:length(ui)){
          muj = mean(M[,k])
          singular_k = 1-1/(1+exp(-abs((ui[k]-uj[k])/2-muj)))
          singular = rbind(singular, singular_k)
        }
        singular = as.matrix(singular)
        pss = prox%*%signific[,1]%*%singular[,1]
        af_matrix[i,j] = af_matrix[j,i] = pss
      }
    }
  }
  return(as.data.frame(af_matrix))
}