# install.packages("RSelenium")
# install.packages("lubridate")
library(RSelenium)
library(lubridate)

m <- 5
n <- 500

# 세부 정보 url에 접속하여 정보를 불러와 주는 함수
#   여기서 정보란 솔로/듀오 랭크 플레이 시 선호하는 포지션과 해당 포지션 승률,  
#   선호했던 챔피언과 해당 챔피언 플레이 시 kda를 뜻한다.
bringinfor <- function( url ) {
  
  remDr$navigate(url)
  
  # Solo/Duo 랭크 플레이 정보만 선택 
  filter <- remDr$findElement(using = "xpath", value = "//*[@id=\"right_gametype_soloranked\"]/a")
  filter$clickElement()
  
  # 각 정보 추출 
    infor_table <- NULL
    while(is.null(infor_table)){
      Sys.sleep(0.1)
      infor_table <- tryCatch({remDr$findElement(using = 'xpath', value = "//*[@id=\"SummonerLayoutContent\"]/div[2]/div[2]/div/div[2]")},
                             error = function(e){NULL})
    }
    
    # 선호 포지션, 해당 포지션 승률 
    line_table <- NULL
    while(is.null(line_table)){
      Sys.sleep(0.5)
      line_table <- tryCatch({infor_table$findChildElement(using = 'xpath', value = "//*[@id=\"GameAverageStatsBox-matches\"]/div[1]/table/tbody/tr[2]/td[3]/ul[1]/li[1]/div[2]/div")},
                             error = function(e){NULL})
    }
    line <- line_table$getElementText()[[1]]
    
    ratio_table <- infor_table$findChildElement(using = "xpath", value = "//*[@id=\"GameAverageStatsBox-matches\"]/div[1]/table/tbody/tr[2]/td[3]/ul[1]/li[1]/div[2]/span[2]/span/b")
    ratio_text <- ratio_table$getElementText()[[1]]
    ratio <- gsub("%","",ratio_text)
    
    # 선호 챔피언, 해당 챔피언 kda
    champ_table <- infor_table$findChildElement(using = "xpath", value = "//*[@id=\"GameAverageStatsBox-matches\"]/div[1]/table/tbody/tr[1]/td[2]/ul/li[1]/div[2]/div[2]")
    champ <- champ_table$getElementText()[[1]]
    
    kda_table <- infor_table$findChildElement(using = "xpath", value = "//*[@id=\"GameAverageStatsBox-matches\"]/div[1]/table/tbody/tr[1]/td[2]/ul/li[1]/div[2]/div[4]/span")
    kda <- kda_table$getElementText()[[1]]
    
    infor <- c(line,ratio,champ,kda)
    return(infor)
}

#shell('docker run -d -p 4445:4444 selenium/standalone-chrome')
remDr <- remoteDriver(
  remoteServerAddr = 'localhost', 
  port = 4445L,
  browserName = "chrome")
remDr$open()

url_ladder <- "https://www.op.gg/ranking/ladder/"
for( i in 2:5) url_ladder[i] <- paste0(url_ladder[1], 'page=', i)

# 상위 500명의 닉네임 추출 
  name <- c()
  # 1페이지 (1~100위)
  # 5위까지의 닉네임 추출 
  remDr$navigate(url_ladder[1])
  highest_table <- remDr$findElements(using = "class", value = "ranking-highest__name")
  sapply(highest_table, function(x) name <<- c(name, x$getElementText()[[1]] ) )
  # 6~100위의 닉네임 추출 
  for( i in 1:95 ) {
    name_ele <- remDr$findElement(using = "xpath", value = paste0('/html/body/div[2]/div[3]/div[3]/div/div/div/table/tbody/tr[',i,']/td[2]/a/span'))
    name[i+5] <- name_ele$getElementText()[[1]]
  }
  
  # 2~m페이지 (101~m*100위)
  for( j in 2:m ) {
    remDr$navigate(url_ladder[j])
    for( i in 1:100 ) {
      name_ele <- remDr$findElement(using = "xpath", value = paste0('/html/body/div[2]/div[3]/div[3]/div/div/div/table/tbody/tr[',i,']/td[2]/a/span'))
      name[i+((j-1)*100)] <- name_ele$getElementText()[[1]]
    }
  }
  name_url <- gsub(" ","+",name)

# 각 유저의 세부 정보 url
  url_user <- paste0('https://www.op.gg/summoner/userName=',name_url)

  result <- c()
  # 상위 n명까지의 정보 불러오기 
  for( i in 1:n ) result <- rbind(result,bringinfor(url_user[i]))
  LOLData <- data.frame(result[,1],
                       as.numeric(result[,2]),
                       result[,3],
                       as.numeric(result[,4]),
                       stringsAsFactors = F)
  rownames(LOLData) <- name[1:n]
  colnames(LOLData) <- c("선호 라인", "승률", "선호 챔피언", "kda")
  remDr$close()

# 데이터를 파일로 저장하기 
  # 생성할 폴더 이름 
  folder <- "D:/김종원/대학교/2학년/2학기/데이터 시각화/62p/data"
  
  # 폴더가 없으면 생성 
  if(!dir.exists(folder)) dir.create(folder)
  
  # working directory 변경 
  setwd(folder)
  
  date <- Sys.Date()
  h <- hour(Sys.time())
  m <- minute(Sys.time())
  filename <- paste(date, h, m, sep = '-')
  
  # 파일 저장 
  write.table(LOLData, file = filename)
