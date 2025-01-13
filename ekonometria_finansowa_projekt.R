rm(list = ls())

require(zoo)
require(xts)
require(moments)
require(forecast)
require(tseries)
require(rugarch)
require(knitr)
require(ggplot2)
source("Block2Functions.R")

###################### 0. Ładowanie danych ######################

filename <- "wig20.Rdata"
load(filename)

dates     <- index(data) 
names(data)
startDate <- as.Date("2005-01-01")
endDate   <- as.Date("2050-01-01")
y         <- window(data, start=startDate, end=endDate)
y         <- na.omit(y[,c("pkn","cdr")])

# log returns of stocks
dy  <- 100*diff(log(y))

# porfolio weights
w   <- c(0.5,0.5)

# portfolio returns
r   <- zoo(dy%*%w,index(dy))
R   <- as.numeric(coredata(r))

# the value of investment in the portfolio
P   <- exp(cumsum(r/100))

###################### ZADANIE 1. ######################

par(mfrow=c(2,1), cex = 0.75, bty="l")

# Plot for portfolio returns
plot(P, main="price")
# Plot for portfolio log returns
plot(r, main="log returns"); abline(h=0)

# Moments
Nyear <- 365/as.numeric(mean(diff(dates)))
mu    <- mean(r)*Nyear
sig   <- sd(r)*sqrt(Nyear) 
mom <- as.data.frame(c(Nyear,mu,sig,min(r),max(r), skewness(r), kurtosis(r),jarque.bera.test(R)$stat))
rownames(mom) <- c("N","mu","sig","min","max","skew","kurt", "JB test"); colnames(mom)="value"
kable(mom, digits=3)

# QQ plot
v = 4 + 6/(kurtosis(R)-3)
Rstar <- (R-mean(R))/sd(R)
q     <- seq(1/length(Rstar),1-1/length(Rstar), 1/length(Rstar))
Qteo  <- qdist("std",p=q,shape=v)
Qemp  <- quantile(Rstar,q)
QQtab = data.frame(Qteo,Qemp)
ggplot(QQtab) + 
  geom_point(aes(x=Qemp, y=Qteo), size=2,shape=23, col="blue")+
  theme_light()+
  labs(title="QQ plot") +
  xlim(min(QQtab),max(QQtab))+ylim(min(QQtab),max(QQtab)) +
  geom_abline(intercept=0, slope=1, size=1)

# ACF
Acf(R, main="ACF of daily returns" )

# ACF of squared returns
Acf(R^2, main="ACF of squared daily returns" )

###################### ZADANIE 2. ######################

LagSel <- function(x, Pmax=4, Qmax=4, crit="SIC", dist="norm"){
  IC <- matrix(NA, Pmax, Qmax+1)
  for(p in 1:Pmax){
    for(q in 0:Qmax){
      
      spec = ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(p,q)), 
                        mean.model=list(armaOrder=c(0,0), include.mean=TRUE),  
                        distribution.model=dist)
      fit  = ugarchfit(data=x, spec=spec)
      if(crit == "AIC"){IC[p,q+1] <- infocriteria(fit)[1] }
      if(crit == "SIC"){IC[p,q+1] <- infocriteria(fit)[2] }
      if(crit == "HQ"){	IC[p,q+1] <- infocriteria(fit)[4] }
    }
  }
  rownames(IC) <- paste('p=',1:Pmax, sep="")
  colnames(IC) <- paste('q=',0:Qmax, sep="")
  return(IC)
}

# Choosing the best model
ICtab <- LagSel(r,4,4,crit="SIC", dist="std")
kable(ICtab,digits=3)


pq   = c(1,1)
PQ   = c(0,0)
dist = "std"
spec1 = ugarchspec(variance.model=list(model="sGARCH", garchOrder=pq), 
                   mean.model=list(armaOrder=PQ, include.mean=TRUE),  
                   distribution.model=dist)
fit1 = ugarchfit(data=r, spec=spec1)

# Parameter estimates (full table)
print(fit1)

# Plot for conditional standard deviation
plot(fit1, which=12)

###################### ZADANIE 3. ######################

H <- c(1, 10)
p <- c(0.01, 0.05)

