
data_directory <- "Downloads"


library(rvest)
library(jsonlite)
library(dplyr)

sheetz <- "http://www2.stat.duke.edu/~sms185/data/fuel/bystore/zteehs/regions.html"

#get url 
url_headers <- read_html(sheetz)%>%
  html_nodes(".col-md-2 a") %>%
  html_text() %>%
  trimws()

url <- read_html(sheetz)%>%
  html_nodes(".col-md-2 a") %>%
  html_attr("href")

url <- url[!(url_headers %in% c("", NA, NULL))]


#funtion to get the large list of dataframe
sheetz <- lapply(url, function(url){
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

#mapping lists to a data frame of lists
sheetz2 <- map_df(sheetz, ~bind_cols(.), .default=NA)
 
#writing a helper function to convert NULLs to NAs
replace_null <- function(v){
  null_indices <- which(sapply(v, is.null))
  v[null_indices] <- NA
  return(v)
}

#finding row containing the most elements
elem_count <- sapply(1:nrow(sheetz2), 
                     function(i){sum(unlist(sheetz2[i,])!="NULL")})
max_elem <- which(elem_count == max(elem_count))

#finding column types based on the row with most elements
col_types <- sapply(colnames(sheetz2), function(i){
  typeof(sheetz2[max_elem[1], i][[1]])
})

#keeping track of columns by type
list_cols <- colnames(sheetz2)[col_types=="list"]
nonlist_cols <- colnames(sheetz2)[col_types!="list"]
char_cols <- colnames(sheetz2)[col_types=="character"]
dbl_cols <- colnames(sheetz2)[col_types=="double"]
int_cols <- colnames(sheetz2)[col_types=="integer"]
lgl_cols <- colnames(sheetz2)[col_types=="logical"]

#converting NULLs to NAs in non-list columns, and changing these
#columns to their appropriate type
sheetz3 <- sheetz2 %>%
  mutate_at(nonlist_cols, replace_null) %>%
  mutate_at(dbl_cols, as.double) %>%
  mutate_at(int_cols, as.integer) %>%
  mutate_at(char_cols, as.character) %>%
  mutate_at(lgl_cols, as.logical)

