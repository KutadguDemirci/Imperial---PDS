x <- c(1, 4, 8)

q <- c(x, x, 8)
x <- x[2:3]
print(x)

k <- 0   # initialize counter
for (n in q)  {
  if (n %% 2 == 1) k <- k+1
}
print(k)
