# bloki kodu
{
  n <- 10^2
  d <- data.frame(
    x = sort(rnorm(n)), 
    y = cumsum(rnorm(n))
  )
  x11()
  plot(d$x, d$y, type='o', col='maroon')
  lines(lowess(d$x, d$y), col = 'red', lwd=4)
}

x <- data.frame(matrix(1:10, ncol=2, nrow=5))
x

with(x, (X1 + X2))

n <- 10^3
d <- data.frame(
  x = sort(rnorm(n)),
  y = cumsum(rnorm(n))
)
head(d)

# klauzula with
with(
  d,
  {
    x11()
    plot(x, y, pch=20, type='o', col='maroon')
    lines(lowess(d$x, d$y), col = 'red', lwd=4)
    grid()
  }
)

# insturkcje warunkowe

x <- c(T,F,T)
y <- c(F,T,T)

x & y
x | y
xor(x,y)

2 > 0
2 >= 0
2 == '2'

identical(2,2)
identical(2,"2")
identical(1:4, c(1,2,3,4))

x<-2
if (x>0){
  print('OK')
}else{
  print('nie ok')
}

k <- 3
switch(k,
       (print('1')),
       (print('2')),
       (print('3')))

switch(k,
       "poz1" = (print('1')),
       "poz2" = (print('2')),
      "poz3" = (print('3')))

x <- round(rnorm(10),3)
y <- 1:10
ifelse(x>0, x, y)

n <- 10^3
d <- data.frame(
  x=sort(rnorm(n)),
  y = cumsum(rnorm(n))
)

d <- cbind(d, data.frame(class = ifelse(abs(d$x/d$y)>1, 'red', 'blue')))

with(
  d,
  plot(x, y, col=class, pch = 20)
)

# petle

for (i in 1:5) {
  print(i)
}

for (f in list(sin, cos, log, exp)) {
  print(f(1))
}

for (f in dir()) {
  print(paste("----", f))
  print(file.info(f)$size)
}

for (f in dir(path = "../", full.names = T,
              recursive = T)) {
  print(file.info(f)$size)
}

for (j in 1:5) {
  print(paste("------ j =", as.character((j))))
    for (k in 1:j){
      print(paste("k =", as.character(k)))
    }
}


x <- rnorm(1, mean = .07)
while (x>0) {
  print(x)
  x <- rnorm(1, mean = .07)
}

for (j in 1:7) {
  if (j == 3L) break
  print(j)
}

for (j in 1:5) {
  print(paste("-- j ="), as.character(j))
  for (k in 1:4) {
    if (k == 3L) break
    print(k)
  }
}

for (j in 1:7) {
  if (j == 3L) next
  print(j)
}

# funkcje

f <- function() {}
f
typeof(f)
class(f)
f()

f <- function() {
  print('hi')
}
f
f()

f <- function(x) {
  sqrt(x)
}

f(4)

g <- function(x) {
  if (x>0) {
    return(sqrt(x))
  }
  else {
    return(sqrt(as.complex(x)))
  }
}

f(-4)
g(-4)
