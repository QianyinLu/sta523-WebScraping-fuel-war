---
title: "Homework 5"
author: '[Member names]'
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
typeof(sheetz)
```

```
[1] "list"
```

