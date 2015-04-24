# Mothers and Babies OP-aPT -- ui
#
# written by Susan Z. Martin
# last update: 2015-04-24
#
# resources used and referenced
#  - RStudio's widget gallery http://shiny.rstudio.com/gallery/widget-gallery.html
#  - Martin Monkman's MLB run scoring shiny app https://monkmanmh.shinyapps.io/MLBrunscoring_shiny/
#  - Martin Monkman's ui and server files for his shiny app https://github.com/MonkmanMH/MLBrunscoring_shiny/blob/master/01_shiny/ui.R


shinyUI(pageWithSidebar(
      headerPanel("'Mothers and Babies' - an OP-aPT (Online Predicting and Plotting Tool)"),
      sidebarPanel(
            h4("If you need more information on how to use 'Mothers and Babies'",
               "or on OP-aPT check out the tabs at the bottom of the page."),
            hr(),
            h4("Predicting"),
            h5("Enter your patient's height and weight",
               "using the sliders below. Her Body Mass Index (BMI) as well as a predicted",
               "birthweight for a baby born to a woman with this BMI",
               "will be shown in the area to the right"),
            sliderInput('ht', label = h6("Height in inches"),value = 64, min = 45,
                        max = 78, step = 1),
            sliderInput('wt', label = h6("Weight in lbs"),value = 130, min = 75,
                        max = 300, step = 1),
            hr(),
            h4("Plotting"),
            h5("To see visualizations of the association between",
               "different maternal characteristics and baby's",
               "birthweight select a variable below. Linear regression",
               "is marked by the red line."),
            selectInput("matchar", 
                        label = "Maternal Characteristic (X axis)",
                        choices = list("Age", "Height", "Weight"),
                        selected = "Age"
            )
           
      ),
      mainPanel(
            
            textOutput("text1"),
            verbatimTextOutput("prediction"),
            h6("(A BMI below 18.5 is underweight, 18.5-24.9 is normal, 25-29.9 is",
               " overweight and 30 and above is obese.)"),
            hr(),
            textOutput("text2"),
            verbatimTextOutput("predbw"),
            plotOutput('newplot'),
            tabsetPanel(
                  tabPanel("Disclaimer", includeHTML("disc.html")),
                  tabPanel("How to use 'Mothers and Babies'",
                           includeHTML("howtouse.html")),
                  tabPanel("More about OP-aPT and EasyDataViz",includeHTML("more.html"))
      )
)))