# University2-Data-Visualization-final

## 롤 상위 랭커 500명이 선호하는 라인과 승률, 선호하는 챔피언과 kda 분석


#### 개요

리그오브레전드는 1~3주마다 작은 패치가 이루어지고 1년을 주기로 큰 패치를 합니다.

연도별 데이터에서는 선호 라인의 큰 변화를 관측할 수 있을 것입니다. 주별 데이터에서는 패치로 인해 큰 폭으로 좋아지거나 안 좋아진 챔피언 또는 버그로 인한 변동을, 일별 데이터로는 유튜브 등 방송 또는 핫픽스의 영향으로 인한 특이점을 확인할 수 있을 것입니다.

따라서 상위 랭커 500명의 정보를 불러와 분석해보겠습니다.


#### 방법

1. 500위까지의 플레이어 닉네임을 불러옵니다.

![1](https://user-images.githubusercontent.com/58083333/70853029-e9fc5f00-1eeb-11ea-8d34-e9923a20132e.PNG)

2. 해당 플레이어의 세부 정보 창에 접속하여 솔로랭크 정보를 추출합니다.

![2](https://user-images.githubusercontent.com/58083333/70853031-ec5eb900-1eeb-11ea-9d7d-c7ac25b711f3.PNG)

![3](https://user-images.githubusercontent.com/58083333/70853033-ed8fe600-1eeb-11ea-82ed-8f028f5a48b3.PNG)


#### 폴더 구조

* README.md

> 프로젝트의 전반적인 설명과 목차입니다.

* 


#### 발전 방향

1. 티어별 무작위 표본 추출을 하여 KDA, CS, 판수 등에 따른 티어 예측

> 선형회귀식을 세워 티어를 예측함.

> 라인별 특성이 다르기 때문에 모두 따로 취급해야 함.

2. 롤 API에서 직접 데이터 추출

> 더 신속하고 많은 데이터를 추출할 수 있음.

> reCAPTCHA 를 통과해야 하는 문제가 있음.

> * 해결 방안

> > 수동으로 찾기

> > register product 를 통한 정기권 획득

> > reCAPTCHA 우회프로그램 사용
