# 빅데이터 기반 서울 시내 관광 버스 노선 제안

## 1. 프로젝트 소개

**주제 선정 이유**

> 여행을 통해서 좋은 기억을 남기기 위해서 가장 중요한 것은 **여행지 코스 선정**이다.
>
> 만약 자신에게 맞는 여행을 위해서 여행사의 상담을 받는다면 이는 **비용 지출**이다. 비용 지출에 비례하여 만족의 역치도 증가하기 때문에 이를 해결하고자 데이터 기반의 여행지 코스 선정을 하는 것을 제안한다. 
>
> 최종적으론, 비용 절감을 넘어서 데이터에 기반 했기에 사람이 추천해주는 것과 견주어도 손색없는 **코스를 제안**하고자 한다. 그리고 이를 통해 여행자들에게 한국에서의 여행 만족도 향상을 기대한다.

**개요**

> 여행지 리뷰와 사용자들의 개인 별 설문 조사에 기반하여 여행지를 추천한다.
>
> 1. 여행지 **리뷰**에 대해서 단어 빈도수에 기반하여 **LDA 토픽 모델링**을 진행한다.
>
> 2. 개인 별 **설문 조사**에 대해서 **MBTI 성격유형 조사**와 **Factor Analysis**를 진행한다.
> 3. 성격에 따른 주제-simplex에서의 **선호 분포**를 찾아내서 여행지를 추천한다.

## 2. 발표 전까지 해온 일

### 2.1 크롤링 + LDA

#### 2.1.1 크롤링



#### 2.1.2 Latent Dirichlet Allocation

1. 각 여행지는 $K$개의 토픽 mixture로 이루어져 있고 토픽 별로 word 등장 확률이 정해져 있다.
2. 리뷰 내의 단어들은 $K$개의 토픽 중 한 토픽에 의해서 generated됐다고 가정한다.  

LDA가 제안하기를...

> **문서 별 주제에 대한 사전 분포**는 multinomial distribution의 conjugate prior **Dirichlet distribution**
>
> **주제 별 단어 사전 분포**도 multinomial distribution의 conjugate prior인 **Dirichlet distribution**을 사용

![1571751036094](https://drive.google.com/uc?export=view&id=1C8p5QPQPmrzPIY2yJTUkp3JxBMbEYoWi)

이를 통해 얻어진 Dirichlet 사후 분포를 통해서 여행지를 토픽 심플렉스 $S^K$ 상의 원소로 볼 수 있는 이유는 

> Dirichlet 분포의 특징을 이용해 **문서 별 토픽에 대한 비율로** 표현할 수 있기 때문이다.
> $$
> \operatorname{E}[Dir(\alpha_1, \cdots, \alpha_K)] = (\frac{\alpha_1}{\sum \alpha_k }, \cdots , \frac{\alpha_K}{\sum \alpha_k })​
> $$

마찬가지로, 주제 별 단어의 사후 분포 역시 위를 통해서 단어 심플렉스 $S^V$ 상의 원소로 볼 수 있게 된다.

### 2.2 설문조사 + FA



#### 2.2.1 설문조사



#### 2.2.2 Factor Analysis



## 3. 모델 제안

### 3.1 Instance based

### 3.2 Model based