# Placeholder for VaR/ES results
VaR_ES_table <- data.frame(
  Method = rep(c("HS", "t-Student", "Normal", "EWMA", "Best GARCH", "DCC-GARCH"), each = 4),  # 4 wiersze dla każdej metody
  Horizon = rep(c(1, 1, 10, 10), times = 6),  # Horyzonty 1 i 10 dla każdej z metod
  p = rep(c(0.01, 0.05), times = 12),  # Poziomy p: 1% i 5% dla każdej metody
  VaR = NA,  # Przestrzeń na wartości VaR
  ES = NA    # Przestrzeń na wartości ES
)
VaR_ES_table$Method <- factor(VaR_ES_table$Method, levels = c("HS", "t-Student", "Normal", "EWMA", "Best GARCH", "DCC-GARCH"))
VaR_ES_table <- VaR_ES_table[order(VaR_ES_table$Method), ]

# Historical Simulation (HS)
Nsim    <- 10000
Rdraws <- matrix(sample(R, Nsim*H[2], replace=TRUE), max(H), Nsim)
temp001 <- RdrawsToVaRES(Rdraws, p[1])
temp005 <- RdrawsToVaRES(Rdraws, p[2])
VaR_ES_table[VaR_ES_table$Method == "HS" & VaR_ES_table$p == 0.01 & VaR_ES_table$Horizon == 1, c("VaR", "ES")] <- c(temp001$VaR[1], temp001$ES[1])
VaR_ES_table[VaR_ES_table$Method == "HS" & VaR_ES_table$p == 0.05 & VaR_ES_table$Horizon == 1, c("VaR", "ES")] <- c(temp005$VaR[1], temp005$ES[1])
VaR_ES_table[VaR_ES_table$Method == "HS" & VaR_ES_table$p == 0.01 & VaR_ES_table$Horizon == 10, c("VaR", "ES")] <- c(temp001$VaR[10], temp001$ES[10])
VaR_ES_table[VaR_ES_table$Method == "HS" & VaR_ES_table$p == 0.05 & VaR_ES_table$Horizon == 10, c("VaR", "ES")] <- c(temp005$VaR[10], temp005$ES[10])


# Normal Distribution
m   <- mean(R) 
s   <- sd(R)

for (i in 1:length(H)) {
  VaR_ES_table[VaR_ES_table$Method == "Normal" & VaR_ES_table$Horizon == H[i], "VaR"] <- sqrt(H[i]) * qnorm(p) * s + (H[i]) * m
  VaR_ES_table[VaR_ES_table$Method == "Normal" & VaR_ES_table$Horizon == H[i], "ES"] <- (H[i]) * m - sqrt(H[i]) * s * dnorm(qnorm(p)) / p
}

# t-Student Distribution
v = 5
Nsim    <- 10000

for (i in 1:length(p)){
  VaRt  <- m + s*qdist("std",shape=v,p=p[i])
  qf    <- function(x) qdist("std", p=x, shape=v)
  ESt   <- m + s*(1/p[i] * integrate(qf, 0, p[i])$value)
  VaR_ES_table[VaR_ES_table$Method == "t-Student" & VaR_ES_table$p == p[i] & VaR_ES_table$Horizon == 1, c("VaR", "ES")] <- c(VaRt, ESt)
}


H = 10
for (i in 1:length(p)){
  print(p[i])
  Nsim    <- 10000
  Rdraws  <- matrix(rdist(distribution="std", Nsim*H, mu = m, sigma = s, shape = v),H,Nsim) 
  RdrawsC <- apply(Rdraws,2,cumsum)          
  VaRHt   <- ESHt <- rep(NaN,H)
  M0  <- floor(Nsim*p[i])     
  for(h in 1:H){
    temp   = sort(RdrawsC[h,])
    VaRHt[h] = temp[M0]
    ESHt[h]  = mean(temp[1:M0])
  }
  VaR_ES_table[VaR_ES_table$Method == "t-Student" & VaR_ES_table$p == p[i] & VaR_ES_table$Horizon == 10, c("VaR", "ES")] <- c(VaRHt[10], ESHt[10])
}
H <- c(1, 10)


# EWMA (Exponentially Weighted Moving Average) ----- NIE JESTEM PEWIEN TEGO!!!!!!!!!!!!!!!!!
lambda <- 0.94
ewma_var <- function(r, lambda = 0.94) {
  var <- rep(NA, length(r))
  var[1] <- var(r)  # Na podstawie całego wektora r
  for (i in 2:length(r)) {
    var[i] <- lambda * var[i-1] + (1 - lambda) * r[i-1]^2
  }
  return(var)
}

ewma_volatility <- sqrt(ewma_var(r))

