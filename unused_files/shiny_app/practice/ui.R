library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram

age_list <- c('under 20', '20s', '30s', '40s', '50s', 'over 60')
sex_list <- c('Male', 'Female')
nat_list <- c('China', 'Taiwan', 'Japan', 'U.S.A', 'Other')

shinyUI(fluidPage(
    
    # App title ----
    headerPanel("Yonsei Tour Recommender"),
    
    fluidRow(
        
        # Input selection
        column(4, 
               # INPUT
               h3("Tell Me Who You are"),    
               wellPanel(
                   selectInput("input_age", "Age", choices = c("", age_list)),
                   selectInput("input_sex", "Sex", choices = c("", sex_list)),
                   selectInput("input_nat", "Nationality", choices = c("", nat_list)),
                   actionButton("submit", "Complete")
               )
        ),
        
        # Output table
        column(6,
               h3("The Atrractions you Might Be Interested in"),     
               tableOutput("item_recom")
        )
    ),
    
    # COMMENTS    
    fluidRow(                                    
        column(12,
               p("For a detailed description of this project, please visit our", 
                 a("Github.", href="https://github.com/yonseijaewon/yonsei-tour", target="_blank"))
        )
    )
)
)
