library(rvest)
library(jsonlite)
library(dplyr)

sheetz <- "http://www2.stat.duke.edu/~sms185/data/fuel/bystore/zteehs/regions.html"

#get url 
url <- read_html(sheetz)%>%
  html_nodes(".col-md-2 a")%>%
  html_attr("href")
url <- url[1:10]

#funtion to get the large list of dataframe
getlist <- function(x){
  json<- read_html(x)%>%
    html_nodes("body")%>%
    html_text()
  
  Sys.sleep(1)
  
  data <- fromJSON(json)%>% 
    mutate(pickupTimeForAsap = storeAttribute$pickupTimeForAsap,
           pickupTimeForAsapCurbside = storeAttribute$pickupTimeForAsapCurbside, 
           paymentConfigType = storeAttribute$paymentConfigType)%>%
    select(-37)
}

# dataframe of first 9 regions
data1 <- lapply(url[1:9], getlist)
sheetz.df1 <- do.call(rbind, data1)

#For region10
json10<- read_html(url[10])%>%
  html_nodes("body")%>%
  html_text()

data10 <- fromJSON(json10)[(1:7),] %>%
  mutate(specialDirections = list(NULL),
         pickupTimeForAsap = storeAttribute$pickupTimeForAsap,
         pickupTimeForAsapCurbside = storeAttribute$pickupTimeForAsapCurbside, 
         paymentConfigType = storeAttribute$paymentConfigType)%>%
  select(1:10,37,11:35,38:41)

# Combine dataframe of region1-9 and 10 together
sheetz.df <- rbind(sheetz.df1, data10)
