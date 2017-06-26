library (plyr)
library(ggplot2)
library(data.table)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Summing up all emission year wise
YearWiseSum <- setkey(setDT(NEI))[,list(Emission=sum(Emissions)), by=list(Pollutant, year)]

jpeg('plot1.png')
barplot(
  (YearWiseSum$Emission)/10^6,  names.arg=YearWiseSum$year,  xlab="Years",
  ylab="PM2.5 Emissions (10^6 Tons)",  main="Total PM2.5 Emission from 1999-2008")
dev.off()

# Q2

library (plyr)
library(ggplot2)
library(data.table)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
BaltimoreSet <- NEI[NEI$fips == 24510]
NSSum <- setkey(setDT(BaltimoreSet), Pollutant,year)[, 
                                                     list(Emission=sum(Emissions)), by=list(Pollutant, year)]

jpeg('Plot2.png')
barplot(
  (NSSum$Emission),  names.arg=NSSum$year,  xlab="year",
  ylab="PM2.5 Emissions (10^6 Tons)",  main="PM2.5 Emission Baltimore (1999-2008)")
dev.off()

#q3

library (plyr)
library(ggplot2)
library(data.table)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
BaltimoreSet <- NEI[NEI$fips == 24510]
NSBTypeSum <- setkey(setDT(BaltimoreSet), type,Pollutant,year)[, 
                                                               list(Emission=sum(Emissions)), by=list(type,Pollutant, year)]

jpeg('Plot3.png')
ggplot(data=NSBTypeSum, aes(x=as.character(year), y=Emission, fill=type)) +
  geom_bar(stat="identity") +
  labs(title=expression("Type-Year wise Emission of PM [2.5] (1999-2008)")) +
  labs(x="Year",y="Emissions")

dev.off()


#q4
library (plyr)
library(ggplot2)
library(data.table)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
combustionRelated <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coalRelated <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
coalCombustion <- (combustionRelated & coalRelated)
combustionSCC <- SCC[coalCombustion,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]

jpeg('Plot4.png')
ggplot(combustionNEI,aes(factor(year),Emissions/10^5)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM[2.5] Emission (10^5 Tons)")) + 
  labs(title=expression("PM[2.5] Coal Source Emissions from 1999-2008"))

dev.off()

#q5

library (plyr)
library(ggplot2)
library(data.table)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
vehicle <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehicleSCC <- SCC[vehicle,]$SCC
vehicleNEI <- NEI[NEI$SCC %in% vehicleSCC,]
BltmNEI <- vehicleNEI[vehicleNEI$fips==24510,]

jpeg('Plot5.png')
ggplot(BltmNEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="grey",width=0.50) +
  theme_bw() +
  labs(x="year", y=expression("Total PM 2.5 Emission (10^5 Tons)")) + 
  labs(title=expression("PM 2.5 Emissions (Motor Vehicle Source) in Baltimore from 1999-2008"))
dev.off()

#q6

library (plyr)
library(ggplot2)
library(data.table)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

vehicle <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehicleSCC <- SCC[vehicle,]$SCC
vehicleNEI <- NEI[NEI$SCC %in% vehicleSCC,]
# Baltimore vehicles
VBNEI <- vehicleNEI[vehicleNEI$fips == 24510,]
#  NEI[ which(NEI$fips == 24510)]
VBNEI$city <- "Baltimore City"
# Los Angel Vehicle
VLANEI <- vehicleNEI[vehicleNEI$fips=="06037",]
VLANEI$city <- "Los Angeles County"
FinalComparision <- rbind(VBNEI,VLANEI)

jpeg('Plot6.png')
ggplot(FinalComparision, aes(x=factor(year), y=Emissions, fill=type)) +
  geom_bar(aes(fill=type),stat="identity") +
  facet_grid(scales="free", space="free", .~city) + theme_bw() +
  labs(x="year", y=expression("Total PM [2.5] Emission (Kilo-Tons)")) + 
  labs(title=expression("PM [2.5] MV Source Baltimore Vs LA (1999-2008)"))
dev.off()
