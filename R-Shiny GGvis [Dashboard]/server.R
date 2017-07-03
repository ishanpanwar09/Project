library(shiny)
library(googleVis)

# reading data from CSV
df <- read.csv("OnlineRetail.csv", header = T,sep=',')
Motion <- read.csv("summary.csv", header = T,sep=',')
Motion$Date <- as.Date(Motion$Date)
# adding a new column of "SalesValue" itemwise to the df
df$SaleValues <- df$Quantity*df$UnitPrice

# making data frame for Items
Item <- data.frame(df$Description,df$Quantity,df$SaleValues)

# modifying and making a better Item data frame
idx <- split(1:nrow(Item), Item$df.Description)
NewItemDF <- data.frame(df.Description=sapply(idx, function(i) Item$df.Description[i[1]]),
                        df.Quantity=sapply(idx, function(i) sum(Item$df.Quantity[i])),
                        df.SaleValues=sapply(idx, function(i) sum(Item$df.SaleValues[i])))

NewItemDF <- NewItemDF[order(NewItemDF$df.Quantity, rev(NewItemDF$df.Quantity), decreasing = FALSE), ]
# fixed dimnames
row.names(NewItemDF) <- paste("",1:nrow(NewItemDF),sep="")
# Reducing data to cumulative itemDescription in 2 yrs for below fields (very Imp)
idx1 <- split(1:nrow(df), df$Description)
DescDF <- data.frame(Country=sapply(idx1, function(i) df$Country[i[1]]),
                     YearGroup=sapply(idx1, function(i) df$YearGroup[i[1]]),
                     Item=sapply(idx1, function(i) df$Description[i[1]]),
                     Sales=sapply(idx1, function(i) sum(df$SaleValues[i])),
                     Quantity=sapply(idx1, function(i) sum(df$Quantity[i])))

# getting Data for 2010 and 2011 (used in below Code)
Data2010 <- subset(df, YearGroup == 2010, select = c(Country,Quantity,SaleValues))
Data2011 <- subset(df, YearGroup == 2011, select = c(Country,Quantity,SaleValues))

# seperating and aggregating data for 2011
idx2 <- split(1:nrow(Data2011), Data2011$Country)
Data11Agg <- data.frame(Country=sapply(idx2, function(i) Data2011$Country[i[1]]),
                        Sales=sapply(idx2, function(i) sum(Data2011$SaleValues[i])),
                        Quantity=sapply(idx2, function(i) sum(Data2011$Quantity[i])))

Year2011 <- c(2011,2011, 2011, 2011, 2011, 2011, 2011, 2011, 2011, 2011,
            2011, 2011, 2011, 2011, 2011, 2011, 2011, 2011,
            2011, 2011, 2011, 2011, 2011, 2011, 2011, 2011,
            2011, 2011, 2011, 2011, 2011, 2011, 2011, 2011, 2011, 2011, 2011, 2011)
Data11Agg$Year <- Year2011  
Data11Agg <- Data11Agg[,c("Country","Year","Sales","Quantity")]
# Sales and Quantity Country Wise (Country Based)
idx3 <- split(1:nrow(df), df$Country)
salesDF <- data.frame(Country=sapply(idx3, function(i) df$Country[i[1]]),
                      Sales=sapply(idx3, function(i) sum(df$SaleValues[i])),
                      Quantity=sapply(idx3, function(i) sum(df$Quantity[i])))

salesDF2 <- salesDF
tabledata <- salesDF
colnames(tabledata) <- c("Countries","Sales in USD","Quantity in number")
tabledata$AvgUnitPrice <- salesDF$Sales/salesDF$Quantity
Cntry <- salesDF$Country
Year2010 <- c(2010,2010,  2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010,
  2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010,
  2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010,
  2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010)
