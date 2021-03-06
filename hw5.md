---
title: "Homework 5"
author: '[Qianyin Lu, Evan Wyse, Morris Greenberg, Zewen Zhang]'
date: "10/17/2019"
output: 
  html_document:
    keep_md: yes
---



### TASK 1
In order to get the hyperlinks for all Wawa stores, we first tried to generate all possible combination of store ID numbers for two given ranges in the correct format(5 digits). Then, we observed the overall pattern for individual url, which consists of a basic url and the store ID information. After that, we used a function called “http_error” to check which page is accessible. The function returns true if the hyperlink returns “HTTP error 404” and returns false if the url is valid. Thus, to correctly read the data, we applied a map function on all store hyperlinks and “http_error” to help filtering out the invalid links and read the valid json files. In addition, for everytime we read the json file, we added "Sys.sleep" function to prevent visiting the websites too frequently and being banned because of it. Also, to avoid the failure of visiting the website due to the unstable internet connection, we used "tryCatch" when reading the json file. Eventually we got a list called “wawa_data”, which consists of all valid store information and the rest stores with invalid hyperlink as NULL. Finally, we save the data as RDS file under the data/wawa directory.

Then, for the parsing part, to make the list become a data frame, we first extracted all variable names by un-listing the each store data and take the unique ones. Then, we assigned the value according to the name attribute store-by-store. After that, we map the content, which is also a list, to the data frame according to the variable names. Eventually, for each row of the data frame, we have each store identified by its unique location ID as well as its other related information. Notice that we decided to remove the store number since it is the same as the location ID. We also transformed “addresses.loc1” and “addresses.loc2” to double for further use in task 3.

### TASK 2
In the get_sheetz, we tried to obtain the urls we need for scraping and find the nodes for all 10 regions. We only need the previous 10 urls for data. After we get the urls, we wrote a function to get data: we read the html first, found out that the text part is some json data. Therefore, we used fromJSON to get the data frame. For one variable: storeAttribute, it’s a list of four data frame, and one of four data frames is just the same as storeNumber, which is already existed, so we just took other 3 data frame out and deleted storeAttribute. After using lapply for all 10 urls, we finally got a large list of 10 data frames.  And in the end, we saved the list named sheetz in get_sheetz.rds.  

In parse_sheetz, we modified the data a little bit cause data of region 10 is a little bit different from others. Only the first 7 observations of 30 observations is meaningful, other observations are just null; so we selected only the first 7 obs. Since the data of region 10 is missing one variable: specialDirection, so we mutated sepecialDirection as a list of NULL for region10. And we binded all the list together to get a complete data frame for sheetz data.


### TASK 3

```r
if (! require(ggmap)) {
  install.packages("ggmap", contriburl="https://cloud.r-project.org")
  library(ggmap)
}
if (! require(ggvornoi)) {
  install.packages("ggvoronoi", contriburl="https://cloud.r-project.org")
  library(ggvoronoi)
}
library(tidyverse)
if(! require(maps)){
  install.packages("maps", contriburl="https://cloud.r-project.org")
  library(maps)
}


wawa <- readRDS('data/wawa/wawa.rds') # TODO change 
wawa2 <- as_tibble(wawa) %>% mutate(lat=as.numeric(addresses.loc1),
                                lon=as.numeric(addresses.loc2),
                                store_id=locationID) %>%
  mutate(store_type="wawa") %>% select(lat, lon, store_id, store_type)
sheetz <- readRDS('data/sheetz/sheetz.rds') # TODO change
sheetz <- tibble(lat=unlist(sheetz$latitude), 
                 lon=unlist(sheetz$longitude),
                 store_id=sheetz$storeNumber,
                 store_type="sheetz")
data <- rbind(wawa2, sheetz)
```



```r
load("maps.rda") # load in google maps so we don't have to share API keys

outline <- data.frame(long=c(-75, -77, -77, -75, -75), lat=c(40,40,41,41, 40), group=c(1,1,1,1, 1), order=1:5) # a closed box
outline_states <- map_data("state") %>% filter(region %in% c("new jersey", "pennsylvania", "maryland", "delaware"))

ggmap(large_map,
      base_layer=ggplot(data=data, mapping=aes(x=lon,y=lat)))  + 
  # xlim(-77, -75)+ylim(40, 41) + 
  geom_voronoi(data=data, aes(x=lon,y=lat, fill=store_type, alpha=0.1), outline=outline_states, show.legend=F) +
  geom_path(stat="voronoi", alpha=0.5, color='white') + 
  geom_point(data=data, aes(x=lon,y=lat, color=store_type), size=0.3) + 
  scale_fill_manual(values=c("#AED6F1","#F5B7B1")) + 
  scale_color_manual(values=c("#3498DB", "#E74C3C")) + 
  theme(legend.position = "bottom") + 
  labs(title="Territory Occupied in PA, NJ, MD", 
       color="Store Type") 
```

![](hw5_files/figure-html/map_one-1.png)<!-- -->

We were curious about the "territory" that each Sheetz and Wawa store occupies, and so produced the Voronoi partitioning for a subset of stores in the Pennsylvania/New Jersey/Maryland area. This technique divides the map based on the store that each , and colors it based on whether that store belongs to Wawa or Sheetz. 

This technique is a somewhat crude approximation, in that consumer behavior is impacted not so much by simple geographical distance, but by travel times to and from a particular location, typically by car. Another deficiency in our analysis is that the package used, ggvoronoi, currently calculates the Voronoi partitioning based on 2d Euclidean distance, rather than a more appropriate haversine metric or other distance metric. 

However, we are able to discern some interesting patterns. First, it's immediately obvious that stores in rural areas appear to be significantly more widely spaced than in urban/suburban ones. Also, the "turf war" between the two types of stores seems to occur along a relatively well defined line, with several distinct communities with overlapping presence of Wawa and Sheetz stores. 



```r
ggmap(base_map,
      base_layer=ggplot(data=data, mapping=aes(x=lon,y=lat)))  + 
  # xlim(-77, -75)+ylim(40, 41) + 
  geom_voronoi(data=data, aes(x=lon,y=lat, fill=store_type, alpha=0.1), outline=outline, show.legend=F) +
  geom_path(stat="voronoi", alpha=0.5, color='white') + 
  geom_point(data=data, aes(x=lon,y=lat, color=store_type), size=0.3) + 
  scale_fill_manual(values=c("#AED6F1","#F5B7B1")) + 
  scale_color_manual(values=c("#3498DB", "#E74C3C")) + 
  theme(legend.position = "bottom") + 
  labs(title="Territory Occupied in Eastern PA", 
       color="Store Type") 
```

![](hw5_files/figure-html/map_two-1.png)<!-- -->

Zooming in to this "dividing line", in these communities, there are several interesting instances where two competing stores are placed directly next to one another - which constrasts significantly to the relatively even spacing of stores when only one competitor is placing them in an area. It's not clear whether this is an attempt to deliberately compete with the other type of store, or whether these particular locations represent an "optimal" place to put a convenience store. 
