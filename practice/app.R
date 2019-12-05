# test
library(shiny)
library(tidyverse)

target_list <- readRDS("target_list.rds")
lda_list <- read_csv("LDA_results.csv")
lda_list <- lda_list[c('category', 'attractions')]

# ui.R

obj_list <- c('역사','K-POP','자연','미용','전통','패션','쇼핑','유흥')
con_list <- c("대만","독일","러시아","말레이시아","몽골","미국","베트남","싱가포르","영국","인도","인도네시아",
              "일본","중국","중동","캐나다","태국","프랑스","필리핀","호주","홍콩")
age_list <- c("15-20세", "21-30세", "31-40세", "41-50세", "51-60세", "61세이상")

ui <- fluidPage(
  
  # App title ----
  headerPanel("Yonsei Tour Recommender"),
  
  fluidRow(
    
    # Input selection
    column(4, 
           # INPUT
           h3("Tell Me Who You are"),    
           wellPanel(
             selectInput("input_obj", "What do you want to do?", choices = c("", obj_list)),
             selectInput("input_age", "How old are you?", choices = c("", age_list)),
             selectInput("input_con", "Where do you come form?", choices = c("", con_list)),
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
        unique(c(input$input_obj, input$input_age, input$input_con))
      )
    
    # Run model
    if(user_detail != ""){
      result <- filter(target_list, 목적 == user_detail[1], 국적 == user_detail[3], 나이 == user_detail[2])
      filter(lda_list, category == result[['recom1']] |
               category == result[['recom2']] |
               category == result[['recom3']])['attractions']
             
             
    }

    
  }
  )

  
  output$image <- renderImage({
    
    # react to submit button
    input$submit
    
    # gather input in string
    user_detail <- 
      isolate(
        unique(c(input$input_obj, input$input_age, input$input_con))
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