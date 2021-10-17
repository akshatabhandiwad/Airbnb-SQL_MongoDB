setwd("set current working directory path here")
if(!require('bit64')) install.packages('bit64')
if(!require('stringi')) install.packages('stringi')

library("data.table")
library('bit64')
library("tidyverse")
library("dplyr")
library("stringi")

# Loding the raw files
Listing <- fread("listings.csv", strip.white = TRUE)
reviews <- fread("reviews.csv")
calendar <- fread("calendar.csv")



#------------------------------------------------------------------
#----------------------- Reviews Table ----------------------------
#------------------------------------------------------------------


reviews <- data.table(reviews[,c("id","listing_id","date","reviewer_id","reviewer_name","comments")])
reviews <- reviews[order(reviews$id, decreasing = FALSE)]
colnames(reviews) <- c("Review_id", "listing_id","Review_date","reviewer_id","reviewer_name","comments")

write.csv(reviews, file =  "add destination path/Cleaned data/reviews.csv",
         row.names = FALSE, na = "")




#------------------------------------------------------------------
#---------------------- Calendar Table ----------------------------
#------------------------------------------------------------------


# Separating calender table as Listing Availability
calendar$calendar_id <- seq(1:1393570)
calendar$available[calendar$available == "t"] <- 1
calendar$available[calendar$available == "f"] <- 0

calendar$price = as.numeric(gsub("\\$", "", calendar$price))
colnames(calendar) <- c("listing_id","date","available","price","calendar_id")

calendar <- calendar[,c("calendar_id","listing_id","date","available","price")]
calendar$price <- as.integer(calendar$price)
calendar$date <- as.POSIXct(calendar$date, format = "%Y%m%d")


write.csv(calendar, file =  "add destination path/Cleaned data/Listing Availability.csv",
          row.names = FALSE, na = "")




#-----------------------------------------------------------------
#---------------------- Listing Table ----------------------------
#-----------------------------------------------------------------


Listing$host_id <- gsub(" ", "", Listing$host_id)
Listing$host_url <- gsub(" ", "", Listing$host_url)
Listing$host_thumbnail_url <- gsub(" ", "", Listing$host_thumbnail_url)
Listing$host_picture_url <- gsub(" ", "", Listing$host_picture_url)


Listing$host_has_profile_pic[Listing$host_has_profile_pic == "t"] <- 1
Listing$host_has_profile_pic[Listing$host_has_profile_pic == "f"] <- 0
Listing$host_identity_verified[Listing$host_identity_verified == "t"] <- 1
Listing$host_identity_verified[Listing$host_identity_verified == "f"] <- 0


Listing$host_is_superhost[Listing$host_is_superhost == "t"] <- 1
Listing$host_is_superhost[Listing$host_is_superhost == "f"] <- 0

Listing$host_acceptance_rate <- gsub("%", "", Listing$host_acceptance_rate)
Listing$host_response_rate <- gsub("%", "", Listing$host_response_rate)



# removing $ sign and coverting into numeric
Listing$price = gsub("\\$", "", Listing$price)
Listing$price = as.numeric(gsub(",", "", Listing$price))

Listing$weekly_price = gsub("\\$", "", Listing$weekly_price)
Listing$weekly_price = as.numeric(gsub(",", "", Listing$weekly_price))

Listing$monthly_price = gsub("\\$", "", Listing$monthly_price)
Listing$monthly_price = as.numeric(gsub(",", "", Listing$monthly_price))

Listing$monthly_price = gsub("\\$", "", Listing$monthly_price)
Listing$extra_people = as.numeric(gsub(",", "", Listing$extra_people))

Listing$security_deposit = gsub("\\$", "", Listing$security_deposit)
Listing$security_deposit = as.numeric(gsub(",", "", Listing$security_deposit))

Listing$cleaning_fee = gsub("\\$", "", Listing$cleaning_fee)
Listing$cleaning_fee = as.numeric(gsub(",", "", Listing$cleaning_fee))

names(Listing)[names(Listing) == "price"] <- "price_per_night"




Listing$first_review <- (format(as.Date(Listing$first_review, "%m/%d/%y"), "20%y-%m-%d"))
Listing$first_review <- as.POSIXct(Listing$first_review, "%Y-%m-%d")
Listing$last_review <- (format(as.Date(Listing$last_review, "%m/%d/%y"), "20%y-%m-%d"))
Listing$last_review <- as.POSIXct(Listing$last_review, "%Y-%m-%d")
Listing$host_since <- (format(as.Date(Listing$host_since, "%m/%d/%y"), "20%y-%m-%d"))
Listing$host_since <- as.POSIXct(Listing$host_since, "%Y-%m-%d")
Listing$last_scraped <- (format(as.Date(Listing$last_scraped, "%m/%d/%y"), "20%y-%m-%d"))
Listing$last_scraped <- as.POSIXct(Listing$last_scraped, "%Y-%m-%d")




Listing$is_location_exact[Listing$is_location_exact == "t"] <- 1
Listing$is_location_exact[Listing$is_location_exact == "f"] <- 0

Listing$has_availability[Listing$has_availability == "t"] <- 1
Listing$has_availability[Listing$has_availability == "f"] <- 0

Listing$requires_license[Listing$requires_license == "t"] <- 1
Listing$requires_license[Listing$requires_license == "f"] <- 0

Listing$instant_bookable[Listing$instant_bookable == "t"] <- 1
Listing$instant_bookable[Listing$instant_bookable == "f"] <- 0

Listing$require_guest_profile_picture[Listing$require_guest_profile_picture == "t"] <- 1
Listing$require_guest_profile_picture[Listing$require_guest_profile_picture == "f"] <- 0

Listing$require_guest_phone_verification[Listing$require_guest_phone_verification == "t"] <- 1
Listing$require_guest_phone_verification[Listing$require_guest_phone_verification == "f"] <- 0


# Cleaning the city column
Listing$city <- gsub("seattle", "Seattle", Listing$city)
Listing$city <- gsub("Ballard, Seattle", "Seattle", Listing$city) 
Listing$city <- gsub("Phinney Ridge Seattle", "Seattle", Listing$city)
Listing$city <- gsub("西雅图", "Seattle", Listing$city)


# Cleaning the smart location column
Listing$smart_location <- gsub("seattle, wa", "Seattle, WA", Listing$smart_location)
Listing$smart_location <- gsub("Ballard, Seattle, WA", "Seattle, WA", Listing$smart_location)
Listing$smart_location <- gsub("Seattle , WA", "Seattle, WA", Listing$smart_location)
Listing$smart_location <- gsub("西雅图, WA", "Seattle, WA", Listing$smart_location)
Listing$smart_location <- gsub("Phinney Ridge Seattle, WA", "Seattle, WA", Listing$smart_location)


# Cleaning the zip code column
Listing$zipcode[Listing$zipcode == "99\n98122"] <- 98122


# Creating and Cleaning the street address column
Listing$street_address <- Listing$street
Listing$street_address <- gsub('United States', "", Listing$street_address)
Listing$street_address <- gsub("(,).*","\\1", Listing$street_address)
Listing$street_address <- gsub(',', "", Listing$street_address)

# dropping street column from listing
Listing <- Listing[, -c("street")]

setnames(Listing, "id", "listing_id")


write.csv(Listing, file =  "add destination path/Cleaned data/Listing.csv",
          row.names = FALSE, na = "")
