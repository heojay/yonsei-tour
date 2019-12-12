df <- read.csv('preprocessed.csv', fileEncoding = "euc-kr")

# top 40 관광지만 demographic analysis를 진행하고 나머지는 피팅되고 난 뒤에 모델에 얹을 예정
temp <- df['만족방문지'] %>% 
  group_by(만족방문지) %>%
  summarize(freq=n()) %>%
  top_n(40) %>%
  arrange(desc(freq)) %>%
  pull(만족방문지) %>%
  as.character()

df <- df[df$만족방문지 %in% temp,]
df$만족방문지 <- as.factor(as.character(df$만족방문지))


#여행이 매우 만족한 경우가 아니라면 제거하자. 음의 정보도 충분히 유의하나 일단 보류

df <- df %>% filter(만족도=='매우만족')

# 국적 기타 제거
df <- df %>% filter(국적!='기타')

df['category'] <- as.numeric(factor(df$만족방문지, level=temp))
df[df['category'] == 37, 'category'] <- 27
df <- df %>% select(-X, -starts_with('참여'), -starts_with('방문'))
df <- df %>% mutate(목적 = paste0('(', 목적_1위, ', ', 목적_2위, ', ', 목적_3위, ')'))
df['목적_역사'] <- ifelse(grepl('역사' , df$목적), 1, 0)
df['목적_KPOP'] <- ifelse(grepl('POP' , df$목적), 1, 0)
df['목적_자연'] <- ifelse(grepl('자연' , df$목적), 1, 0)
df['목적_미용'] <- ifelse(grepl('미용' , df$목적), 1, 0)
df['목적_전통'] <- ifelse(grepl('전통' , df$목적), 1, 0)
df['목적_패션'] <- ifelse(grepl('패션' , df$목적), 1, 0)
df['목적_쇼핑'] <- ifelse(grepl('쇼핑' , df$목적), 1, 0)
df['목적_유흥'] <- ifelse(grepl('유흥' , df$목적), 1, 0)

# **살릴 수 있는 방문 목적**을 기입하지 않은 사람은 제거하자.
temp <- df %>% select(starts_with('목적_'), -ends_with('위'))
temp <- apply(temp,1,sum)!=0
df <- df[temp, ]
lda_results <- read.csv('LDA_results.csv') %>% select(-X)
df <- left_join(df, lda_results, by='category')

test <- df %>% select('목적_역사','목적_KPOP','목적_자연','목적_미용','목적_전통','목적_패션',
                      '목적_쇼핑','목적_유흥')


model1 <- lm(data=test, df$topic1 ~ .)
model2 <- lm(data=test, df$topic2 ~ .)
model3 <- lm(data=test, df$topic3 ~ .)
model4 <- lm(data=test, df$topic4 ~ .)
stepmodel1 <- MASS::stepAIC(model1, direction = "both",trace = FALSE)
stepmodel2 <- MASS::stepAIC(model2, direction = "both",trace = FALSE)
stepmodel3 <- MASS::stepAIC(model3, direction = "both",trace = FALSE)
stepmodel4 <- MASS::stepAIC(model4, direction = "both",trace = FALSE)

test2 <- test
test2['국적'] <- df$국적
model1_2 <- update(model1, ~.+국적, data=test2)
model2_2 <- update(model2, ~.+국적, data=test2)
model3_2 <- update(model3, ~.+국적, data=test2)
model4_2 <- update(model4, ~.+국적, data=test2)

stepmodel1_2 <- MASS::stepAIC(model1_2, direction = "both",trace = FALSE)
stepmodel2_2 <- MASS::stepAIC(model2_2, direction = "both",trace = FALSE)
stepmodel3_2 <- MASS::stepAIC(model3_2, direction = "both",trace = FALSE)
stepmodel4_2 <- MASS::stepAIC(model4_2, direction = "both",trace = FALSE)

test4 <- test2
test4['나이'] <- df$나이
model1_4 <- update(model1_2, ~.+나이, data=test4)
model2_4 <- update(model2_2, ~.+나이, data=test4)
model3_4 <- update(model3_2, ~.+나이, data=test4)
model4_4 <- update(model4_2, ~.+나이, data=test4)

stepmodel1_4 <- MASS::stepAIC(model1_4, direction = "both",trace = FALSE)
stepmodel2_4 <- MASS::stepAIC(model2_4, direction = "both",trace = FALSE)
stepmodel3_4 <- MASS::stepAIC(model3_4, direction = "both",trace = FALSE)
stepmodel4_4 <- MASS::stepAIC(model4_4, direction = "both",trace = FALSE)

lda_results2 <- read.csv('LDA_results2.csv') %>% select(-X)


