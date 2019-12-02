# 빅데이터 기반 한국 관광지 추천 시스템

## 개요

- 한국의 관광지를 Tripadvisor 리뷰를 기반으로 하는 잠재 디리클레 할당으로 분류하고, 외래관광객 실태조사 결과와 매치시켜 사용자에게 유사한 관광지 혹은 관광 테마 전반을 제안한다.



## 활용 데이터

### [2018 외래관광객 실태조사](https://kto.visitkorea.or.kr/kor/notice/data/statis/tstatus/forstatus/board/view.kto?id=431236&isNotice=false&instanceId=295&rnum=5)

- 한국관광공사가 우리나라를 방문한 외래관광객의 한국 여행실태, 한국내 소비실태 및 한국 여행 평가를 조사한 자료로 외래관광객의 한국 여행성향을 파악할 수 있음




### Tripadvisor 리뷰

![](/Users/jaewonheo/Documents/yonsei-tour/mid_report_fig/trip_crawl.png)

- TripAdvisor는 호텔 및 레스토랑 리뷰, 숙박 예약 및 기타 여행 관련 콘텐츠를 보여주는 미국 여행 웹사이트로 해외 유저들 개개인이 느끼고 경험한 바가 리뷰로 남겨져 있음
- 외래관광객 실태조사의 <만족한 관광지>에 해당하는 관광지들을 추려, BeautifulSoup를 이용해 리뷰를 수집
- 535개 관광지 / 약 60,000개 리뷰



## 모델링

### 잠재 디리클레 할당

- 주어진 문서에 대하여 각 문서에 어떤 주제들이 존재하는지를 서술하는 대한 확률적 토픽 모델 기법 중 하나



### 선형회귀

- 종속 변수 y와 한 개 이상의 독립 변수 (또는 설명 변수) X와의 선형 상관 관계를 모델링하는 회귀분석 기법



## Shiny Application

![](/Users/jaewonheo/Documents/yonsei-tour/mid_report_fig/prototype.png)



