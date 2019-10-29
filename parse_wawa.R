library(jsonlite)
library(tidyverse)
#get the data we scraped from the website
wawa_data <- readRDS("data/wawa/get_wawa.rds")
#get all variable names 
names <- wawa_data%>%sapply(unlist)%>% sapply(names)%>%unlist()%>%unique()
#put values under according names store by store
content <- wawa_data%>%
  lapply(unlist)%>%
  lapply(function(x){
    #create a vacant list with names we extracted 
    vac<-as.list(rep(NA,length(names)))
    names(vac)<-names
    #extract the names (attributes) for the particular stores
    name_list<-names(x)
    #put the particular store's information into the vacant list accordinng to names
    vac[name_list]<-x[name_list]
    return(vac)
  })

#transform content into a dataframe according to names
wawa.df <- map_df(content, `[`, names) %>%
  filter(!is.na(locationID)) %>%  #filter out invalid stores
  select(-storeNumber) %>%  #storeNumber is the same as location ID, so remove it
  #change the following from character to double
  mutate(addresses.loc1 = as.double(addresses.loc1))%>% 
  mutate(addresses.loc2 = as.double(addresses.loc2))


saveRDS(wawa.df,"data/wawa/wawa.rds")
