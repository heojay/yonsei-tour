function(input, output) {
  
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