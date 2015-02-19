
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("US Construction Spending"),

  # Sidebar
  sidebarLayout(
    sidebarPanel(
        selectInput("category", label = h5("Select a spending sources"),
                 choices = c("Total", "Private","Public"), selected = "Total"
                 ),
        br(),
        sliderInput("range",
                    label = h5("Years to display:"),
                    min = 2002,
                    max = 2015,
                    value = c(2002, 2015), 
                    sep = ""
                    ),
        br(),
        
        numericInput("months", 
                    label = h5("Months to forecast (for Overall Spending)"), 
                    value=12, 
                    min=3, 
                    max=36, 
                    step=3
                    ),
        
        br(),

        helpText("Construction Spending provides monthly estimates of 
                 the total dollar value of construction work done in the U.S.",br(),
                 "Construction Spending covers the dollar construction work done each month 
                 on new structures or improvements to existing structures for private and public sectors.", br(), 
                 "Data estimates include the cost of labor and materials, cost of architectural and engineering work, 
                 overhead costs, interest and taxes paid during construction, and contractor's profits."
                ),
        
        helpText("This application pulls the latest data from US Census website and automatically updates the charts.", br(),
                 "It also provides forecasted values of overall spending $ using ARIMA function 
                 based on the subset of data displayed on the graph.", br(),
                 "The shaded area represents lower and upper bounds of 80% confidence interval."
                ),
        
        helpText("For more details around the source data, visit:", 
                 a("www.census.gov", href="http://www.census.gov/construction/c30/c30index.html")
                )
    ),
    # Show a plot of the generated distribution
    mainPanel(
        # "I. Overall Spending - selected
        h4(textOutput("selected")),
        plotOutput("tsPlot1", height = "300px"),
      
      h4("II. Residential vs. Non-Residential"),
        plotOutput("tsPlot2", height = "300px"),
      
      h4("III. Non-Residential Details by Type"),
        plotOutput("tsPlot3", height = "400px")
    )
  )
))


