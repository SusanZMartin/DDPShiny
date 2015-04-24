# Mothers and Babies OP-aPT -- server
#
# written by Susan Z. Martin
# last update: 2015-04-24
#
# resources used and referenced
#  - RStudio's widget gallery http://shiny.rstudio.com/gallery/widget-gallery.html
#  - Martin Monkman's MLB run scoring shiny app https://monkmanmh.shinyapps.io/MLBrunscoring_shiny/
#  - Martin Monkman's ui and server files for his shiny app https://github.com/MonkmanMH/MLBrunscoring_shiny/blob/master/01_shiny/ui.R

library(UsingR)
library(shiny)
library(dplyr)
library(ggplot2)
data(babies)

# remove records with unknown/missing data for those variables used in application

projbabies <- filter(babies, age < 99)
projbabies <- filter(projbabies, ht < 99)
projbabies <- filter(projbabies, wt1 < 999)
projbabies <- filter(projbabies, smoke < 9)
projbabies <- mutate(projbabies, bmi = round(wt1/ht^2*703, digits=1))

##let's turn smoking into yes/no

smokers <- filter(projbabies, smoke == 1)
nonsmokers <- filter(projbabies, smoke != 1)

smokers <- mutate(smokers, Smoker = "Yes")
nonsmokers <- mutate(nonsmokers, Smoker = "No")

projbabies <- rbind(smokers,nonsmokers)

#BMI calculation function

calcBMI <- function(wt,ht) round(((wt)/(ht^2)*703), digits = 1)

#baby birthweight calculation function

calcbw <- function(wt,ht) {
      bmi <- round(((wt)/(ht^2)*703), digits = 1)
      mbmi <- lm(wt ~ bmi, data = projbabies)
      new <- data.frame(c(bmi))
      ounces <- round(predict(mbmi,new), digits = 0)
      babylb = trunc(ounces/16)
      babyoz = ounces -(babylb*16)

      paste(ounces,"oz or",babylb,"lbs,",babyoz,"oz for your patient's baby")}
      

shinyServer(
      function(input, output) {
      
            
      output$prediction <- renderPrint({calcBMI(input$wt,input$ht)})
      
      output$text1 <- renderText({ 
            paste("Your patient is ", input$ht, "inches tall and weighs ",
                        input$wt, "pounds. Her BMI is:")})
      
      output$text2 <- renderText({ 
            paste("Using this dataset simple linear regression predicts a",
                  "birthweight of:" )})

      output$predbw <- renderPrint({calcbw(input$wt,input$ht)})
           
      output$newplot <- renderPlot({
            model <- lm(wt ~ age, data = projbabies)                  
            baseplot = ggplot(projbabies, aes(x = age, y = wt, colour = Smoker))
            baseplot = baseplot + geom_point(size = 4, colour = "black") +
                        geom_point(size = 2)
            baseplot = baseplot + xlab("Maternal Age") +
                        ylab("Baby's birthweight in Ounces")
            baseplot = baseplot + 
                        ggtitle("Baby's Birthweight in Ounces\nVersus Maternal Age\n")
            baseplot = baseplot + geom_abline(intercept = coef(model)[1],
                              slope = coef(model)[2],
                              size = 1, color = "red", lwd=2)
            print(baseplot)           
                  
      if(input$matchar == "Age")
      { 
            model <- lm(wt ~ age, data = projbabies)
            plotvar <- "Age" 
            baseplot = ggplot(projbabies, aes(x = age, y = wt, colour = Smoker))
            baseplot = baseplot + geom_point(size = 4, colour = "black") +
                  geom_point(size = 2)
            baseplot = baseplot + xlab(paste("Maternal", plotvar, "in years")) +
                  ylab("Baby's birthweight in Ounces")
            baseplot = baseplot + 
                  ggtitle(paste("Baby's Birthweight in Ounces\nVersus Maternal",
                                plotvar, "\n"))
            baseplot = baseplot + geom_abline(intercept = coef(model)[1],
                                              slope = coef(model)[2],
                                              size = 1, color = "red", lwd=2)
            print(baseplot)        
      }
      if(input$matchar == "Height")
                  { 
                    model <- lm(wt ~ ht, data = projbabies)
                    plotvar <- "Height" 
                    baseplot = ggplot(projbabies, aes(x = ht, y = wt, colour = Smoker))
                    baseplot = baseplot + geom_point(size = 4, colour = "black") +
                          geom_point(size = 2)
                    baseplot = baseplot + xlab(paste("Maternal", plotvar, "in Inches")) +
                          ylab("Baby's birthweight in Ounces")
                    baseplot = baseplot + 
                          ggtitle(paste("Baby's Birthweight in Ounces\nVersus Maternal",
                                        plotvar, "\n"))
                    baseplot = baseplot + geom_abline(intercept = coef(model)[1],
                                                      slope = coef(model)[2],
                                                      size = 1, color = "red", lwd=2)
                    print(baseplot)        
                  }
            if (input$matchar == "Weight") {plotvar <- "Weight"
                     model <- lm(wt ~ wt1, data = projbabies)
                     baseplot = ggplot(projbabies, aes(x = wt1, y = wt, colour = Smoker))
                     baseplot = baseplot + geom_point(size = 4, colour = "black") +
                              geom_point(size = 2)
                     baseplot = baseplot + xlab(paste("Maternal ", plotvar, " in lbs")) +
                              ylab("Baby's birthweight in Ounces")
                     baseplot = baseplot + 
                              ggtitle(paste("Baby's Birthweight in Ounces\nVersus Maternal",
                              plotvar, "\n"))
                        baseplot = baseplot + geom_abline(intercept = coef(model)[1],
                                                          slope = coef(model)[2],
                                                          size = 1, color = "red", lwd=2)
                        print(baseplot)}      
         
                
            })
            
      }
)