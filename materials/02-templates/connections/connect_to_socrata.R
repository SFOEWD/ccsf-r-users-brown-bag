library(jsonlite)
library(httr)

socrataEmail <- "tania.jogesh@sfgov.org"
socrataPassword <- key_get("socrata")

#
get_socrata_dataset <- function(fourbyfour, row_limit=999999999, query = ''){
  socrataUrl <- glue::glue("https://data.sfgov.org/resource/{fourbyfour}.csv?{query}&$limit={row_limit}")
  # get request
  get_socrata <- GET(socrataUrl, 
                     authenticate(socrataEmail, socrataPassword)
  )
  #import all columns using readr detect type feature
  return(content(get_socrata, type = "text/csv"))
}

