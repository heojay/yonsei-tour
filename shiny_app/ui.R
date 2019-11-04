#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

nationality_list <- c('South Korea', 'China')
sex_list <- c('Male', 'Female')
age_list <- c('10s', '20s', '30s')

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    headerPanel("Yonsei Tour Attraction Recommender"),

    # Sidebar with a slider input for number of bins
    fluidRow(
        
        # Input selection
        column(4, 
               # INPUT
               h3("Who Are You?"),    
               wellPanel(
                   selectInput("input_item1", "Nationality", choices = c("", nationality_list)),
                   selectInput("input_item2", "Sex", choices = c("", sex_list)),
                   selectInput("input_item3", "Age", choices = c("", age_list)),
                   actionButton("submit", "Complete Your Answer")
               )
        ),
        
        # Output table
        column(3,
               h3("The Attractions You Might Be Interested in"),     
               tableOutput("item_recom")
        )
    )
))
