#-data.table-
#recc_table:
#Columns: 
# age(under 20, 30s, 40s, 50s, over 60), 
# sex(Male, Female), 
# nationality(China, Taiwan, Japan, U.S.A, Other), 
# place number(1~40), 
# place name

recc_table <- readRDS("data/temp_data.rds")
function(input, output) {
  
  output$item_recom <- renderTable({
    # react to submit button
    input$submit
    
    # gather input in string
    user_detail <- 
      isolate(
        unique(c(input$input_age, input$input_sex, input$input_nat))
      )

    recomm <- recc_table[age == user_detail[1] & 
                             sex == user_detail[2] &
                             nationality == user_detail[3],4] #need to convert place number to place name
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
      return(list(
        src = paste("images/",recc_table[age == user_detail[1] & 
                                 sex == user_detail[2] &
                                 nationality == user_detail[3],4], ".jpg",sep=""),
        contentType = "image/jpg",
        height = 300,
        alt = "Myeongdong"
      ))
    }else{
      return(list(
        src = "images/default.png",
        contentType = "image/png",
        height = 300,
        alt = "Welcome"
      ))
    }
    
  }, deleteFile = FALSE)
  
}