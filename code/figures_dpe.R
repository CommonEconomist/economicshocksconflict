#******************************************************************************
# Replication code (figures) for                                              #
# "Economic Shocks & Civil Conflict in Sub-Saharan Africa 1981-2010"          #
# Published in Defence and Peace Economics, 2015, 26 (2)                      #
# http://www.tandfonline.com/doi/full/10.1080/10242694.2014.887489            #
#******************************************************************************

# This version:  07-12-2014                                                   *
# First version: 07-12-2013                                                   *

setwd("[DIR]/Publications/DPE_2015")

## Load libraries
library(maps)
library(maptools)
library(mapdata)
library(mapproj)
library(sp)
library(foreign)
library(RColorBrewer)
library(classInt)

## Load data
d<-read.dta("tidy_data/dpe_2015.dta")
africa<-readShapeSpatial("raw_data/shp/africa.shp") # Check whether path is correct
data<-read.csv("tidy_data/map_data.csv",header=TRUE)

#### FIGURE1: Geographic raster at 2.5 and 0.5 degrees resolution ####

# Margin settings
par(mar=c(2,2,2,2))

# Plot Congo basin
congobasin25<-map('worldHires',c('Rwanda','Burundi','Tanzania','Malawi',
                       'Zambia','Congo', 'Zaire', 'Mozambique',
                       'Angola','Uganda', 'Kenya','Zimbabwe','Botswana', 
                       'Namibia'),col="gray90",fill=T,mar=rep(0,4))

# Label axis latitude and longitude
degAxis(2)
degAxis(1)

# Create the grid at 2.5 degrees
map.grid(c(10, 42.5, -32.5, 7.5),nx=14,ny=17,labels=F, col=1, pretty=FALSE)

# Grid at 0.5 degrees
congobasin05<-map('worldHires',c('Rwanda','Burundi','Tanzania','Malawi',
                                 'Zambia','Congo', 'Zaire', 'Mozambique',
                                 'Angola','Uganda', 'Kenya','Zimbabwe',
                                 'Botswana', 'Namibia'),col="gray90",
                  fill=T,mar=rep(0,4))
degAxis(2)
degAxis(1)
map.grid(c(10, 42.5, -32.5, 7.5),nx=70,ny=85,labels=F, col=1, pretty=FALSE)

#### FIGURE 2: Example rainfall ####

## Take Sudan as example
rain<-d[d$countrycode=="SDN",]$gpcp
rain<-rain[5:15]
x<-0:10

# Plot
plot(x,rain,type="h",lwd=10,lend=3,col="steelblue4",axes=FALSE,xlab="",ylab="")
abline(h=mean(rain),lwd=2,lty=2)
axis(1,las=1,at=seq(0,10,1))
axis(2,las=1,at=c(mean(rain)-2*sd(rain),mean(rain)-sd(rain),mean(rain),
                  mean(rain)+sd(rain),mean(rain)+2*sd(rain)),
     labels=c(expression(-2*~sigma,-~sigma,mu,sigma,2*~sigma)))

##### FIGURE 3(a): Economic growth ####

# Prepare data
require(plyr)
g<-ddply(d,.(year), summarise,
         mean=mean(gdp_g,na.rm=TRUE)*100,
         min=min(gdp_g,na.rm=TRUE)*100,
         max=max(gdp_g,na.rm=TRUE)*100)


# Plot
par(mar=c(3,6,2,2))
plot(g$year,g$mean,type="p",cex=1.5,pch=19,col="steelblue4",axes=FALSE,
     ,ylim=c(min(g$min),max(g$max)),
     xlab="",ylab="")
segments(g$year,g$min,g$year,g$max,lwd=1.5,col="black",lend=1)

axis(1,at=seq(1980,2015,5),tck=-0.02, cex.axis=1.2)
axis(1,at=seq(1980,2015,1),labels=FALSE,tck=-0.01)
axis(2,at=seq(-100,100,25),las=1,tck=-0.02,cex.axis=1.2)
axis(2,at=seq(-100,100,5),labels=FALSE,tck=-0.01)
mtext("Percent",side=2,line=3,cex=1.2)

#### FIGURE 3(b-c): Conflict onset and average rainfall ####

## Prepare data:

# Add column with row order
africa@data <- cbind(c(1:dim(africa)[1]),
                     africa@data[,c("ISO3","NAME","LAT","LON")])
names(africa@data) <- c("order",names(africa@data)[-1])

# Merge the data into a new dataframe
africadat<-merge(africa, data, by="ISO3")

# Replace original attribute table --> Doesn't work every time
#africa@data <- africadat[order(africadat$order),]

# Create the breaks
brks<-classIntervals(africadat$onset,n=2,style="fixed",fixedBreaks=c(0,1,2,3,4,5,6,7),
                     unique=TRUE)
brks<-brks$brks

# Plot: conflict onset
spplot(africadat,"onset",at=brks,col.regions=brewer.pal(9,"Blues"),
       scales=list(draw=TRUE), main="")

# Plot: precipitation
colours<-brewer.pal(9,"YlGn")
brks<-c(100,400,700,1000,1300,1600,1900,2100,2400)

spplot(africadat,"gpcp",at=brks,col.regions=colours,scales=list(draw=TRUE),
       main="")

#### FIGURE 3(d): Conflict onset and incidence ####

# Housekeeping
acd<-ddply(d,.(year), summarise,
         incidence=sum(anyconflict,na.rm=TRUE),
         onset=sum(conflict_onset,na.rm=TRUE))
# Plot 
par(mar=c(5,4,2,2))
barplot(acd$incidence,col=c("gray80"),axes=FALSE,
        names.arg=acd$year,las=2,width=0.3,border=NA,
        cex.names=1.2)
barplot(acd$onset,col=c("steelblue4"),add=TRUE,axes=FALSE,
        width=0.3,border=NA)
# Axis
axis(2,at=seq(0,15,5),las=1,tcl=-0.5,cex.axis=1.2)
axis(2,at=seq(0,15,1),labels=FALSE,las=1,tcl=-0.3)
legend("topleft",c("Ongoing conflicts","New conflicts"),
       cex=1,lwd=c(15,15,15,15),col=c("gray80","steelblue4"),
       bty="n",y.intersp=c(0.3))
