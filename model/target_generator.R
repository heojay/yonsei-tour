library(tidyverse)

df <- read.csv('preprocessed.csv', fileEncoding = "euc-kr") %>% select(-X) %>% filter()
temp_corr <- colnames(df)
lda_results <- read.csv('LDA_results.csv') %>% select(-X)
df <- left_join(df, lda_results, by='category')
prev_nrow <- nrow(df)
df %>% filter(highest_ratio<0.8) %>% distinct(만족방문지)
df <- df %>% filter(highest_ratio>=0.8)
now <- nrow(df)
df$highest_topic <- factor(df$highest_topic)
temp_corr <- c(temp_corr, 'highest_topic') # highest_topic도 모델에 포함하기로 결정
test_corr <- df %>% select(temp_corr) %>% select(-category, -만족방문지)
test_corr <- as.data.frame(lapply(test_corr, as.integer))

library("rlang")
test1 <- df %>% select(starts_with('목적_'), highest_topic)

temp <- colnames(test1) 
temp_loc <- which(!grepl('highest_topic', temp))
temp2 <- temp[temp_loc]
temp3 <- paste(temp2, collapse = paste(' *', 'highest_topic', '+ '))

test1_model1 <- as.formula(paste('topic1 ~', temp3, '* highest_topic'))
test1_model2 <- as.formula(paste('topic2 ~', temp3, '* highest_topic'))
test1_model3 <- as.formula(paste('topic3 ~', temp3, '* highest_topic'))
test1_model4 <- as.formula(paste('topic4 ~', temp3, '* highest_topic'))


model1 <- eval(expr(lm(!!test1_model1, data=df)))
model2 <- eval(expr(lm(!!test1_model2, data=df)))
model3 <- eval(expr(lm(!!test1_model3, data=df)))
model4 <- eval(expr(lm(!!test1_model4, data=df)))

for_to_char <- function(fomul){
  paste(as.character(fomul)[2], as.character(fomul)[1], as.character(fomul)[3])
}


test2_model1 <- paste(for_to_char(test1_model1), '+ 국적 * highest_topic')
test2_model2 <- paste(for_to_char(test1_model2), '+ 국적 * highest_topic')
test2_model3 <- paste(for_to_char(test1_model3), '+ 국적 * highest_topic')
test2_model4 <- paste(for_to_char(test1_model4), '+ 국적 * highest_topic')

test2_model1 <- as.formula(test2_model1)
test2_model2 <- as.formula(test2_model2)
test2_model3 <- as.formula(test2_model3)
test2_model4 <- as.formula(test2_model4)


model1_2 <- eval(expr(lm(!!test2_model1, data=df)))
model2_2 <- eval(expr(lm(!!test2_model2, data=df)))
model3_2 <- eval(expr(lm(!!test2_model3, data=df)))
model4_2 <- eval(expr(lm(!!test2_model4, data=df)))


test3_model1 <- paste(for_to_char(test2_model1), '+ 성별 * highest_topic')
test3_model2 <- paste(for_to_char(test2_model2), '+ 성별 * highest_topic')
test3_model3 <- paste(for_to_char(test2_model3), '+ 성별 * highest_topic')
test3_model4 <- paste(for_to_char(test2_model4), '+ 성별 * highest_topic')

test3_model1 <- as.formula(test3_model1)
test3_model2 <- as.formula(test3_model2)
test3_model3 <- as.formula(test3_model3)
test3_model4 <- as.formula(test3_model4)


model1_3 <- eval(expr(lm(!!test3_model1, data=df)))
model2_3 <- eval(expr(lm(!!test3_model2, data=df)))
model3_3 <- eval(expr(lm(!!test3_model3, data=df)))
model4_3 <- eval(expr(lm(!!test3_model4, data=df)))

test4_model1 <- paste(for_to_char(test3_model1), '+ 나이 * highest_topic')
test4_model2 <- paste(for_to_char(test3_model2), '+ 나이 * highest_topic')
test4_model3 <- paste(for_to_char(test3_model3), '+ 나이 * highest_topic')
test4_model4 <- paste(for_to_char(test3_model4), '+ 나이 * highest_topic')

test4_model1 <- as.formula(test4_model1)
test4_model2 <- as.formula(test4_model2)
test4_model3 <- as.formula(test4_model3)
test4_model4 <- as.formula(test4_model4)


model1_4 <- eval(expr(lm(!!test4_model1, data=df)))
model2_4 <- eval(expr(lm(!!test4_model2, data=df)))
model3_4 <- eval(expr(lm(!!test4_model3, data=df)))
model4_4 <- eval(expr(lm(!!test4_model4, data=df)))

rbind(broom::glance(model1_4), broom::glance(model2_4), broom::glance(model3_4), broom::glance(model4_4)) %>% mutate(Topic=c('Topic1', 'Topic2', 'Topic3', 'Topic4')) %>%
  select(Topic, adj.r.squared, df)

