# install.packages("lubridate")
# install.packages("taskscheduleR")
library(lubridate)
library(taskscheduleR)

dir <- 'D:/������/���б�/2�г�/2�б�/������ �ð�ȭ/62/code/GetData.R'

# ������ ���� 
taskscheduler_create(taskname = 'LOL_Data', rscript = dir,
                     schedule = 'DAILY',
                     starttime = "16:31",
                     startdate = format(Sys.Date(), '%Y/%m/%d'))

# ������ ����
taskscheduler_delete('LOL_Data')