---
title: "Homework 5"
author: '[]'
date: "10/17/2019"
output: 
  html_document:
    keep_md: yes
---




```r
library(tidyverse)
library(rvest)
library(jsonlite)
```


```r
sheetz <- readRDS("data/sheetz/sheetz.rds")
```


```r
wawa <- readRDS("data/wawa/wawa.rds")
wawa
```

```
# A tibble: 289 x 29
   locationID storeName openType areaManager regionalDirector telephone
   <chr>      <chr>     <chr>    <chr>       <chr>            <chr>    
 1 00007      WAWA, ST… 24hours  MAGEE, JAM… MAIOLINO, MARC   484-451-…
 2 00008      WAWA, ST… 24hours  CASEY, CHR… MAIOLINO, MARC   610-356-…
 3 00009      WAWA, ST… 24hours  CONLAN, SA… MAIOLINO, MARC   610-623-…
 4 00011      WAWA, ST… 24hours  CONLAN, SA… MAIOLINO, MARC   610-259-…
 5 00012      WAWA, ST… 24hours  CASEY, CHR… MAIOLINO, MARC   610-623-…
 6 00014      WAWA, ST… 24hours  CASEY, CHR… MAIOLINO, MARC   610-446-…
 7 00021      WAWA, ST… 24hours  SCHWARTZ, … DEPAOLO, GINA    215-233-…
 8 00023      WAWA, ST… 24hours  CONLAN, SA… MAIOLINO, MARC   610-237-…
 9 00025      WAWA, ST… 24hours  OHARA, TIM  MAIOLINO, MARC   610-696-…
10 00030      WAWA, ST… 24hours  MAGEE, JAM… MAIOLINO, MARC   484 893-…
# … with 279 more rows, and 23 more variables: isActive <chr>,
#   storeOpen <chr>, storeClose <chr>, open24Hours <chr>,
#   storeNumber <chr>, lastUpdated <chr>, amenities.food <chr>,
#   amenities.fuel <chr>, amenities.restrooms <chr>,
#   amenities.ethanolFreeGas <chr>, amenities.teslaChargingStation <chr>,
#   addresses.context <chr>, addresses.address <chr>,
#   addresses.city <chr>, addresses.state <chr>, addresses.zip <chr>,
#   addresses.loc1 <chr>, addresses.loc2 <chr>, hasMenu <chr>,
#   addressUrl <chr>, fuelTypes.description <chr>, fuelTypes.price <chr>,
#   fuelTypes.currency <chr>
```

### Task2 writeup
In the get_sheetz, we tried to obtain the urls we need for scraping and find the nodes for all 10 regions. We only need the previous 10 urls for data. After we get the urls, we wrote a function to get data: we read the html first, found out that the text part is some json data. Therefore, we used fromJSON to get the data frame. For one variable: storeAttribute, it’s a list of four data frame, and one of four data frames is just the same as storeNumber, which is already existed, so we just took other 3 data frame out and deleted storeAttribute. After using lapply for all 10 urls, we finally got a large list of 10 data frames.  And in the end, we saved the list named sheetz in get_sheetz.rds.  

In parse_sheetz, we modified the data a little bit cause data of region 10 is a little bit different from others. Only the first 7 observations of 30 observations is meaningful, other observations are just null; so we selected only the first 7 obs. Since the data of region 10 is missing one variable: specialDirection, so we mutated sepecialDirection as a list of NULL for region10. And we binded all the list together to get a complete data frame for sheetz data. 

