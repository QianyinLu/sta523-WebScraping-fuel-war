library(jsonlite)
library(tidyverse)
wawa_data <- readRDS("data/wawa/get_wawa.rds")
names <- wawa_data%>%sapply(unlist)%>% sapply(names)%>%unlist()%>%unique()
content <- wawa_data%>%
  lapply(unlist)%>%
  lapply(function(x){
    vac<-as.list(rep(NA,length(names)))
    names(vac)<-names
    name_list<-names(x)
    vac[name_list]<-x[name_list]
    return(vac)
  })

wawa.df <- map_df(content, `[`, names) %>% filter(!is.na(locationID)) 


saveRDS(wawa.df,"data/wawa/wawa.rds")

