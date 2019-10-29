library(jsonlite)
library(httr)
#basic url without the information of stores
base_url <- "https://www2.stat.duke.edu/~sms185/data/fuel/bystore/awaw/awawstore="
#transform all possible store ids into form of xxxxx and combine it with the base_url
store_urls<-str_c(base_url,sprintf("%05d.json",c(0:1000, 8000:9000)))

wawa_data <- map(store_urls,
                 function(store_url) {
                   #to filter out the invalid urls 
                   if (http_error(store_url)==F){
                     #to prevent being banned, use this function to make a time gap everytime we access the page
                     Sys.sleep(rexp(1))
                     #use tryCatch to avoid poor internet connection problem; read_json to access the data
                     tryCatch(read_json(store_url))
                   }
                 }
)
#save the data to get_wawa.rds file
saveRDS(wawa_data,file = "data/wawa/get_wawa.rds")