obj_list <- c('역사','K-POP','자연','미용','전통','패션','쇼핑','유흥')
con_list <- c("대만","독일","러시아","말레이시아","몽골","미국","베트남","싱가포르","영국","인도","인도네시아",
              "일본","중국","중동","캐나다","태국","프랑스","필리핀","호주","홍콩")
age_list <- c("15-20세", "21-30세", "31-40세", "41-50세", "51-60세", "61세이상")

target_list <- tibble('목적', '국적', '나이', 'recom1', 'recom2', 'recom3', 'recom1_category', 'recom2_category', 'recom3_category')

for (obj in obj_list){
  input <- list()
  input[['목적']] <- c(obj)
  for (con in con_list){
    input[['국적']] <- c(con)
    for (age in age_list){
      input[['나이']] <- c(age)
      input_df <- data.frame(목적_역사 = ifelse(any(input$목적 %in% '역사'), 1, 0),
                                  목적_KPOP = ifelse(any(input$목적 %in% 'POP'), 1, 0),
                                  목적_자연 = ifelse(any(input$목적 %in% '자연'), 1, 0),
                                  목적_미용 = ifelse(any(input$목적 %in% '미용'), 1, 0),
                                  목적_전통 = ifelse(any(input$목적 %in% '전통'), 1, 0),
                                  목적_패션 = ifelse(any(input$목적 %in% '패션'), 1, 0),
                                  목적_쇼핑 = ifelse(any(input$목적 %in% '쇼핑'), 1, 0),
                                  목적_유흥 = ifelse(any(input$목적 %in% '유흥'), 1, 0),
                                  국적 = input$국적,
                                  나이= input$나이)
      
      yhat1 <- predict(model1_4, newdata=input_df)
      yhat2 <- predict(model2_4, newdata=input_df)
      yhat3 <- predict(model3_4, newdata=input_df)
      yhat4 <- predict(model4_4, newdata=input_df)
      
      temp1 <- ecdf(predict(model1_4, newdata=df))
      temp2 <- ecdf(predict(model2_4, newdata=df))
      temp3 <- ecdf(predict(model3_4, newdata=df))
      temp4 <- ecdf(predict(model4_4, newdata=df))
      
      r_yhat1 <- temp1(yhat1) # rank
      r_yhat2 <- temp2(yhat2) # rank
      r_yhat3 <- temp3(yhat3) # rank
      r_yhat4 <- temp4(yhat4) # rank
      
      # mapping under estimates's rank
      temp1 <- ecdf(lda_results$topic1)
      temp2 <- ecdf(lda_results$topic2)
      temp3 <- ecdf(lda_results$topic3)
      temp4 <- ecdf(lda_results$topic4)
      
      real_yhat1 <- temp1(r_yhat1)
      real_yhat2 <- temp2(r_yhat2)
      real_yhat3 <- temp3(r_yhat3)
      real_yhat4 <- temp4(r_yhat4)
      
      ##############################################################
      ########## SEE 단순 유클리드 거리를 안쓰게 된 이유 ###########
      ##############################################################
      # result <- data.frame(topic1 =real_yhat1, topic2 = real_yhat2, 
      #                      topic3 = real_yhat3, topic4 = real_yhat4)
      
      real_yhats <- c(real_yhat1, real_yhat2, real_yhat3, real_yhat4)
      ry_orders <- order(-real_yhats)
      i = 1
      for(ord in ry_orders){
        real_yhats[ord] <- real_yhats[ord]
        i = i + 1
      }
      real_yhats = real_yhats / sum(real_yhats)
      
      result <- data.frame(topic1 =real_yhats[1], topic2 = real_yhats[2], 
                           topic3 = real_yhats[3], topic4 = real_yhats[4])
      eucl <- function(vector){
        sum(vector^2)
      }
      
      topic_location <- lda_results2 %>% select(topic1, topic2, topic3, topic4)
      
      # Three attractions will be recommended
      recoomend3 <- order(apply(topic_location - as.numeric(result), 1, eucl)) <= 3
      target_list <- rbind(target_list, c(input[['목적']], input[['국적']], input[['나이']], lda_results2[recoomend3,c('attraction')], lda_results2[recoomend3, c('category')]))
      
    }
  }
}

names(target_list) = c("목적", "국적", "나이", "recom1", "recom2", "recom3", "recom1_category", "recom2_category", "recom3_category")
target_list = target_list[-1,]
target_list[['recom1']] <- as.numeric(target_list[['recom1']])
target_list[['recom2']] <- as.numeric(target_list[['recom2']])
target_list[['recom3']] <- as.numeric(target_list[['recom3']])
target_list[['recom1_category']] <- as.numeric(target_list[['recom1_category']])
target_list[['recom2_category']] <- as.numeric(target_list[['recom2_category']])
target_list[['recom3_category']] <- as.numeric(target_list[['recom3_category']])

saveRDS(object = target_list, file = "target_list.rds")