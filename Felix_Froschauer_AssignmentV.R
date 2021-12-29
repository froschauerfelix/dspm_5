# Assignment 5 - DSPM

# main addition


# libraries and variables
library(httr)
source("~/R/DS ProjectManagement/Assignment 5/API_key.R")
library(jsonlite)
library(ggplot2)
library(readr)

# Interacting with the API - the basics

# creating the data set with 20 rows
size <- 20
df_venues_de_page_1 <- 
  data.frame(
    name = character(size), 
    city = character(size), 
    postalcode = integer(size), 
    address = character(size),
    url = character(size), 
    long = integer(size), 
    lat = integer(size))


# complete list of venues in Germany (Only page 1)
venues_response <- GET(paste(
  "https://app.ticketmaster.com/discovery/v2/venues.json?countryCode=DE&apikey", 
  api_key, sep = "="))
venues_list <- jsonlite::fromJSON(
  content(venues_response, as = "text"))[["_embedded"]][["venues"]]

# insert data from venues to data frame
df_venues_de_page_1$name <- venues_list$name
df_venues_de_page_1$city <- venues_list$city$name
df_venues_de_page_1$postalcode <- venues_list$postalCode
df_venues_de_page_1$address <- venues_list$address$line1
df_venues_de_page_1$url <- venues_list$url 
df_venues_de_page_1$long<- venues_list$location$longitude
df_venues_de_page_1$lat<- venues_list$location$latitude


# Interacting with the API - advanced

# specify the country
country <- "Germany"
country_code <- "de"


# file with data generating process
df_venues <- read_csv(paste(paste("df_venues",country_code,sep="_"), "csv", sep="."))


# correct type
df_venues$long <- as.numeric(df_venues$long)
df_venues$lat <- as.numeric(df_venues$lat)

# eliminating extreme and missing values
if (country == "Germany"){
subset_venues <- subset(df_venues, lat > 47.271679)
subset_venues <- subset(subset_venues, lat < 55.0846)

subset_venues <- subset(subset_venues, long > 5.866943)
subset_venues <- subset(subset_venues, as.numeric(long) < 15.043611)
}


if (country == "France") {
  subset_venues <- subset(df_venues, lat > 40)
  subset_venues <- subset(subset_venues_fr, lat < 51.05)
  
  subset_venues <- subset(subset_venues, long > -5.5)
  subset_venues <- subset(subset_venues, as.numeric(long) < 10)
  
}

title <- paste("Event locations across", country, sep=" ")


# plot for specific country
ggplot() +
  geom_polygon(
    aes(x = long, y = lat, group = group), data = map_data("world", region = country),
    fill = "grey90",color = "black") +
  theme_void() + coord_quickmap() +
  labs(title = title,caption = "Source: ticketmaster.com") +
  theme(title = element_text(size=8, face='bold'),
        plot.caption = element_text(face = "italic")) +
  geom_point(data = subset_venues, aes(x = long, y = lat), color = "red", size = 0.2) 




