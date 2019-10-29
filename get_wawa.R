library(jsonlite)
library(tidyverse)
library(httr)
base_url <- "https://www2.stat.duke.edu/~sms185/data/fuel/bystore/awaw/awawstore="
store_urls<-str_c(base_url,sprintf("%05d.json",c(0:1000, 8000:9000)))

wawa_data <- map(store_urls,
                 function(store_url) {
                   if (http_error(store_url)==F){
                     Sys.sleep(rexp(1))
                     tryCatch(read_json(store_url))
                   }
                 }
)

saveRDS(wawa_data,file = "data/wawa/get_wawa.rds")

