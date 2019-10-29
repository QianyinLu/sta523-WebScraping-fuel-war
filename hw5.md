---
title: "Homework 5"
author: '[Member names]'
date: "10/17/2019"
output: 
  html_document:
    keep_md: yes
---



###TASK 1
In order to get the hyperlinks for all Wawa stores, we first tried to generate all possible combination of store ID numbers for two given ranges in the correct format(5 digits). Then, we observed the overall pattern for individual url, which consists of a basic url and the store ID information. After that, we used a function called “http_error” to check which page is accessible. The function returns true if the hyperlink returns “HTTP error 404” and returns false if the url is valid. Thus, to correctly read the data, we applied a map function on all store hyperlinks and “http_error” to help filtering out the invalid links and read the valid json files. In addition, for everytime we read the json file, we added "Sys.sleep" function to prevent visiting the websites too frequently and being banned because of it. Also, to avoid the failure of visiting the website due to the unstable internet connection, we used "tryCatch" when reading the json file. Eventually we got a list called “wawa_data”, which consists of all valid store information and the rest stores with invalid hyperlink as NULL. Finally, we save the data as RDS file under the data/wawa directory.

Then, for the parsing part, to make the list become a data frame, we first extracted all variable names by un-listing the each store data and take the unique ones. Then, we assigned the value according to the name attribute store-by-store. After that, we map the content, which is also a list, to the data frame according to the variable names. Eventually, for each row of the data frame, we have each store identified by its unique location ID as well as its other related information. Notice that we decided to remove the store number since it is the same as the location ID. We also transformed “addresses.loc1” and “addresses.loc2” to double for further use in task 3.

###TASK 2
In the get_sheetz, we tried to obtain the urls we need for scraping and find the nodes for all 10 regions. We only need the previous 10 urls for data. After we get the urls, we wrote a function to get data: we read the html first, found out that the text part is some json data. Therefore, we used fromJSON to get the data frame. For one variable: storeAttribute, it’s a list of four data frame, and one of four data frames is just the same as storeNumber, which is already existed, so we just took other 3 data frame out and deleted storeAttribute. After using lapply for all 10 urls, we finally got a large list of 10 data frames.  And in the end, we saved the list named sheetz in get_sheetz.rds.  

In parse_sheetz, we modified the data a little bit cause data of region 10 is a little bit different from others. Only the first 7 observations of 30 observations is meaningful, other observations are just null; so we selected only the first 7 obs. Since the data of region 10 is missing one variable: specialDirection, so we mutated sepecialDirection as a list of NULL for region10. And we binded all the list together to get a complete data frame for sheetz data.




