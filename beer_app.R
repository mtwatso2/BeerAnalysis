#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
beers<- read.csv("beers_cleaned.csv", fill = TRUE, stringsAsFactors = FALSE)


# Define UI for application that draws a histogram
ui <- fluidPage(
  tabsetPanel(
    tabPanel("Data Visualization", "Data Visualization",
             
             # Application title
             titlePanel("Beer Explorer"),
             
             # Sidebar with a slider input for number of bins 
             sidebarLayout(
               sidebarPanel(
                 sliderInput(inputId = "abv_slide",
                             label = "Alcohol Percentage (ABV):",
                             min = 0,
                             max = 32,
                             value = c(0.5, 32),
                             step = 0.5), 
                 
                 sliderInput(inputId = "long_slide",
                             label = "Longitude:",
                             min = -180,
                             max = 180,
                             value = c(-180,180),
                             step = 10), 
                 
                 sliderInput(inputId = "lat_slide",
                             label = "Latitude:",
                             min = -90,
                             max = 90,
                             value = c(-90,90),
                             step = 10), 
                 
                 
                 
                 selectInput("ds", 
                             "Beer Category", 
                             c("All" ,
                               "British Ale" , 
                               "Irish Ale" , 
                               "North American Ale",
                               "German Ale" ,
                               "Belgian and French Ale",
                               "German Lager" ,
                               "North American Lager" ,
                               "Other Lager" ,
                               "Other Style"),
                             selected = 1
                             
                 ),
                 
                 selectInput(inputId = "country_dd",
                             label = "Select Country",
                             c("All","Argentina", "Australia", "Austria", "Belgium", "Belize", "Brazil", "Canada", "China", "Colombia", "Croatia", "Czech Republic",
                               "Denmark", "El Salvador", "England", "Estonia", "Finland", "France", "French Poynesia", "Germany", "Guatemala", "Hungary", "India",
                               "Ireland", "Italy", "Jamaica", "Japan", "Kenya", "Korea, Republic of", "Macao", "Macedonia, the Former Yugoslav Republic of",
                               "Mauritius", "Mexico", "Myanmar", "Namibia", "Netherlands", "New Zealand", "Norway", "Panama", "Philippines", "Poland", "Russia",
                               "Sierra Leone", "Slovakia", "Switzerland", "Taiwan, Province of China", "Thailand", "Togo", "United Kingdom", "United States", "Viet Nam"),
                             selected = 1
                 )
                 
                 
                 
               ), #ends sidebarPanel 
               
               
               # Show a plot of the plot
               mainPanel(
                 plotOutput(outputId = "plot"),
                 
                 span("Number of Beers selected:",
                      textOutput("n_beers")
                 )
                 
               )
             ) #ends sidebarLayout
    ),# ends tabPanel1
    tabPanel("Linear Regression", "Linear Regression", 
             
             ui <- fluidPage(
               headerPanel("Beer Analysis"), 
               sidebarPanel(
                 p("Select the inputs for the Dependent Variable"),
                 selectInput(inputId = "DepVar", label = "Dependent Variables", multiple = FALSE, choices = list("abv")),
                 p("Select the inputs for the Independent Variable"),
                 checkboxGroupInput(inputId = "IndVar",
                                    label = "Independent Variables",
                                    choices = list("brewery_id", "style_id", "cat_id", "latitude", "longitude"),
                                    selected = "brewery_id")
               ),
               mainPanel(
                 verbatimTextOutput(outputId = "RegSum"),
                 verbatimTextOutput(outputId = "IndPrint"),
                 verbatimTextOutput(outputId = "DepPrint")
               )
             )
             
             
    )#ends tabPanel2
    
  ) #ends tabsetPanel
) #ends UI







# SERVER SERVER SERVER SERVER SERVER SERVER SERVER SERVER SERVER SERVER SERVER SERVER
server <- function(input, output, session) {
  
  lm1 <- reactive({lm(reformulate(input$IndVar, input$DepVar), data = beers)})
  
  output$DepPrint <- renderPrint({input$DepVar})
  output$IndPrint <- renderPrint({input$IndVar})
  output$RegSum <- renderPrint({summary(lm1())})
  
  
  final_subset = reactive({
    
    m <- beers %>%
      filter(
        abv <= max(input$abv_slide),
        abv >= min(input$abv_slide),
        longitude <= max(input$long_slide),
        longitude >= min(input$long_slide),
        latitude <= max(input$lat_slide),
        latitude >= min(input$lat_slide)
        
      ) # End filter
    
    m2 <- beers %>%
      filter(
        abv <= max(input$abv_slide),
        abv >= min(input$abv_slide),
        longitude <= max(input$long_slide),
        longitude >= min(input$long_slide),
        latitude <= max(input$lat_slide),
        latitude >= min(input$lat_slide),
        country == input$country_dd
      )
    m3 <- beers %>%
      filter(
        abv <= max(input$abv_slide),
        abv >= min(input$abv_slide),
        longitude <= max(input$long_slide),
        longitude >= min(input$long_slide),
        latitude <= max(input$lat_slide),
        latitude >= min(input$lat_slide),
        cat_name == input$ds
      )
    m4 <- beers %>%
      filter(
        abv <= max(input$abv_slide),
        abv >= min(input$abv_slide),
        longitude <= max(input$long_slide),
        longitude >= min(input$long_slide),
        latitude <= max(input$lat_slide),
        latitude >= min(input$lat_slide),
        cat_name == input$ds,
        country == input$country_dd
      )
    
    
    if(input$country_dd == "All" & input$ds == "All"){
      m <- as.data.frame(m)
    }
    else if(input$country_dd == "All" & input$ds != "All"){
      m2 <- as.data.frame(m3)
    }
    else if(input$country_dd != "All" & input$ds == "All"){
      m3 <- as.data.frame(m2)
    }
    else{m4 <- as.data.frame(m4)}
    
    
  })
  
  
  output$plot <- renderPlot({
    ggplot(final_subset()) +   
      geom_boxplot(aes(x = cat_name, y = abv, color = cat_name)) +
      geom_jitter(aes(x = cat_name, y = abv, color = cat_name))
  })
  
  output$n_beers <-  renderText({ nrow(final_subset()) })
  
}



# Run the application 
shinyApp(ui = ui, server = server)
