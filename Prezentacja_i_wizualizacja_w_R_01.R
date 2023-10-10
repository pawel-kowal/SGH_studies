rm(list=ls())
getwd()
setwd('D:/SGH/r1s1/Prezentacja i wizualizacja danych/PIWD_01/PIWD_01')

# ZADANIE 1

df_gold <- read.table(file = 'data/GOLD-ZLOTO.csv', sep=';', dec=',', header = T)
head(df_gold)

x11()
plot(df_gold$Otwarcie, type='l', col='green')

x11()
plot(df_gold$Zamkniecie, type='l', col='orange')

x11()
x <- df_gold$Otwarcie - df_gold$Zamkniecie
hist(x, col=c('red','blue'), breaks = 100)

# ZADANIE 2

rm(list=ls())

df <- read.table(file = 'data/95.csv', sep=';', dec='.', header=T)
str(df)

?as.POSIXct()
?as.POSIXlt()
?aggregate

df$Data_zmiany <- as.POSIXct(df$Data_zmiany)
df$cena_brutto <- (df$Cena + df$Akcyza + df$Oplata_paliwowa)/1000
x11()
plot(x=df$Data_zmiany,y=df$cena_brutto, type='l', col='grey')

print(head(df))

df$rok = as.POSIXlt(df$Data_zmiany)$year + 1900
df$miesiac <- as.POSIXlt(df$Data_zmiany)$mon + 1 

head(df)

aggr <- aggregate(cena_brutto~rok+miesiac,data=df,FUN=mean)
aggr <- aggr[order(aggr$rok,aggr$miesiac),]
print(head(aggr))

x11()
plot(aggr$cena_brutto,type="l",col="orange")

# ZADANIE 3
rm(list=ls())

df = read.table(file = 'data/PL_GEN_WIATR_20231010_20231010173514.csv', sep=';',dec=',', header = T)
print(head(df))
print(colnames(df))

?rbind
?lapply  

typeof(df$Generacja.źródeł.fotowoltaicznych)

plot(df$Generacja.źródeł.fotowoltaicznych)

skumulowana <- 0

for (i in 1:nrow(df)) {
  skumulowana <- skumulowana + df$Generacja.źródeł.fotowoltaicznych[i]
  df$fotowoltaicznych_skumulowane[i] <- skumulowana
}

plot(df$fotowoltaicznych_skumulowane)

