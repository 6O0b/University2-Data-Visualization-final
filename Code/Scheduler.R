# install.packages("lubridate")
# install.packages("taskscheduleR")
library(lubridate)
library(taskscheduleR)

dir <- 'D:/김종원/대학교/2학년/2학기/데이터 시각화/62/code/GetData.R'

# 스케줄 생성 
taskscheduler_create(taskname = 'LOL_Data', rscript = dir,
                     schedule = 'DAILY',
                     starttime = "16:31",
                     startdate = format(Sys.Date(), '%Y/%m/%d'))

# 스케줄 삭제
taskscheduler_delete('LOL_Data')
