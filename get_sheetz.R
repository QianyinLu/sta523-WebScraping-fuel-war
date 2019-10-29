library(rvest)
library(jsonlite)
library(dplyr)

sheetz <- "http://www2.stat.duke.edu/~sms185/data/fuel/bystore/zteehs/regions.html"

#get url 
urls <- read_html(sheetz)%>%
  html_nodes(".col-md-2 a")%>%
  html_attr("href")
urls <- as.vector(urls)[1:10]

#funtion to get the large list of dataframe
sheetz <- lapply(urls, function(url){
  json<- read_html(url)%>%
    html_nodes("body")%>%
    html_text()
  
  Sys.sleep(1)
  
  data <- fromJSON(json)%>%
    mutate( pickupTimeForAsap = storeAttribute$pickupTimeForAsap,
            pickupTimeForAsapCurbside = storeAttribute$pickupTimeForAsapCurbside, 
            paymentConfigType = storeAttribute$paymentConfigType)%>%
    select(-"storeAttribute")
  return(data)
})

saveRDS(sheetz, file = "data/sheetz/get_sheetz.rds")