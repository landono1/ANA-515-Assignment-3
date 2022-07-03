setwd("C:/Users/lala/Dropbox/ANA515 Data Storage/")
getwd()
url <- "StormEvents_details-ftp_v1.0_d1994_c20220425.csv"
storm<-read.csv(url)
storm

library(tidyverse)
library (tidyr)
library(dplyr)
library(ggplot2)

#2
newvars <- c("BEGIN_DATE_TIME","END_DATE_TIME","EPISODE_ID","EVENT_ID","STATE","STATE_FIPS","CZ_NAME","CZ_TYPE","CZ_FIPS","EVENT_TYPE","SOURCE","BEGIN_LAT","BEGIN_LON","END_LAT","END_LON")
mydata <- storm[newvars]
hear(mydata)

#3
mydata <-arrange(mydata,STATE)
 
#4
mydata$STATE <- str_to_title(mydata$STATE)
mydata$CZ_NAME <- str_to_title(mydata$CZ_NAME)

#5
mydata <- mydata %>%
  filter(CZ_TYPE == "C") %>%
  select(-CZ_TYPE)

#6
mydata <- mydata %>%
  mutate(
    STATE_FIPS=str_pad(STATE_FIPS, width=3,side="left", pad="0"),
    CZ_FIPS=str_pad(CZ_FIPS, width=3,side="left", pad="0")
    ) %>%
unite(col="FIPS",c(STATE_FIPS,CZ_FIPS),sep="")

#7
mydata<-  rename_all(mydata,tolower)

#8
data("state")
us_state_info <-data.frame(state=state.name,region=state.region,area=state.area)

#9
newset<- data.frame(table(mydata$state))
head(newset)
newset1<- rename(newset,c("state"="Var1"))
merged<- merge(x=newset1,y=us_state_info, by.x="state",by.y="state")
view(merged)

#10
plot <- ggplot(merged, aes(x=area,y=Freq))+geom_point(aes(color=region))+ labs(x="Land area (square miles", y="# of events in 1994")
plot