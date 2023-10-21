# MACIERZE

matrix(1:9, 3,3)
matrix(1:6, 3:2)
matrix(1:9, 3:3,byrow=T)

array(1:9, c(3,3))
array(1:8, c(2,2,2))

cbind(1:5, 5:1)
rbind(1:5, 5:1)

a<- matrix(1:9, 3:3)
typeof(a)
a
class(a)
dim(a)

b <- 1:9
b
dim(b) <- c(3,3)
b

c <- array(1:8, c(2,2,2))
class(c)

rm(list = ls())

a <- matrix(round(rnorm(16), 2), 4,4)
b <- matrix(round(rnorm(16), 2), 4,4)

sin(a)
log(a)

log(as.complex(a))
a
a^2

length(a)
mean(a)
sum(a)

# OPERACJE NA MACIERZACH

2*a
a+b
#wyznacznik
det(a)
det(b)
#transpozycja
t(a)
#odwrotna
solve(a)
#mnożenie algebraiczne
solve(a) %*% a
round(solve(a) %*% a,10)
#singular value decomposition
svd(a)
#wartości własne
eigen(a)

a+b
a+c(100,0)

rm(a)

#INDEKSOWANIE MACIERZY

a <- matrix(1:9, 3,3)
solve(a)
det(a)
a[1]
a[2]
a[3]

a[4:6]
a[1,1]
a[2,3]
a[1:2, 2:3]
a[1:2, ]
a[,2:3]

a[as.vector(a)>5]
a[a>5]

b <- matrix(round(rnorm(6*7),2),7,6)

b[, 1]>0
b[b[,1]>0, ]

b[,b[5,]>0]

b[b[,1]>0,b[5,]>0]

colnames(b) <- LETTERS[1:6]
rownames(b) <- letters[1:7]

b['a', 'A']
b['a', ]
b[c('b','c'),]

b[b[,1]>0, c('A', 'C')]
b[b[,1]>0, 1:4]

b
b[,'D']
b[,'D', drop = F]

# LISTY

a <- list(pierwsze = T,
          drugie = 5:1,
          trzecie = list(
            "pierwsze pole" = sin,
            "drugie pole" = cos
          ),
          drugie = pi,
          555
          )


a <- list(a = 5,
          b = 56,
          c = 'ala')
a

c(a, 'nowe pole' = 123)
c('nowe pole' = 123, a)

c(a, list("nowe pole" = 5))
c(a, list("nowe pole" = 5, "kolejne pole" = 100))

a[['nowy klucz']] <- 1:10
a[[5]] <- 'ala ma kota'

a[[100]] <- 'setny element'

a <- a[-(4:100)]

a$b<- NULL
a

a[['c']] <- NULL
a

a[3] <- 5
a

a <- list(a=5, b=56, c='ala')
a$b <- sin
a

a[['b']] <- cos
a

names(a)
names(a) <- c('nk1', 'nk2', 'nk3')
a

rm(list = ls())

# INDEKSOWANIE LIST

d <- list(a=5,
          b=2,
          'klucz 3' = T,
          b = 'ala',
          123)

d$a
d$b
d$'klucz 3'
d$'a'

a <- "klucz 3"
d$a

class(d)
d[1]
class(d[1])
class(d[[1]])

d[1:3]

names(d)
d['a']
d[c('a', 'klucz 3')]

d[['a']]
a<- 'klucz 3'
d[[a]]
d[[5]]
d[(1:3)]

rm(list=ls())

# RAMKI DANYCH (DATA FRAME)

a <- data.frame(id = 1:5,
                value = rnorm(5))
a

b <- list(id = 1:5,
          value = rnorm(5))

as.data.frame(b)

attributes(a)
attributes(b)

class(a)
class(b) <- 'data.frame'
b

rownames(a) <-1:5
a

d <- read.csv(file = 'http://michal.ramsza.org/temp/cars.csv',
              header = T)

head(d)
colnames(d)
class(d)
dim(d)
tail(d)

sort(unique(d$Voivodeship))

head(d)
options(width = 140)
head(d)
options(width = 80)
head(d)

summary(d)

# INDEKSOWANIE DF

d <- data.frame(
  id=1:10,
  value = round(rnorm(10),3),
  class = sample(LETTERS[1:2], 10, replace = T)
)
d

names(d)
d$id
d$value
d[1]
d[2]
d['value']
d[1:3,1:3]

d[d$value>0, ]
d[d$value>0, c('id','class')]
d[d$value>0, c('id','class')]$value
d[d$value>0, c('id','class')]$class


