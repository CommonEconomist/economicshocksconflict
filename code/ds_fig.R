#### Trends in conflict and precipitation over time ####
## Figure for README.md


## Libraries
library(plyr)
library(foreign)

## Data
d<-read.dta("tidy_data/dpe_2015.dta")

## Aggregate data 
d$dummy<-1 # Obs. dummy
fig<-ddply(d,.(year),summarise,
           countries=sum(dummy),
           conflict=sum(anyconflict),
           rainfall.g=median(gpcp_g),
           rainfall.a=median(gpcp_d))

## Variables to vectors
year<-fig$year
conflict<-fig$conflict/fig$countries
rain1<-fig$rainfall.g
rain2<-fig$rainfall.a

## Plot
par(mar=c(3,6,5,3),family="serif",mfrow=c(3,1))

# Rainfall deviation
plot(year,rain2,axes=FALSE,type="n",xlab="",ylab="",ylim=c(-1,1))
rect(2000,-1.1,2010,.7,col="grey90",lwd=0)                # New data period
lines(year,rain2,lwd=2,lty=2,col="grey10",type="b",ylim=c(-1,1)) 
axis(2,las=1,at=seq(-1,1,.5),cex.axis=1.5,tick=F)
text(1982,.8,"Rainfall \n (median deviation)",cex=1.7)

# Rainfall growth
plot(year,rain1,axes=FALSE,type="n",xlab="",ylab="",ylim=c(-.2,.2))
rect(2000,-.2,2010,.2,col="grey90",lwd=0)                
lines(year,rain1,lwd=2,lty=2,col="grey10",type="b",ylim=c(-.2,.2)) 
axis(2,las=1,at=seq(-.2,.2,.1),cex.axis=1.5,tick=F)
text(1982.5,.16,"Rainfall \n (median growth rate)",cex=1.7)

# Conflict incidence
plot(year,conflict,axes=FALSE,type="n",xlab="",ylab="",ylim=c(0,.3))
rect(2000,0,2010,.3,col="grey90",lwd=0)                
lines(year,conflict,lwd=2,lty=2,col="grey10",type="b",ylim=c(0,.3)) 
axis(2,las=1,at=seq(0,.3,.1),cex.axis=1.5,tick=F)
axis(1,at=seq(1981,2010,2),cex.axis=1.5,tick=F)
text(1983,.27,"Conflict \n (proportion of countries)",cex=1.7)