lda_results2 <- read.csv('LDA_results2.csv') %>% select(-X)


obj_list <- c('역사','K-POP','자연','미용','전통','패션','쇼핑','유흥')
con_list <- c("대만","독일","러시아","말레이시아","몽골","미국","베트남","싱가포르","영국","인도","인도네시아",
              "일본","중국","중동","캐나다","태국","프랑스","필리핀","호주","홍콩")
age_list <- c("15-20세", "21-30세", "31-40세", "41-50세", "51-60세", "61세이상")
sex_list <- c("남성","여성")
ht_list <- c(1,2,3,4)

target_list <- tibble("목적","성별", "국적", "나이", "HT", "recom1", "recom2", "recom3", "recom1_category", "recom2_category", "recom3_category")

for (obj in obj_list){
  input <- list()
  input[['목적']] <- c(obj)
  for (con in con_list){
    input[['국적']] <- factor(con, levels=con_list)
    for (age in age_list){
      input[['나이']] <- factor(age, levels=age_list)
      for (sex in sex_list){
        input[['성별']] <- factor(sex, levels=sex_list)
        for (ht in ht_list){
          input[['HT']] <- factor(ht, levels=ht_list)
          input_df <- data.frame(목적_역사 = ifelse(any(input$목적 %in% '역사'), 1, 0),
                                      목적_KPOP = ifelse(any(input$목적 %in% 'POP'), 1, 0),
                                      목적_자연 = ifelse(any(input$목적 %in% '자연'), 1, 0),
                                      목적_미용 = ifelse(any(input$목적 %in% '미용'), 1, 0),
                                      목적_전통 = ifelse(any(input$목적 %in% '전통'), 1, 0),
                                      목적_패션 = ifelse(any(input$목적 %in% '패션'), 1, 0),
                                      목적_쇼핑 = ifelse(any(input$목적 %in% '쇼핑'), 1, 0),
                                      목적_유흥 = ifelse(any(input$목적 %in% '유흥'), 1, 0),
                                      국적 = input$국적,
                                      나이 = input$나이,
                                      성별 = input$성별,
                                      highest_topic=input$HT,
                                      topic1=0,
                                      topic2=0,
                                      topic3=0,
                                      topic4=0)
          X1 <- model.matrix(test4_model1, data=input_df)
          X2 <- model.matrix(test4_model2, data=input_df)
          X3 <- model.matrix(test4_model3, data=input_df)
          X4 <- model.matrix(test4_model4, data=input_df)
          
          # 인도인 중에 토픽4를 방문한 사람이 없다.
          model1_4$coefficients['highest_topic4:국적인도'] = 0
          model2_4$coefficients['highest_topic4:국적인도'] = 0
          model3_4$coefficients['highest_topic4:국적인도'] = 0
          model4_4$coefficients['highest_topic4:국적인도'] = 0
          
          
          yhat1 <- X1 %*% model1_4$coefficients
          yhat2 <- X2 %*% model2_4$coefficients
          yhat3 <- X3 %*% model3_4$coefficients
          yhat4 <- X4 %*% model4_4$coefficients
          
          estimated_df <- data.frame(topic1 = yhat1, topic2 = yhat2, topic3 = yhat3, topic4 = yhat4)
          
          result <- data.frame(topic1 =yhat1, topic2 = yhat2, 
                               topic3 =yhat3, topic4 = yhat4)
          
          eucl <- function(vector){
            sum(vector^2)
          }
          
          topic_location <- lda_results2 %>% select(topic1, topic2, topic3, topic4)
          
          # Three attractions will be recommended
          recoomend3 <- order(apply(topic_location - as.numeric(result), 1, eucl)) <= 3
          target_list <- rbind(target_list, c(input[['목적']], input[['성별']], input[['국적']], input[['나이']], input[['HT']], lda_results2[recoomend3,c('attraction')], lda_results2[recoomend3, c('category')]))
        }
      }
    }
  }
}

names(target_list) = c("목적","성별", "국적", "나이", "HT", "recom1", "recom2", "recom3", "recom1_category", "recom2_category", "recom3_category")
target_list = target_list[-1,]
target_list[['성별']] <- as.numeric(target_list[['성별']])
target_list[['국적']] <- as.numeric(target_list[['국적']])
target_list[['나이']] <- as.numeric(target_list[['나이']])
target_list[['HT']] <- as.numeric(target_list[['HT']])
target_list[['recom3']] <- as.numeric(target_list[['recom3']])
target_list[['recom1']] <- as.numeric(target_list[['recom1']])
target_list[['recom2']] <- as.numeric(target_list[['recom2']])
target_list[['recom3']] <- as.numeric(target_list[['recom3']])
target_list[['recom1_category']] <- as.numeric(target_list[['recom1_category']])
target_list[['recom2_category']] <- as.numeric(target_list[['recom2_category']])
target_list[['recom3_category']] <- as.numeric(target_list[['recom3_category']])

saveRDS(object = target_list, file = "target_list.rds")