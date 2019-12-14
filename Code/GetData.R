# install.packages("RSelenium")
# install.packages("lubridate")
library(RSelenium)
library(lubridate)

# ���� ���� url�� �����Ͽ� ������ �ҷ��� �ִ� �Լ�
#   ���⼭ ������ �ַ�/��� ��ũ �÷��� �� ��ȣ�ϴ� �����ǰ� �ش� ������ �·�,  
#   ��ȣ�ߴ� è�Ǿ�� �ش� è�Ǿ� �÷��� �� kda�� ���Ѵ�.
bringinfor <- function( url ) {
  
  remDr$navigate(url)
  
  # Solo/Duo ��ũ �÷��� ������ ���� 
  filter <- remDr$findElement(using = "xpath", value = "//*[@id=\"right_gametype_soloranked\"]/a")
  filter$clickElement()
  Sys.sleep(2) # ��� ���� �� �ε� �ð��� ���� �� ���� 
  
  # �� ���� ���� 
    infor_table <- remDr$findElement(using = "class", value = "GameAverageStats")
    
    # ��ȣ ������, �ش� ������ �·� 
    line_table <- infor_table$findChildElement(using = "class", value = "PositionStatContent")
    line_text <- line_table$getElementText()[[1]]
    line <- substr(line_text,1,regexpr("\n",line_text)-1)
    
    ratio_table <- infor_table$findChildElement(using = "class", value = "WinRatio")
    ratio_text <- ratio_table$getElementText()
    ratio <- gsub("�·� ","",ratio_text)
    ratio <- gsub("%","",ratio)
    
    # ��ȣ è�Ǿ�, �ش� è�Ǿ� kda
    champ_table <- infor_table$findChildElement(using = "class", value = "Name")
    champ <- champ_table$getElementText()[[1]]
    
    kda_table <- infor_table$findChildElement(using = "xpath", value = "//*[@id=\"GameAverageStatsBox-matches\"]/div[1]/table/tbody/tr[1]/td[2]/ul/li[1]/div[2]/div[4]/span")
    kda <- kda_table$getElementText()[[1]]
    
    infor <- c(line,ratio,champ,kda)
    return(infor)
}

shell('docker run -d -p 4445:4444 selenium/standalone-chrome') # Docker�� ����� �߰� 
remDr <- remoteDriver(
  remoteServerAddr = 'localhost', 
  port = 4445L,
  browserName = "chrome")
remDr$open()

url_ladder <- "https://www.op.gg/ranking/ladder/"
for( i in 2:5) url_ladder[i] <- paste0(url_ladder[1], 'page=', i)

# ���� 500���� �г��� ���� 
  name <- c()
  # 1������ (1~100��)
  # 5�������� �г��� ���� 
  remDr$navigate(url_ladder[1])
  highest_table <- remDr$findElements(using = "class", value = "ranking-highest__name")
  sapply(highest_table, function(x) name <<- c(name, x$getElementText()[[1]] ) )
  # 6~100���� �г��� ���� 
  for( i in 1:95 ) {
    name_ele <- remDr$findElement(using = "xpath", value = paste0('/html/body/div[2]/div[3]/div[3]/div/div/div/table/tbody/tr[',i,']/td[2]/a/span'))
    name[i+5] <- name_ele$getElementText()[[1]]
  }
  
  # 2~5������ (101~500��)
  for( j in 2:5 ) {
    remDr$navigate(url_ladder[j])
    for( i in 1:100 ) {
      name_ele <- remDr$findElement(using = "xpath", value = paste0('/html/body/div[2]/div[3]/div[3]/div/div/div/table/tbody/tr[',i,']/td[2]/a/span'))
      name[i+((j-1)*100)] <- name_ele$getElementText()[[1]]
    }
  }
  name_url <- gsub(" ","+",name)

# �� ������ ���� ���� url
  url_user <- paste0('https://www.op.gg/summoner/userName=',name_url)

  result <- c()
  # ���� n�������� ���� �ҷ����� 
  n <- 10
  for( i in 1:n ) result <- rbind(result,bringinfor(url_user[i]))
  LOLData <- data.frame(result[,1],
                       as.numeric(result[,2]),
                       result[,3],
                       as.numeric(result[,4]),
                       stringsAsFactors = F)
  rownames(LOLData) <- name[1:n]
  colnames(LOLData) <- c("��ȣ ����", "�·�", "��ȣ è�Ǿ�", "kda")
  
  remDr$close()

# ������ ���Ϸ� �����ϱ� 
  # ������ ���� �̸� 
  folder <- "D:/������/���б�/2�г�/2�б�/������ �ð�ȭ/62/data"
  
  # ������ ������ ���� 
  if(!dir.exists(folder)) dir.create(folder)
  
  # working directory ���� 
  setwd(folder)
  
  date <- Sys.Date()
  h <- hour(Sys.time())
  m <- minute(Sys.time())
  filename <- paste(date, h, m, sep = '-')
  
  # ���� ���� 
  write.table(LOLData, file = filename)
  