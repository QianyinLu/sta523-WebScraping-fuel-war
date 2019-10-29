library(dplyr)

sheetz <- readRDS("data/sheetz/get_sheetz.rds")

sheetz[[10]] <- sheetz[[10]][1:7,] %>%
  mutate(specialDirections = list(NULL))

sheetz <- do.call(rbind, sheetz)

saveRDS(sheetz, file = "data/sheetz/sheetz.rds")