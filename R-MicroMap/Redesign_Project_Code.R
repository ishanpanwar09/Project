# Initialization of MicroMaps
library(micromapST)

# Importing Data from CSV
Data_Input <- read.csv(file="redesign-new.csv", header=T, as.is=TRUE)
View(Data_Input)

# Creating function for State, State ID's

microFull2Ab <- function(stateDF,stateId=NULL,
                         ref=stateNamesFips){
  if(is.null(stateId)) 
    nam <- row.names(stateDF) else
      nam <- stateDF[,stateId]
    nam <- ifelse(nam=="District of Columbia","D.C.",nam)
    check <-  match(nam,row.names(ref)) 
    bad <- is.na(check)
    good <- !bad
    nbad <- sum(bad)
    if(nbad>0){
      warning(paste(nbad,"Unmatch Names Removed",nam[bad]))
      stateDF <- stateDF[!bad,]
      nam <- nam[!bad]
      check <- check[!bad]
      good <- good[!bad]
    }
    ngood <- sum(good)
    if(ngood < 51)warning(paste("Only",ngood,"State Ids"))
    row.names(stateDF) <- ref[check,2]
    return(stateDF)
}

microFull2Ab(Data_Input,"State")
Redesign_Data <- microFull2Ab(Data_Input,"State")
View(Redesign_Data)

# storing Redesign_Data to Statedf for further operations 
# and keeping actual set unmodified

stateDf <- Redesign_Data
nam<- colnames(stateDf)
names(nam) =1:length(nam)
nam

# Now representing the change with arrow plots.
# Calculated median to give reference lines and show th e change

med2015<- median(Redesign_Data$Feburary.2015,na.rm = FALSE)
med2016<- median(Redesign_Data$Feburary.2016,na.rm = FALSE)
medRC<- median(Redesign_Data$X12.month.net.change,na.rm = FALSE)
medRC

Dot_Redesign_Data <- data.frame(
  type=c('mapcum','id','dot','dot','arrow','dot'),
  lab1=rep("",6),
  lab2=c('' ,'','Rate (Feb 15)','Rate (Feb 16)','Change in Rate','% Change'),
  lab3=c('','','Ref  "Median = 5.3"', 'Ref  "Median 4.7"', '(Feb 16) - (Feb15)','Ref  "0"'),
  col1 = c(NA,NA,2,3,2,5),
  col2 = c(NA,NA,NA,NA,3,NA),
  refVals=c(NA,NA,med2015,med2016,NA,0))
t(Dot_Redesign_Data)
head(Dot_Redesign_Data)

# Print as PDF the Dot Plot of Micromap with complete data.

fName = "Redesigned_Graph_MicroMap.pdf"
pdf(file=fName,width=8,height=10)
micromapST(Redesign_Data, Dot_Redesign_Data,sortVar=5,ascend=FALSE,title=c("Unemployement Rate Analysis in USA",""))
dev.off()

# Adding an extra column to create reference for the arrows. It contains all Zero's

Redesign_Data$Zero <- rep(0,nrow(Redesign_Data))
View(Redesign_Data)

# Now representing the change with arrow plots.

Arrow_Redesign_Data <- data.frame(
  type=c('mapcum','id','arrow','arrow'),
  lab1=c('','','Relative Change','% change in'),
  lab2=c('' ,'','Feb 2015 to Feb 2016','Unemployement over 12 months'),
  col1 = c(NA,NA,2,6),
  col2 = c(NA,NA,3,5),
  refVals=c(NA,NA,NA,0))

View(Arrow_Redesign_Data)

# Print as PDF the Arrow Plot of Micromap with Difference in data (2 columns).

fName = "Arrow_Redesign_MicroMap.pdf"
pdf(file=fName,width=8,height=10)
micromapST(Redesign_Data,Arrow_Redesign_Data,
           sortVar=5,ascend=FALSE,
           title=c("Unemployement Rate Analysis in USA",""))
dev.off()