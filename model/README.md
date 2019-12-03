# 파일 설명

1. demographics_preprocess.Rmd

   > input : `2018 외래관광객 실태조사 원자료.csv`
   >
   > output : `preprocessed.csv`
   >
   > 설문데이터를 분석에 용이한 포맷으로 전처리를 담당

2. LDA.ipynb

   > input : `review40/*.csv`, `mapping/mapping.csv`
   >
   > output : `LDA_results.csv`
   >
   > 4개 토픽의LDA를 통해 설문데이터에서 표기된 여행지 40 범주별 토픽 가중치를 뽑아준다.
   >
   > 4개를 선정한 이유는 perplexity를 최저점을 기반으로 할 경우 토픽을 해석을 할 수 없다는 판단을 하였다.
   >
   > (주의) : review40/ 의 여행지 인덱스를 세자리수로 바꾸었다. 
   >
   > > `0 Myeongdong_Shopping_Street-Seoul.csv` ==>`000 Myeongdong_Shopping_Street-Seoul.csv`

3. demographics_analysis.Rmd

   > input : `preprocessed.csv`, `LDA_results.csv`
   >
   > output : `Three_recommendation.csv`
   >
   > 선형회귀 모형을 기반으로 인구통계정보, 여행목적을 입력할 경우 이에 대응하는 여행지 3개를 추천해준다.

# 앞으로 할 일

1. 이미 학습시킨 LDA모형으로 약 600개의 여행지 리뷰에 대해 토픽을 뽑아내어서 더 많은 여행지를 추천할 것
2. 추천 모델의 고도화
