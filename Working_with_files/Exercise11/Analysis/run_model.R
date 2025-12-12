load("~/new_path.Rdata")

n=100000
p=10

beta = runif(p+1)
x = cbind(1,matrix(rnorm(n*p),n,p))
y = x %*% beta

write.csv(y, file=paste0(new_path,"/model_results.csv"))
