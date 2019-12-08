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
   > output : `LDA_results.csv`(39개의 여행지 범주 별 토픽) `LDA_results2.csv`(162개의 여행지 별 )
   >
   > 4개 토픽의LDA를 통해 설문데이터에서 표기된 여행지 40 범주별 토픽 가중치를 뽑아준다.
   >
   > 4개를 선정한 이유는 perplexity를 최저점을 기반으로 할 경우 토픽을 해석을 할 수 없다는 판단을 하였다.
   >
   > (주의) : review40/ 의 여행지 인덱스를 세자리수로 바꾸었다. 
   >
   > > 0 Myeongdong_Shopping_Street-Seoul.csv ==>000 Myeongdong_Shopping_Street-Seoul.csv

3. demographics_analysis.Rmd

   > input : `preprocessed.csv`, `LDA_results.csv`, `LDA_results2.csv`
   >
   > output : `Three_recommendation.csv`
   >
   > 선형회귀 모형을 기반으로 인구통계정보, 여행목적을 입력할 경우 이에 대응하는 여행지 3개를 추천해준다.

4. geo_visualization.Rmd

   > input : `mapping/mapping_geocode.csv`, `Three_recommendation.csv`
   >
   > output : `leaflet map`(목적, 인구통계 기반)
   >
   > 지도에 관광지의 위치와 정보(곧 추가 될 예정)를 포함한 마커를 띄워준다.
   
5. geo_visualization_theme.Rmd

   > input : `LDA_results2`, `mapping_geocode.csv`
   >
   > output : `leaflet map`(테마 기반)
# 앞으로 할 일

1. 문서화
2. mapping/mapping_geocode.csv 에 여행지 descrition추가 (예를 들어서 전화번호, 트립어드바이저 링크...)
