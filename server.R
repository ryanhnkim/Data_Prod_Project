
library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)
library(forecast)

df <- readRDS("data/constSpend.rds")

shinyServer(function(input, output) {
    
    # reactive fuction to store input value to be used in multiple render functions later
    selcategory <- reactive({input$category})
    
    output$selected <- renderText({
                paste("I. Overall Spending -", selcategory())
                    })??

    output$tsPlot1 <- renderPlot({
        
        # subset data, where level = 0
        df.sub1 <- subset(df, df$category == selcategory() & df$level ==0 & 
                             year(df$Date) %in% seq(input$range[1], input$range[2], 1))
        
        df.sub1 <- arrange(df.sub1, Date)
        
        # num of months to forecast
        n=input$months
        
        # fit auto.arima and run forecast
        fit <-auto.arima(df.sub1$value)
        pred <-forecast(fit,n)

        # end of month
        predMth<- (seq(max(df$Date)+1, length=(n+1),by='1 month')-1)[-1]
        
        # wrap data into a data.frame
        df.pred <- data.frame(Date=predMth, value = pred$mean, type="Forecasted", 
                              lbound = pred$lower[,1], ubound = pred$upper[,1]) 
        
        df.tot <- select(df.sub1, Date, value)
        df.tot <- transform(df.tot, type="Actual", lbound=NA, ubound=NA)
        df.tot <- rbind(df.tot, df.pred)
        
        # visualize
        ggplot(df.tot) + geom_line(aes(x=Date, y=value,colour=type),size=1) +
            geom_ribbon(aes(x=Date, ymin=lbound, ymax=ubound), fill='orange', alpha=0.2) +
            scale_color_manual(values=c("#3399FF", "#FF6600")) +
            ylab("$ Billions") + xlab("")
  })
  
  output$tsPlot2 <- renderPlot({
      
      # subset data, where level = 1
      df.sub2 <- subset(df, df$category == selcategory() & df$level ==1 & 
                           year(df$Date) %in% seq(input$range[1], input$range[2], 1))
      
      ggplot(df.sub2, aes(x=Date, y=value, group=variable)) + 
          geom_line(aes(colour=variable), size=1) + ylab("$ Billions") + xlab("")
      
  })
  
  output$tsPlot3 <- renderPlot({
      
      # subset data, where level = 2
      df.sub3 <- subset(df, df$category == selcategory() & df$level ==2 & 
                            year(df$Date) %in% seq(input$range[1], input$range[2], 1))
      
      ggplot(df.sub3, aes(x=Date, y=value, group=variable)) + 
          geom_line(aes(colour=variable)) + ylab("$ Billions") + xlab("")
      
  })
})

