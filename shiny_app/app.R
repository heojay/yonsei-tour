# test
library(shiny)
library(tidyverse)
library(leaflet)

target_list <- readRDS("target_list.rds")
lda_list <- read.csv("LDA_results2.csv")
mapping <- read.csv('mapping/mapping_geocode.csv')



# ui.R

obj_list <- c('역사','K-POP','자연','미용','전통','패션','쇼핑','유흥')
con_list <- c("대만","독일","러시아","말레이시아","몽골","미국","베트남","싱가포르","영국","인도","인도네시아",
              "일본","중국","중동","캐나다","태국","프랑스","필리핀","호주","홍콩")
age_list <- c("15-20세", "21-30세", "31-40세", "41-50세", "51-60세", "61세이상")

ui <- fluidPage(
  
  # App title ----
  headerPanel("Yonsei Tour Recommender"),
  
  sidebarPanel(
    h3("Tell Me Who You are"),    
    wellPanel(
      selectInput("input_obj", "What do you want to do?", choices = c("", obj_list)),
      selectInput("input_age", "How old are you?", choices = c("", age_list)),
      selectInput("input_con", "Where do you come form?", choices = c("", con_list)),
      actionButton("submit", "Complete")
    )
  ),
  
  mainPanel(
    fluidRow(
      h3("The Atrractions you Might Be Interested in"),
      column(4,
             tableOutput("item_recom")
             ),
      column(8,
             leafletOutput("mymap"))
    )
  ),
  
  
  fluidRow(
    column(4,
           imageOutput("image1", height = 300)
    ),
    column(4,
           imageOutput("image2", height = 300)
    ),
    column(4,
           imageOutput("image3", height = 300)
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
      userdata <- filter(target_list, 목적 == user_detail[1], 나이 == user_detail[2], 국적 == user_detail[3])
      result <- lda_list[userdata[['recom1']],] %>%
        rbind(lda_list[userdata[['recom2']],]) %>%
        rbind(lda_list[userdata[['recom3']],])
      result[,c('attraction')]
    }
  }
  )
  
  output$mymap <- renderLeaflet({
    
    # react to submit button
    input$submit
    
    # gather input in string
    user_detail <- 
      isolate(
        unique(c(input$input_obj, input$input_age, input$input_con))
      )
    
    # Run model
    if(user_detail != ""){
      userdata <- filter(target_list, 목적 == user_detail[1], 나이 == user_detail[2], 국적 == user_detail[3])
      result <- lda_list[userdata[['recom1']],]
      result <- rbind(result, lda_list[userdata[['recom2']],])
      result <- rbind(result, lda_list[userdata[['recom3']],])

      attr_input <- result[,c('attraction')]
      
      leaflet(data = mapping[mapping$attraction %in% attr_input,]) %>%
        addProviderTiles(providers$OpenStreetMap) %>%
        addMarkers(lng=~lon, lat=~lat, popup = ~ as.character(paste0("<strong>", attraction)))
    }                  
  })
  
  output$image1 <- renderImage({
    
    # react to submit button
    input$submit
    
    # gather input in string
    user_detail <- 
      isolate(
        unique(c(input$input_obj, input$input_age, input$input_con))
      )
    
    if (user_detail != ""){
      userdata <- filter(target_list, 목적 == user_detail[1], 나이 == user_detail[2], 국적 == user_detail[3])
      place <- lda_list[userdata[['recom1']],'category']
      
      return(list(
        src = paste("images/",place,".jpg",sep = ""),
        filetype = "image/jpg",
        height = 300,
        alt = "place1"
      ))
      
    } else {
      return(list(
                  src = "images/welcome1.jpg",
                  filetype = "image/jpg",
                  height = 300,
                  alt = "welcome1"
      ))
    }
    
  }, deleteFile = FALSE)
  
  output$image2 = renderImage({
    # react to submit button
    input$submit
    
    # gather input in string
    user_detail <- 
      isolate(
        unique(c(input$input_obj, input$input_age, input$input_con))
      )
    
    if (user_detail != ""){
      userdata <- filter(target_list, 목적 == user_detail[1], 나이 == user_detail[2], 국적 == user_detail[3])
      place <- lda_list[userdata[['recom2']],'category']
      
      return(list(
        src = paste("images/",place,".jpg",sep = ""),
        filetype = "image/jpg",
        height = 300,
        alt = "place2"
      ))
    }else{
      return(list(
        src = "images/welcome2.jpg",
        filetype = "image/jpg",
        height = 300,
        alt = "welcome2"
      ))
    }
  }, deleteFile = FALSE)
  
  output$image3 = renderImage({
    # react to submit button
    input$submit
    
    # gather input in string
    user_detail <- 
      isolate(
        unique(c(input$input_obj, input$input_age, input$input_con))
      )
    
    if (user_detail != ""){
      userdata <- filter(target_list, 목적 == user_detail[1], 나이 == user_detail[2], 국적 == user_detail[3])
      place <- lda_list[userdata[['recom3']],'category']
      
      return(list(
        src = paste("images/",place,".jpg",sep = ""),
        filetype = "image/jpg",
        height = 300,
        alt = "place3"
      ))
    }else{
      return(list(
        src = "images/welcome3.jpg",
        filetype = "image/jpg",
        height = 300,
        alt = "welcome3"
      ))
    }
  }, deleteFile = FALSE)
}

shinyApp(ui = ui, server = server)