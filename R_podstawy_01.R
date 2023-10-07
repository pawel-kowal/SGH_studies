## wstęp - podstawy

print(
  'Hello world!!!'
)

for (i in 1:10){
  cat("Hello world!!!\n")
}
rm(i)

x <- rnorm(10^3)

hist (
  x,
  probability = T,
  main = 'Pierwszy histogram',
  xlab = 'Wartości',
  ylab = 'Gęstości',
  col = 'green',
  density = 20,
  angle = 45,
  xlim = c(-5,5),
  ylim = c(0, 0.5)
)

lines(density(x, adjust = 1.5), col='#0be99f', lwd=2)

grid(col = 'cyan')

## pomoc

help()
help('plot')
help('plot', package='base')
?plot
?base:plot

example(plot)

apropos("test")

help.search("normality test")


## typy danych

typeof(T)
typeof(F)

typeof(2L)
typeof(2L+3L)

typeof(2)
typeof(3.14)

typeof(3+4i)

typeof(plot)
typeof(function(){})

typeof(globalenv())

typeof(quote(sin(pi/2)))

## wektory

x <- rnorm(10)
x[1]
x[length(x)]

c(4, 7, 2)
c(c(4,5), c(2,5,8))

x <- c(pierwsza = 4, druga = 6, ostatnia = 123)
x['pierwsza']
x[1]

y <- c("pierwsza pozycja" = 4, druga = 6, ostatnia = 123)
y

rm(x,y)

## wektory - generacja automatyczna

1:5
1.13:5
5:1
5.25:1
5:-5
-5:5

2*2:7
(2*2):7
2:2^3

seq(0, 1, 0.1)
seq(from = 0, to = 1, by=0.2)
seq(from = 0, to = 1, length.out = 13)
seq(0, 1, along.with = 1:5)

seq_along(5:1)
seq_len(length.out = 5)

rep(0, 10)
rep(1:4, 5)
rep(c('a','d','f'),5)

## wektory - operacje na nich

x <- 1:5
x
log(x)
exp(x)
length(x)

x <- rnorm(10)
mean(x)
range(x)
quantile(x, .25)
sd(x)
min(x)
max(x)

x <- -1:1
y <- 1:3
x+y
x%*%y
sqrt(x%*%y)

x <- c(1,0)
y <- c(2,3,4,5)

x+y

x <- c(1,0)
y <- c(2,3,4)
x+y

## wektory - typy

c(T, F)
c(4L, 6L)
c(4.13,6.78)
c(4-5i, 3+31i)
c('ala','ma','kota')

c(list(1), list(5))
c(sin, cos)

c(4, NA, 5)
c(4, NaN, 7)
sqrt(-1)
sqrt(-1+0i)
log(-1)
log(-1+0i)
c(4, Inf, 5)
1/0
log(0)
1/Inf
exp(-Inf)
sin(0)/0

c(T,F,5L)
c(T,F,5L, 3.14)
c(T,F,5L, 3.14, 5+3i)
c(T,F,5L, 3.14, 5+3i, 'hello')

## wektory - indeksowanie
x <- 5:1
x
x[1]
x[5]
x[length(x)]
x[length(x)-1]
x[c(1,3,5)]
x[c(5,3,1)]
x[1:3]
x[2:4]
x[0]
x[7]
x[-1]
x[-2]
x[-(2:4)]
x[-length(x)]

x[1] <- 123
x
x[2:4] <- 0
x
x[1:4] <- 1:2
x
x[1:4] <- 1:3
x

x <- -1:1
x
x[c(T,F,T)]

y <- 1:10
y
y[c(T,F)]

y <- round(rnorm(50), 2)
y

y[y>0]
y[!(y>0)]
y[y>0 & y<1]
y[(y>0) & (y<1)]
y[(y < -1)|(y > 1)]
y[abs(mean(y) - y) < .5]