for (h in H) {
  scaled_volatility <- ewma_volatility * sqrt(h)
  for (prob in p) {
    VaR_value <- quantile(scaled_volatility, prob)
    ES_value <- mean(scaled_volatility[scaled_volatility <= VaR_value])
    
    VaR_ES_table[VaR_ES_table$Method == "EWMA" &
                   VaR_ES_table$Horizon == h &
                   VaR_ES_table$p == prob, c("VaR", "ES")] <- c(VaR_value, ES_value)
  }
}


# Best GARCH Model
pq <- c(1, 1)  # Use the results from your LagSel function (best p, q)
specGARCH <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = pq), 
                        mean.model = list(armaOrder = c(0, 0), include.mean = TRUE),  
                        distribution.model = "std")
fitGARCH <- ugarchfit(data = r, spec = specGARCH)
volatilityGARCH <- sigma(fitGARCH)
for (h in H) {
  scaled_volatility <- volatilityGARCH * sqrt(h)  # Skalowanie zmienności dla horyzontu H
  for (p_val in p) {
    VaR <- quantile(scaled_volatility, p_val)
    ES <- mean(scaled_volatility[scaled_volatility <= VaR])
    VaR_ES_table[VaR_ES_table$Method == "Best GARCH" & VaR_ES_table$Horizon == h & VaR_ES_table$p == p_val, "VaR"] <- VaR
    VaR_ES_table[VaR_ES_table$Method == "Best GARCH" & VaR_ES_table$Horizon == h & VaR_ES_table$p == p_val, "ES"] <- ES
  }
}


# DCC-GARCH
mod  = "gjrGARCH"
pq   = c(1,1)
PQ   = c(0,0)
dist = "std" 
specU = ugarchspec(variance.model=list(model=mod, garchOrder=pq), 
                  mean.model=list(armaOrder=PQ, include.mean=TRUE), 
                  distribution.model=dist)
mspec = multispec(c(specU, specU))
specDCC <- dccspec(mspec, dccOrder = c(1,1), model = "DCC")
fitDCC  <- dccfit(specDCC,dy)  # start.pars = list())
fitDCC

H <- 10      
p <- c(0.01, 0.05)         
Nsim   <- 10000 
simDCC <- dccsim(fitDCC, n.sim = H, m.sim = Nsim, startMethod = c("sample"), rseed = 7)

draws  <- simDCC@msim$simX 

Rdraws <- matrix(NA,H,Nsim)
for (m in 1:Nsim){
  Rdraws[,m]  = draws[[m]]%*%w
}

for (j in 1:length(p)){
  print(p[j])
  temp <- RdrawsToVaRES(Rdraws, p[j])
  VaRHdcc   <- temp$VaR[10]
  ESHdcc    <- temp$ES[10]
  print(VaRHdcc)
  print(ESHdcc)
  VaR_ES_table[VaR_ES_table$Method == "DCC-GARCH" & VaR_ES_table$p == p[j] & VaR_ES_table$Horizon==10, c("VaR", "ES")] <- c(VaRHdcc, ESHdcc)
}



RDrawsToVaRES <- function(RDraws, p) {
  H    <- dim(RDraws)[1]  # Liczba dni horyzontu
  NSim <- dim(RDraws)[2]  # Liczba symulacji
  
  # Kumulatywne zwroty
  RDrawsC <- apply(RDraws, 2, cumsum)  # Sumowanie kumulatywne wzdłuż kolumn
  
  VaR  <- rep(NaN, H)
  ES   <- rep(NaN, H)
  
  M0 <- floor(NSim * p)  # Indeks odpowiadający kwantylowi
  
  for (h in 1:H) {
    temp   <- sort(RDrawsC[h, ])
    VaR[h] <- temp[M0]
    ES[h]  <- mean(temp[1:M0])
  }
  
  return(list(VaR = VaR, ES = ES))
}

H <- 1    
for (m in 1:Nsim){
  Rdraws[,m]  = draws[[m]]%*%w
}

for (j in 1:length(p)){
  print(p[j])
  temp <- RdrawsToVaRES(Rdraws, p[j])
  VaRHdcc   <- temp$VaR
  ESHdcc    <- temp$ES
  print(VaRHdcc)
  print(ESHdcc)
  VaR_ES_table[VaR_ES_table$Method == "DCC-GARCH" & VaR_ES_table$p == p[j] & VaR_ES_table$Horizon==1, c("VaR", "ES")] <- c(VaRHdcc, ESHdcc)
}


kable(VaR_ES_table, digits = 2)

