library(tidyverse)

sheetz <- readRDS("data/sheetz/get_sheetz.rds")

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
  mutate_at(lgl_cols, as.logical) %>%
  filter(storeNumber!="NA")

saveRDS(sheetz3, file = "data/sheetz/sheetz.rds")