salesDF2$Year <- Year2010
salesDF2 <- salesDF2[,c("Country","Year","Sales","Quantity")]
#generating data for 2010 year aggregated
Data10Agg <- salesDF2 - Data11Agg
Data10Agg$Sales <- salesDF$Sales-Data11Agg$Sales
Data10Agg$Quantity <- salesDF2$Quantity - Data11Agg$Quantity
# below code gives warning for string being involved in subtraction, but fixed below
Data10Agg$Country <- Cntry
Data10Agg$Year <- Year2010
Data10Agg <- Data10Agg[,c("Country","Year","Sales","Quantity")]

Data11Agg$Country <- Cntry

# Summary till here - got data for 2010, 2011, and aggregated total country based.
# removing UK for better representation of International Trade
noUK <-salesDF[salesDF$Country != "United Kingdom", ]
colnames(noUK) <- c("Countries","Sales in USD","Quantity in number")
noUK <- noUK[order(noUK$`Sales in USD`, rev(noUK$`Sales in USD`), decreasing = FALSE), ]
# shinyServer code starts below
options(shiny.maxRequestSize = 10*1024^2)
shinyServer(function(input, output, session){
  
  output$LineChart <- renderGvis({
    gvisLineChart(noUK, xvar="Countries", yvar=c("Sales in USD","Quantity in number"),
                  options=list(title="Line Graph: Sales vs Quantity",
                               titleTextStyle="{color:'black',
                               fontName:'Courier', fontSize:20}", curveType="function", 
                               pointSize=6, series="[{targetAxisIndex:0, color:'red'}, 
                               {targetAxisIndex:1, color:'blue'}]",
                               vAxes="[{title:'USD', format:'#,###',
                               titleTextStyle: {color: 'blue'},
                               textStyle:{color: 'blue'},
                               textPosition: 'out'}, {title:'Quantity', format:'#,###',
                               titleTextStyle: {color: 'red'},  
                               textStyle:{color: 'red'}, textPosition: 'out'}]",
                               hAxes="[{title:'', textPosition: 'out'}]",
                               width=700, height=700),chartid="twoaxislinechart")
  })
  
  output$scatter <- renderGvis({
    gvisBubbleChart(tail(NewItemDF,8), 
                     options=list(
                       lineWidth=1, pointSize=1,
                       title="8 Items selected", vAxis="{title:'Total SalesValue of Item Individualy (USD)'}",
                       hAxis="{title:'Quantity Sold (number)'}",
                       width=650, height=690))
  })
  output$pieAll <- renderGvis({
    gvisSteppedAreaChart(head(noUK,5), xvar="Countries", 
                         yvar=c("Sales in USD", "Quantity in number"),
                         options=list(height='480',
                                      width='600',isStacked=TRUE))
  })
  output$AreaChart <- renderGvis({
    Bar <- gvisBarChart(head(noUK,10),options=list(title="",height='850',
                                          width='600',isStacked=TRUE))
    #gvisAreaChart(noUK)
  })
  
  output$SAC <- renderGvis({
  gvisSteppedAreaChart(tail(noUK,5), xvar="Countries", 
                                      yvar=c("Sales in USD", "Quantity in number"),
                                      options=list(height='480',
                                                   width='600',isStacked=TRUE))
  })
  
  output$Table <- renderGvis({
  gvisTable(tabledata, 
            formats=list('Sales in USD'="#,###",
                         'Quantity in number'='#', 'AvgUnitPrice'="#.##"),
            options=list(page='enable',
                         height='500',
                         width='500'))
  })


  output$GeoChart <- renderGvis({
    gvisGeoChart(salesDF, "Country", "Sales","Quantity")
  })
  
  output$gvisMap <- renderGvis({
    gvisMap(salesDF, "Country", "Sales","Quantity",
            options=list(showTip=TRUE,
                         showLine=TRUE,enableScrollWheel=TRUE,
                         mapType='terrain', useMapTypeControl=TRUE))
  })
  
  output$LLC <- renderGvis({
    gvisLineChart(noUK, "Countries", c("Sales in USD","Quantity in number"),
                  options=list(gvis.editor="Edit Me!!"))
  })

  
  # can be done by using all items, all countries (make new DF)
  output$Motion <- renderGvis({
    gvisMotionChart(Motion, 
                         idvar="SaleValue", 
                         timevar="Date")
  })
})