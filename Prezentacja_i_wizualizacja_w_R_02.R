getwd()
d <- read.csv('data/generation.csv', sep=';', dec='.', header = T)
d
print(str(d))
print(head(d))

# W jednym ukladzie wspolrzednych zwizualizowac szeregi czasowe produkcji energii elektrycznej 
# w podziale na glowne zrodla w granulacji godzinowej. 
# Wynik zapisac do pliku pdf.

d$Timestamp <- as.POSIXct(d$Timestamp, tz = 'GMT')
d <- d[
  (d$Timestamp >= as.POSIXct("2022-01-01 00:00:00")
  &
  d$Timestamp < as.POSIXct("2023-01-10 00:00:00")), 
  ]

x11()
plot(
  x = d$Timestamp,
  y = d$Solar,
  col = 'red',
  type = 'l'
)


d$mon <- as.POSIXlt(d$Timestamp)$mon
d$hour <- as.POSIXlt(d$Timestamp)$hour

x11()
boxplot( Solar~mon, data=d, col=heat.colors(12))

x11()
boxplot( Solar~hour, data=d, col=heat.colors(24))

d$Fossil <- (d$Fossil_Brown_coal_Lignite
             + d$Fossil_Coal_derived_gas
             + d$Fossil_Gas
             + d$Fossil_Hard_coal
             + d$Fossil_Oil)
d <- d[c('Fossil', 'Solar', 'Wind')]

aggr <- apply(d, 2, sum)
aggr <- round(100*aggr/sum(aggr))
print(aggr)

x11()
pie(aggr, col=rainbow(3))




