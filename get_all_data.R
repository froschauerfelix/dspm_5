# data generating process
library(httr)
source("~/R/DS ProjectManagement/Assignment 5/API_key.R")
library(jsonlite)
library(ggplot2)
library(readr)


# Germany
df_venues_de <- 
  data.frame(
    name = character(), 
    city = character(), 
    postalcode = integer(), 
    address = character(),
    url = character(), 
    long = integer(), 
    lat = integer())

# get page number Germany
venues_response_germany <- GET(paste(
  "https://app.ticketmaster.com/discovery/v2/venues.json?countryCode=DE&apikey", 
  api_key, sep = "="))
page_number_germany <- jsonlite::fromJSON(
  content(venues_response_germany, as = "text"))[["page"]][["totalPages"]]


for (m in 0:page_number_germany-2) {
  
  # create temporary data frame
  new_df <- 
    data.frame(
      name = character(20), 
      city = character(20), 
      postalcode = integer(20), 
      address = character(20),
      url = character(20), 
      long = integer(20), 
      lat = integer(20))
  
  # get page m of the API
  venues_response_loop <- GET(paste(paste(paste("https://app.ticketmaster.com/discovery/v2/venues.json?countryCode=DE&apikey", api_key, sep = "="),"page", sep="&"),m, sep="="))
  venues_list_loop <- jsonlite::fromJSON(content(venues_response_loop, as = "text"))[["_embedded"]][["venues"]]
  
  
  # account for missing or incomplete values
  new_df$name <- rep(NA, 20)
  new_df$city <- rep(NA, 20)
  new_df$postalcode <- rep(NA, 20)
  new_df$address <- rep(NA, 20)
  new_df$url <- rep(NA, 20)
  new_df$long<-rep(NA, 20)
  new_df$lat<- rep(NA, 20)
  
  # save the data in a new data frame
  if (!is.null(venues_list_loop$name)) {
    new_df$name <- venues_list_loop$name
  }
  
  if (!is.null(venues_list_loop$city$name)) {
    new_df$city <- venues_list_loop$city$name
  }
  
  if (!is.null(venues_list_loop$postalCode)) {
    new_df$postalcode <- venues_list_loop$postalCode
  }
  
  if (!is.null(venues_list_loop$address$line1)) {
    new_df$address <- venues_list_loop$address$line1
  }
  
  if (!is.null(venues_list_loop$url)) {
    new_df$url <- venues_list_loop$url
  }
  
  
  if (!is.null(venues_list_loop$location$longitude)) {
    new_df$long <- venues_list_loop$location$longitude
  }
  
  
  if (!is.null(venues_list_loop$location$latitude)){
    new_df$lat <- venues_list_loop$location$latitude
  }
  
  
  print(new_df)
  # combine the iterating data frame and the permanent one
  df_venues_de <- rbind(df_venues_de, new_df)
  
  print(m)
  # sleep so that we do not recall too often
  Sys.sleep(0.3)
  
  
}


# France


# create final data set
df_venues_fr <- 
  data.frame(
    name = character(), 
    city = character(), 
    postalcode = integer(), 
    address = character(),
    url = character(), 
    long = integer(), 
    lat = integer())

# get page number
venues_response_france <- GET(paste(
  "https://app.ticketmaster.com/discovery/v2/venues.json?countryCode=FR&apikey", 
  api_key, sep = "="))
page_number_france <- jsonlite::fromJSON(
  content(venues_response_france, as = "text"))[["page"]][["totalPages"]]


for (m in 0:page_number_france-2) {
  
  # create temporary data frame
  new_df <- 
    data.frame(
      name = character(20), 
      city = character(20), 
      postalcode = integer(20), 
      address = character(20),
      url = character(20), 
      long = integer(20), 
      lat = integer(20))
  
  # get page m of the API
  venues_response_loop <- GET(paste(paste(paste("https://app.ticketmaster.com/discovery/v2/venues.json?countryCode=FR&apikey", api_key, sep = "="),"page", sep="&"),m, sep="="))
  venues_list_loop <- jsonlite::fromJSON(content(venues_response_loop, as = "text"))[["_embedded"]][["venues"]]
  
  
  # account for missing or incomplete values
  new_df$name <- rep(NA, 20)
  new_df$city <- rep(NA, 20)
  new_df$postalcode <- rep(NA, 20)
  new_df$address <- rep(NA, 20)
  new_df$url <- rep(NA, 20)
  new_df$long<-rep(NA, 20)
  new_df$lat<- rep(NA, 20)
  
  # save the data in a new data frame
  if (!is.null(venues_list_loop$name)) {
    new_df$name <- venues_list_loop$name
  }
  
  if (!is.null(venues_list_loop$city$name)) {
    new_df$city <- venues_list_loop$city$name
  }
  
  if (!is.null(venues_list_loop$postalCode)) {
    new_df$postalcode <- venues_list_loop$postalCode
  }
  
  if (!is.null(venues_list_loop$address$line1)) {
    new_df$address <- venues_list_loop$address$line1
  }
  
  if (!is.null(venues_list_loop$url)) {
    new_df$url <- venues_list_loop$url
  }
  
  
  if (!is.null(venues_list_loop$location$longitude)) {
    new_df$long <- venues_list_loop$location$longitude
  }
  
  
  if (!is.null(venues_list_loop$location$latitude)){
    new_df$lat <- venues_list_loop$location$latitude
  }
  
  
  print(new_df)
  # combine the iterating data frame and the permanent one
  df_venues_fr <- rbind(df_venues_fr, new_df)
  
  print(m)
  # sleep so that we do not recall too often
  Sys.sleep(0.3)
  
  
}


# save the data sets in a csv file

write.csv(df_venues_de,"~/R/DS ProjectManagement/Assignment 5/dspm_5/df_venues_de.csv", row.names = TRUE)
write.csv(df_venues_fr,"~/R/DS ProjectManagement/Assignment 5/dspm_5/df_venues_fr.csv", row.names = TRUE)






