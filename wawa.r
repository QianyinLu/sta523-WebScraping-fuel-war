library(jsonlite)
library(tidyverse)
library(httr)
base_url <- "https://www2.stat.duke.edu/~sms185/data/fuel/bystore/awaw/awawstore="
store_urls<-str_c(base_url,sprintf("%0005d.json",8070:8080))

wawa_data <- map(store_urls,
  function(store_url) {
  if (http_error(store_url)==F){
    read_json(store_url)
  }
  }
)


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
