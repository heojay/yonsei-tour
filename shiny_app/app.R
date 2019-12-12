# test
library(shiny)
library(tidyverse)
library(leaflet)

target_list <- readRDS("target_list.rds")
lda_list <- read.csv("LDA_results2.csv")
link_list <- read.csv("40_reviews_2.csv")
mapping <- read.csv('mapping/mapping_geocode.csv')
mapping <- left_join(mapping, link_list, by = 'attraction')


# ui.R

obj_list <- c('History', 'K-POP', 'Nature', 'Beauty', 'Tradition', 'Fashion', 'Shopping', 'Entertainment')
con_list <- c('Taiwan', 'Germany', 'Russia', 'Malaysia', 'Mongol', 'Vietnam', 'Singapore', 'United Kingdom', 'India', 'Indonesia', 'Japan', 'China', 'Mid-East', 'Canada', 'Thailand', 'France', 'Philippines', 'Australia', 'Hong Kong')
age_list <- c("-20", "21-30", "31-40", "41-50", "51-60", "61-")

obj_list_in <- c('역사','K-POP','자연','미용','전통','패션','쇼핑','유흥')
con_list_in <- c("대만","독일","러시아","말레이시아","몽골","미국","베트남","싱가포르","영국","인도","인도네시아",
              "일본","중국","중동","캐나다","태국","프랑스","필리핀","호주","홍콩")
age_list_in <- c("15-20세", "21-30세", "31-40세", "41-50세", "51-60세", "61세이상")

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
        unique(c(obj_list_in[match(input$input_obj, obj_list)],
                 age_list_in[match(input$input_age, age_list)],
                 con_list_in[match(input$input_con, con_list)]))
      )
    
    # Run model
    if(input$submit != 0){
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
        unique(c(obj_list_in[match(input$input_obj, obj_list)],
                 age_list_in[match(input$input_age, age_list)],
                 con_list_in[match(input$input_con, con_list)]))
      )
    
    # Run model
    if(input$submit != 0){
      userdata <- filter(target_list, 목적 == user_detail[1], 나이 == user_detail[2], 국적 == user_detail[3])
      result <- rbind(lda_list[userdata[['recom1']],], lda_list[userdata[['recom2']],], lda_list[userdata[['recom3']],])
      attr_input <- result[,c('attraction')]
      
      leaflet(data = mapping[mapping$attraction %in% attr_input,]) %>%
        addProviderTiles(providers$OpenStreetMap) %>%
        addMarkers(lng=~lon, lat=~lat,
                   popup = ~ paste0("<strong>",paste0(paste0(paste0(paste0("<a href=\"", urls), "\">"), attraction), "</a>")))
    }                  
  })
  
  output$image1 <- renderImage({
    
    # react to submit button
    input$submit
    
    # gather input in string
    user_detail <- 
      isolate(
        unique(c(obj_list_in[match(input$input_obj, obj_list)],
                 age_list_in[match(input$input_age, age_list)],
                 con_list_in[match(input$input_con, con_list)]))
      )
    
    if (input$submit != 0){
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
        unique(c(obj_list_in[match(input$input_obj, obj_list)],
                 age_list_in[match(input$input_age, age_list)],
                 con_list_in[match(input$input_con, con_list)]))
      )
    
    if (input$submit != 0){
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
        unique(c(obj_list_in[match(input$input_obj, obj_list)],
                 age_list_in[match(input$input_age, age_list)],
                 con_list_in[match(input$input_con, con_list)]))
      )
    
    if (input$submit != 0){
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