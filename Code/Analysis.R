folder <- "D:/김종원/대학교/2학년/2학기/데이터 시각화/62p/data"
setwd(folder)
data_list <- dir(folder)

data <- lapply(data_list, function(x) read.table(x))

# 2019.12.15 기준 (9.24 패치 2일 후)
  data_19.12.15 <- read.table("2019-12-14-23-25")
  str(data_19.12.15)
  attach(data_19.12.15)
  
  # kda는 어느 정도일까?
    
    hist(kda, breaks = seq(0,20,1), ylim = c(0,200), xaxt = 'n')
    axis(side = 1, at = seq(0,20,2))
    
    # 2~4 사이의 값이 많다.
    
      
  # 가장 많이 선호하는 라인은 어디일까?
  
    line_data <- sort(table(선호.라인))
    
    barplot(line_data, main = "랭커들이 선호하는 라인", 
            horiz = T, xlim = c(0,150) )
    
    # 예상대로 영향력이 강한 미드를 제일 선호한다. 요즘 메타가 원딜러는 하드캐리가 힘든데 이는 통계에 그대로 나타난다.
    
    
  # 각 라인별 승률의 변화는 어떨까?
    
    # 분포 확인 
    par(mfrow = c(3,2))
    for( i in levels(선호.라인) ) {
      hist(승률[선호.라인==i], main = paste0(i," 승률 분포"),
            xlab = "승률", xlim = c(0,100), breaks = seq(0,100,5))
    }
    
    # 평균으로 계산 
    ratioofline <- sort(tapply(승률, 선호.라인, mean))
    par(mfrow = c(1,1))
    ratioofline_barplot <- barplot(ratioofline, main = "라인 별 승률", ylim = c(0,100) )
    text(ratioofline_barplot, ratioofline+2, labels = round(ratioofline, 1))
    
    # 예상대로 미드가 최상위, 원딜이 최하위였다.
    # 서포터가 2등인 것은 예상 밖이었으나, 점수는 서포터가 더 올리기 쉽다고 알려져 있으므로 크게 놀랍지는 않다.
    
  # 가장 많이 선호하는 챔피언 Top15 및 그에 따른 승률 
    
    n <- 15
    # 가장 많이 선호한 챔피언 Top15
    table_champ <- sort(table(선호.챔피언), decreasing = T)
    data_champn <- table_champ[1:n]
    
    champn_barplot <- barplot(data_champn, ylim = c(0,50))
    text(champn_barplot, data_champn+2, labels = paste0(data_champn,"회"))
    
    # Top15 챔피언 빈도 이상 챔피언의 평균 승률 
    meanratioofchamp <- round(tapply(승률, 선호.챔피언, mean),1)
    champn_ratio <- sort(meanratioofchamp[table(선호.챔피언) >= min(data_champn)])
    
    countchamp <- c()
    for( i in 1:length(champn_ratio) ) {
      countchamp[i] <- table_champ[names(table_champ)==names(champn_ratio)[i]]
    }
    
    champn_ratio_barplot <- barplot(champn_ratio, ylim = c(0,70))
    text(champn_ratio_barplot, champn_ratio+2, labels = paste0(champn_ratio,"%"))
    text(champn_ratio_barplot, champn_ratio+5, labels = paste0(countchamp,"회"))
    
    # 정글은 리 신과 렉사이, 서포터는 노틸러스와 쓰레쉬가 압도적이다.
    # 아트록스는 함정카드라고 보아도 무방할 것이다.