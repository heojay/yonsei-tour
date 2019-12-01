# test
library(shiny)
library(tidyverse)

# ui.R

age_list <- c('under 20', '20s', '30s', '40s', '50s', 'over 60')
sex_list <- c('Male', 'Female')
nat_list <- c('China', 'Taiwan', 'Japan', 'U.S.A', 'Other')

ui <- fluidPage(
  
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
    column(1,
           h3("The Atrractions you Might Be Interested in"),     
           tableOutput("item_recom")
    ),
    column(1,
           imageOutput("image", height = 300)
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


# server.R


server <- function(input, output) {

  output$item_recom <- renderTable({
    
    
    # react to submit button
    input$submit
    
    # gather input in string
    user_detail <- 
      isolate(
        unique(c(input$input_age, input$input_sex, input$input_nat))
      )
    
    # Run model
    if(user_detail != ""){
      if(user_detail[2] == "Male"){
      recomm <- c('MyneongDong', 'Everland')
      } else {
        recomm <- c('Sinchon', 'LotteWorld')
      }
    }
    
  }
  )
  
  output$image <- renderImage({
    
    # react to submit button
    input$submit
    
    # gather input in string
    user_detail <- 
      isolate(
        unique(c(input$input_age, input$input_sex, input$input_nat))
      )
    
    if (user_detail != ""){
      if (user_detail[2] == "Male") {
        return(list(
          src = "images/myeongdong.jpg",
          contentType = "image/jpg",
          height = 300,
          alt = "Myeongdong"
        ))
      } else {
        return(list(
          src = "images/sinchon.jpeg",
          filetype = "image/jpeg",
          height = 300,
          alt = "Sinchon"
        ))
      }
    } else {
      return(list(
                  src = "images/default.png",
                  filetype = "image/png",
                  height = 300,
                  alt = "Sinchon"
      ))
    }
    
  }, deleteFile = FALSE)
  
}


shinyApp(ui = ui, server = server)