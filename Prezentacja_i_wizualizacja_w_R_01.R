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
