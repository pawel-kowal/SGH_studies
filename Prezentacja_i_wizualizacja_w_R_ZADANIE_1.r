rm(list=ls())
options(width=200)

zapotrzebowanie <- read.table(file="data/demand.csv",sep=";",dec=".",header=T)
zapotrzebowanie <- zapotrzebowanie[,c(1,3)]
colnames(zapotrzebowanie) <- c("Timestamp","Zapotrzebowanie")

zapotrzebowanie <- zapotrzebowanie[as.Date(zapotrzebowanie$Timestamp) >= as.Date("2021-01-01"),]
zapotrzebowanie <- zapotrzebowanie[as.Date(zapotrzebowanie$Timestamp) < as.Date("2023-10-01"),]

zapotrzebowanie$RokMiesiac <- substr(zapotrzebowanie$Timestamp,1,7)

print(head(zapotrzebowanie))
zapotrzebowanie <- aggregate(Zapotrzebowanie~RokMiesiac,data=zapotrzebowanie,FUN=sum,na.rm=T)
print(head(zapotrzebowanie))

oze <- read.table(file="data/generation.csv",sep=";",dec=".",header=T)
oze <- oze[c("Timestamp","Solar","Wind_Onshore")]
colnames(oze)[2:3] <- c("PV","Wiatr")
print(head(oze))

oze <- oze[as.Date(oze$Timestamp) >= as.Date("2021-01-01"),]
oze <- oze[as.Date(oze$Timestamp) < as.Date("2023-10-01"),]
oze$RokMiesiac <- substr(oze$Timestamp,1,7)
print(head(oze))

oze <- aggregate(cbind(Wiatr,PV)~RokMiesiac,data=oze,FUN=sum,na.rm=T)
oze$OZE <- oze$Wiatr + oze$PV
print(head(oze))

d <- merge(x=zapotrzebowanie,y=oze,by="RokMiesiac")
d$proc_oze <- 100*(d$OZE/d$Zapotrzebowanie)
d <- d[order(d$RokMiesiac),]
d$id <- 1:nrow(d)
print(d)
model <- lm(d$proc_oze~id,data=d)
 
print(model$coefficients[2])
print(12*model$coefficients[2])

# WYKRES 1

bmp(file="zadanie_1_1.bmp",width = 3*480, height = 2*480)
plot(d$proc_oze,type = 'b',col = 'red',main="Produkcja OZE do zapotrzebowania na moc w Polsce\nw miesi¹cach 2021.01 - 2023.09",cex.main = 2,pch = 19,axes = F,xlab = "[Miesi¹c]",ylab = "[%]",ylim = c(0, 30))
axis(2, at = seq(0, 30, by = 5))
grid(nx=20,ny=30) 
abline(model, col = "blue", lty = 2)
text_pasted <- paste("Wzrost roczny:", round(12*model$coefficients[2], digits=3), "%\n\nWzrost miesiêczny:", round(model$coefficients[2], digits=3), "%")
mtext(text_pasted, side = 3, line = -6, col = "red", cex = 1.5)
text_right <- "ród³o danych: ENTSOE Transparency Platform\nhttps://transparency.entsoe.eu/"
mtext(text_right, side=4, at=13, cex=1.14)
labelsX <- d$RokMiesiac
labelsY <- d$proc_oze
labelsY_rounded <- round(labelsY, digits=2)
text(d$id, d$proc_oze - 1, labelsX, pos=1, col="grey", cex=0.75, srt=90)
text(d$id, d$proc_oze + 1.5, labelsY_rounded, pos=1, col="black", cex=0.75)
dev.off()

# WYKRES 2

oze$udzial_wiatr <- oze$Wiatr / (oze$Wiatr + oze$PV) * d$proc_oze
oze$udzial_PV <- oze$PV / (oze$Wiatr + oze$PV) * d$proc_oze

bmp(file="zadanie_1_2.bmp", width = 3*480, height = 2*480)
par(mfrow=c(2,1))
bp1<-barplot(t(oze[c('Wiatr','PV')]),col=c("blue","yellow"),beside=T, main="Produkcja OZE do zapotrzebowania na moc w Polsce \nw miesi¹cach 2021.01 - 2023.09", ylab="[MWh/miesi¹c]",axes=T)
legend("topleft", legend = c("Wiatr", "PV"), fill = c("blue", "yellow"))
axis(1, at = colMeans(bp1), labels = oze$RokMiesiac, las=2, cex.axis = 0.8, tick = FALSE)
bp2<-barplot(t(oze[c('udzial_wiatr','udzial_PV')]),col=c("blue","yellow"),ylim=c(0,100),ylab = "[%]",axes=T)
for (i in c(20,40,60,80)){
  abline(h = i, col = "grey", lty = "dotted")
}
legend("topleft", legend = c("Wiatr", "PV"), fill = c("blue", "yellow"))
axis(1, at = bp2, labels = oze$RokMiesiac, las=2, cex.axis = 0.8,tick = FALSE)
text_right <- "ród³o danych: ENTSOE Transparency Platform\nhttps://transparency.entsoe.eu/"
mtext(text_right, side=4, cex=1.14)
dev.off()


