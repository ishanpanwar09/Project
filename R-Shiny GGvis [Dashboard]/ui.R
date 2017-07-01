library(shiny)
library(googleVis)
shinyUI(fluidPage(
  titlePanel("Project-   Online Retail Transaction Analysis"),
  sidebarLayout(
    sidebarPanel(
      
      h3("Ishan Singh (G01003801)"),
      h3("GoogleVis - Shiny"),
      h4("Index:"),
      h5("#  1. Interactive Table"),
      h5("#  2. GoogleMap "),
      h5("#  3. WorldMap "),
      h5("#  4. Stepped Area Chart"),
      h5("#  5. Bubble Graph"),
      h5("#  6. Line Graph"),
      h5("#  7. Edit Me Graph"),
      h5("#  8. Motion Graph"),
      h3(""),
      h4("#  Summary"),
      h5("   This project gives transactional analysis of an 'Online Retail' 
         for its last 6-month transactions. This analysis can be used to update/modify 
         marketing policies/strategies and is also very useful to procurement department. The report focuses on number of sales and the sale value associated with the sales.")
      
    ),
    mainPanel(
      h3("Data Set can be found on the below link"),
      h5("http://archive.ics.uci.edu/ml/datasets/Online+Retail"),
      h3(" "),
      h3(" Summary of Data : Interactive Table"),
      htmlOutput("Table"),
      
      h4(""),
      h4(""),
      h3("World Map Representing All Trade Sales (USD $) Countrywise"),
      htmlOutput("gvisMap"),
      
      h4(""),
      h4(""),
      h3("World Map Representing Major International Trade"),
      htmlOutput("GeoChart"),
      
      h4(" "),
      h3(" "),
      h3("Bar Chart: 10 Countries with lower Trade"),
      htmlOutput("AreaChart"),
      
      h4(""),
      h3(""),
      h3("Stepped Area Chart: 5 Countries with Maximum Trade (No UK)"),
      htmlOutput("SAC"),
      
      h4(""),
      h3(""),
      h3("Bubble Graph Showing the Most Sold Items"),
      h4(""),
      htmlOutput("scatter"),
      
      h4(""),
      h4(""),
      h3("Line Chart "),
      htmlOutput("LineChart"),
      
      h4(""),
      h3(""),
      h3("Various Function Graph"),
      htmlOutput("LLC"),

      h4(""),
      h3(""),
      h3(" Motion Graph"),
      h5("Sale values (in millions USD) need to be selected using checkbox"),
      htmlOutput("Motion"),
      h3("")
    )
  ))
)