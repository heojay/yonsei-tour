# --------------------------------------------------------------------------------
# Urls
# --------------------------------------------------------------------------------

# Check if chrome is installed
# Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_111')

# install java
# start cmd and copy paste the lines below
# cd C:\Users\iihsk\Desktop\ds_web_scraping\tools_for_R_Selenium\tools\selenium서버프로그램\selenium-server-standalone-master\bin
# java -jar selenium-server-standalone.jar -port 4445


#===================
# Description
#===================

# We must 

# clearout workspace
rm(list=ls())
graphics.off()

# import packages
library(tidyverse)
library(httr) # for parsing html script
library(rvest) # for scraping static web pages
library(RSelenium)
library(stringr)

# open chrome browser
remDr <- remoteDriver(remoteServerAddr ="localhost",
                      port = 4445L,
                      browserName = "chrome")
#remDr$getStatus() # if normal : 200

remDr$open()
#remDr$setWindowSize(width = 400, hegith =300) # adjust screen sized


#===========
# Prepare my data
#===========

setwd("C:/Users/iihsk/Desktop/yonsei-tour")
data <- read.csv("list of tourist attractions.csv", header=TRUE, na.strings= c(" ", "") , stringsAsFactors = FALSE)
#glimpse(data)

# combine all element to one row and get rid of duplicated values
i <- 1
listOfAttractions <- c()
while(i <= length(names(data))){
  listOfAttractions <- c(listOfAttractions, data[,i])
  i <- i+1
}

index <- duplicated(listOfAttractions)
Attractions <- listOfAttractions[!index]

# Get rid of NA Value
Attractions <- Attractions[-which(is.na(Attractions))]

# direct web browser to tripadvisor
url <- "https://www.tripadvisor.co.kr/Search?singleSearchBox=true&geo=1&pid=3826&redirect=&startTime=1574519994683&uiOrigin=MASTHEAD&q=%EA%B3%B5&supportedSearchTypes=find_near_stand_alone_query&enableNearPage=true&returnTo=https%253A__2F____2F__www__2E__tripadvisor__2E__co__2E__kr__2F__&searchSessionId=983EACDE359AE47AC8704480CECC27F91574519989133ssid&social_typeahead_2018_feature=true&sid=983EACDE359AE47AC8704480CECC27F91574520174340&blockRedirect=true&ssrc=a"
remDr$navigate(url)
#Sys.sleep(5) # wait until the page is loaded

# words to search
searchWords <- c()
for(i in 1:length(Attractions)){
  searchWords[i] <- paste(substr(Attractions[i], nchar(Attractions[i]), nchar(Attractions[i])), substr(Attractions[i], 1, nchar(Attractions[i])-1), sep="")
}

data <- data.frame(attraction = c(), description = c(), earning = c(), expenditure = c(), publicSpending = c())
n <- length(searchWords)
Elapsed.time <- c()

searchUrls <- paste(
  "https://www.tripadvisor.co.kr/Search?singleSearchBox=true&geo=1&pid=3826&redirect=&startTime=1574519994683&uiOrigin=MASTHEAD&q=", Attractions,"&supportedSearchTypes=find_near_stand_alone_query&enableNearPage=true&returnTo=https%253A__2F____2F__www__2E__tripadvisor__2E__co__2E__kr__2F__&searchSessionId=983EACDE359AE47AC8704480CECC27F91574519989133ssid&social_typeahead_2018_feature=true&sid=983EACDE359AE47AC8704480CECC27F91574520174340&blockRedirect=true&ssrc=a&rf=2", sep=""
)

urls <- c()

for(i in 393:n){
  
  start.time <- Sys.time()
  
  # navigate to tripadvisor
  remDr$navigate(searchUrls[i])
  
  # import page source
  Sys.sleep(3)
  url_source <- remDr$getPageSource()[[1]]
  url_item <- read_html(url_source, encoding="UTF-8")
  
  # click on 'attractions'
  webElem <- remDr$findElement(using ='css selector', '#search-filters > ul > li:nth-child(4) > a')
  webElem$clickElement()
  
  # import page source
  Sys.sleep(3)
  url_source <- remDr$getPageSource()[[1]]
  url_item <- read_html(url_source, encoding="UTF-8")
  
  # copy url resources
  cssSelectors <- paste('#BODY_BLOCK_JQUERY_REFLOW > div.page > div > div.ui_container.main_wrap > div > div > div > div > div.content_column.ui_column.is-9-desktop.is-12-tablet.is-12-mobile > div > div.ui_columns.sections_wrapper > div > div.prw_rup.prw_search_search_results.ajax-content > div > div.main_content.ui_column.is-12 > div > div:nth-child(2) > div > div > div:nth-child(', 1:10, ') > div > div > div > div.ui_column.is-9-desktop.is-8-mobile.is-9-tablet.content-block-column > div.location-meta-block > div.rating-review-count > div > a', sep="")
  temp <- c()
  
  index <- c(1:3, 5:6)
  
  tryCatch({
    for(j in index){
      temp[j] <- url_item%>% 
        html_nodes(css = cssSelectors[j]) %>% 
        html_attr('href')
    }
  
    # https://www.tripadvisor.co.kr 뒤에 붙음
    tempUrl <- c()
    for(k in index){
      tempUrl[k] <- paste("https://www.tripadvisor.co.kr", temp[k], sep="")
    }
    
    urls <- c(urls, tempUrl)
  }, error = function(e){}
  )  
  
  end.time <- Sys.time()
  Elapsed.time[i] <- round(as.numeric(end.time - start.time),2)
  
  # 종료까지 예상시간
  if(i==1){
    expected.time <- Elapsed.time * n
  }
  
  # 진행 비율 및 예상 종료 시간
  cat(paste(round(i/n*100,2), "%(", i, "/", n, ") complete - Elapsed Time :",
            sum(Elapsed.time), " / Expected time of Task :",
            expected.time, sep=""), "\n")
  
}

NAindex <- is.na(urls)
final_urls <- urls[!NAindex]

# --------------------------------------------------------------------------------
# Save Data
# --------------------------------------------------------------------------------
setwd("C:/Users/iihsk/Desktop/yonsei-tour")
write.csv(final_urls, "final_urls.csv", row.names=FALSE)
write.csv(data, "guideStar_Crawling.csv", row.names=FALSE)

# close driver
remDr$close