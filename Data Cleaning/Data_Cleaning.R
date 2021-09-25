setwd("path to the working directory")

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

reviews[, .N, by=.(reviewer_id)]

# Separating reviewer details table
reviewer_datails <- data.table(unique(reviews[,4:5]))
reviewer_datails <- reviewer_datails[order(reviewer_datails$reviewer_id, decreasing = FALSE)]

# write.csv(reviewer_datails, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/reviewer details.csv", row.names = FALSE)
  

              
#------------------------------------------------------------------
# Separating reviews table 
review.final <- data.table(reviews[,c("id","listing_id","date","reviewer_id","comments")])
review.final <- review.final[order(review.final$id, decreasing = FALSE)]
colnames(review.final) <- c("Review_id", "listing_id","Review_date","reviewer_id","comments")

#write.csv(review.final, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/reviews.csv",
#          row.names = FALSE)




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


#write.csv(calendar, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing Availability.csv",
#          row.names = FALSE)




#------------------------------------------------------------------------------------
#---------------------- Host Raw data from Listing Table ----------------------------
#------------------------------------------------------------------------------------


# Separating Host raw table from Listings table
Listing[, .N, by=.(host_id)]

host.raw <- data.table(Listing[,c("host_id","host_url","host_name","host_since","host_location","host_about",
                                  "host_response_time","host_response_rate","host_acceptance_rate",
                                  "host_is_superhost","host_thumbnail_url","host_picture_url",
                                  "host_neighbourhood","host_listings_count","host_total_listings_count",
                                  "host_verifications","host_has_profile_pic","host_identity_verified")])
host.raw <- host.raw[order(host.raw$host_id, decreasing = FALSE)]

host.raw <- data.table(unique(host.raw[,c("host_id","host_url","host_name","host_since","host_location","host_about",
                                          "host_response_time","host_response_rate","host_acceptance_rate",
                                          "host_is_superhost","host_thumbnail_url","host_picture_url",
                                          "host_neighbourhood","host_listings_count","host_total_listings_count",
                                          "host_verifications","host_has_profile_pic","host_identity_verified")]))



# removing Host raw columns from listing
Listing <- Listing[, -c("host_url","host_name","host_since","host_location","host_about",
                        "host_response_time","host_response_rate","host_acceptance_rate",
                        "host_is_superhost","host_thumbnail_url","host_picture_url",
                        "host_neighbourhood","host_listings_count","host_total_listings_count",
                        "host_verifications","host_has_profile_pic","host_identity_verified")]


#write.csv(Listing, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing WorkInProgress.csv",
#          row.names = FALSE)



#------------------------------------------------------------------
# Separating host url table 
Host.url <- data.table(host.raw[,c("host_id","host_url","host_thumbnail_url","host_picture_url")])
Host.url <- Host.url[order(Host.url$host_id, decreasing = FALSE)]

Host.url$host_id <- gsub(" ", "", Host.url$host_id)
Host.url$host_url <- gsub(" ", "", Host.url$host_url)
Host.url$host_thumbnail_url <- gsub(" ", "", Host.url$host_thumbnail_url)
Host.url$host_picture_url <- gsub(" ", "", Host.url$host_picture_url)


#write.csv(Host.url, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Host URL.csv",
#          row.names = FALSE)



# removing Listing url from listing
host.raw <- host.raw[, -c("host_url","host_thumbnail_url","host_picture_url")]

#write.csv(host.raw, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Host Raw data.csv",
#          row.names = FALSE)




#------------------------------------------------------------------

# Separating Host Verification table 
Host.verify <- data.table(host.raw[,c("host_id","host_verifications",
                                      "host_has_profile_pic","host_identity_verified")])
Host.verify  <- Host.verify [order(Host.verify$host_id, decreasing = FALSE)]


Host.verify$host_has_profile_pic[Host.verify$host_has_profile_pic == "t"] <- 1
Host.verify$host_has_profile_pic[Host.verify$host_has_profile_pic == "f"] <- 0
Host.verify$host_identity_verified[Host.verify$host_identity_verified == "t"] <- 1
Host.verify$host_identity_verified[Host.verify$host_identity_verified == "f"] <- 0



# Separating the columns
Host.verify$email_verify <- ifelse(grepl("email", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$phone_verify <- ifelse(grepl("phone", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$facebook_verify <- ifelse(grepl("facebook", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$linkedin_verify <- ifelse(grepl("linkedin", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$reviews_verify <- ifelse(grepl("reviews", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$kba_verify <- ifelse(grepl("kba", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$google_verify <- ifelse(grepl("google", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$jumio_verify <- ifelse(grepl("jumio", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$amex_verify <- ifelse(grepl("amex", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$manual_offline_verify <- ifelse(grepl("manual_offline", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$manual_online_verify <- ifelse(grepl("manual_online", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$photographer_verify <- ifelse(grepl("photographer", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$sent_id_verify <- ifelse(grepl("sent_id", Host.verify$host_verifications, ignore.case = T), 1 , 0)
Host.verify$weibo_verify <- ifelse(grepl("weibo", Host.verify$host_verifications, ignore.case = T), 1 , 0)



Host.verify$host_verifications <- gsub(",", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'email'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'phone'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'facebook'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'linkedin'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'reviews'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'kba'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'google'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'jumio'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'amex'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'manual_offline'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'manual_online'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'photographer'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'sent_id'", "", Host.verify$host_verifications)
Host.verify$host_verifications <- gsub("'weibo'", "", Host.verify$host_verifications)



# dropping original host_verifications column
Host.verify <- Host.verify[, -c("host_verifications")]


#write.csv(Host.verify, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Host Verifications.csv",
#          row.names = FALSE)


# removing host verifications from host raw data
host.raw <- host.raw[, -c("host_verifications","host_has_profile_pic","host_identity_verified")]

#write.csv(host.raw, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Host Raw data.csv",
#          row.names = FALSE)





#------------------------------------------------------------------
# Separating Host Details table 

host.raw$host_location <- gsub("US", "United States", host.raw$host_location)

host.raw$host_is_superhost[host.raw$host_is_superhost == "t"] <- 1
host.raw$host_is_superhost[host.raw$host_is_superhost == "f"] <- 0

host.raw$host_acceptance_rate <- gsub("%", "", host.raw$host_acceptance_rate)
host.raw$host_response_rate <- gsub("%", "", host.raw$host_response_rate)

#Splitting host location column
host.raw <- host.raw %>% separate(host_location, sep = ",", into = c('c1','c2','c3','c4','c5','c6'))

# Building Country1 column
host.raw$c3[host.raw$c3 == "WA"] <- 'United States'
host.raw$c3[host.raw$c3 == " WA"] <- 'United States'
host.raw$c3[host.raw$c3 == " United States"] <- 'United States'
host.raw$c3[is.na(host.raw$c3)] <- ""
host.raw$c2[host.raw$c2 == " WA"] <- 'Washington'

host.raw$c6 <- ifelse(grepl('United States', host.raw$c1 , ignore.case = T), 'United States' , "")
host.raw$c1 <- gsub('United States', "", host.raw$c1)

host.raw$c5 <- ifelse(grepl('United States', host.raw$c2 , ignore.case = T), 'United States' , "")
host.raw$c2 <- gsub('United States', "", host.raw$c2)

host.raw$country1 <- paste0(host.raw$c3,host.raw$c5, host.raw$c6)


#write.csv(host.raw, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Host Details WIP.csv",
#          row.names = FALSE)

## OTHER CHANGES DONE MANUALLY




# Loading manually changed csv file of host details
host.raw1 <- read_csv("Host Details.csv")
host.raw1$host_since <- (format(as.Date(host.raw1$host_since, "%m/%d/%y"), "20%y-%m-%d"))
host.raw1$host_since <- as.POSIXct(host.raw1$host_since, "%Y-%m-%d")



#write.csv(host.raw1, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Host Details.csv",
#          row.names = FALSE)





#------------------------------------------------------------------
#---------------------- Listing Table ----------------------------
#------------------------------------------------------------------

#Listing Table
Listing <- data.table(Listing)


#------------------------------------------------------------------
# Separating Property type table 
Listing[, .N, by=.(property_type)]

Property_type <- data.frame(type_id=seq(1:16), 
                            property_type = c("Apartment","House","Cabin","Condominium","Camper/RV","Bungalow","Townhouse", 
                                              "Loft", "Boat","Bed & Breakfast","Other","Dorm","Treehouse","Yurt",
                                              "Chalet","Tent"))

Listing$property_type[Listing$property_type == "Apartment"] <- 1
Listing$property_type[Listing$property_type == "House"] <- 2
Listing$property_type[Listing$property_type == "Cabin"] <- 3
Listing$property_type[Listing$property_type == "Condominium"] <- 4
Listing$property_type[Listing$property_type == "Camper/RV"] <- 5
Listing$property_type[Listing$property_type == "Bungalow"] <- 6
Listing$property_type[Listing$property_type == "Townhouse"] <- 7
Listing$property_type[Listing$property_type == "Loft"] <- 8
Listing$property_type[Listing$property_type == "Boat"] <- 9
Listing$property_type[Listing$property_type == "Bed & Breakfast"] <- 10
Listing$property_type[Listing$property_type == "Other"] <- 11
Listing$property_type[Listing$property_type == "Dorm"] <- 12
Listing$property_type[Listing$property_type == "Treehouse"] <- 13
Listing$property_type[Listing$property_type == "Yurt"] <- 14
Listing$property_type[Listing$property_type == "Chalet"] <- 15
Listing$property_type[Listing$property_type == "Tent"] <- 16

colnames(Property_type) <- c("Property_type_id", "property_type")


#write.csv(Property_type, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Property Type.csv",
#         row.names = FALSE)



#------------------------------------------------------------------
# Separating Bed type table
Listing[, .N, by=.(bed_type)]

Bed_type <- data.frame(Bedtype_id=seq(1:5), 
                       Bed_type = c("Real Bed","Futon","Pull-out Sofa","Airbed","Couch"))

Listing$bed_type[Listing$bed_type == "Real Bed"] <- 1
Listing$bed_type[Listing$bed_type == "Futon"] <- 2
Listing$bed_type[Listing$bed_type == "Pull-out Sofa"] <- 3
Listing$bed_type[Listing$bed_type == "Airbed"] <- 4
Listing$bed_type[Listing$bed_type == "Couch"] <- 5


colnames(Bed_type) <- c("Bedtype_id", "Bed_Type")

#write.csv(Bed_type, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Bed type.csv",
#          row.names = FALSE)





#------------------------------------------------------------------
# Separating Room type table
Listing[, .N, by=.(room_type)]

Room_type <- data.frame(type_id=seq(1:3), 
                        room_type = c("Entire home/apt","Private room","Shared room"))

Listing$room_type[Listing$room_type == "Entire home/apt"] <- 1
Listing$room_type[Listing$room_type == "Private room"] <- 2
Listing$room_type[Listing$room_type == "Shared room"] <- 3


colnames(Room_type) <- c("Room_type_id", "room_type")

#write.csv(Room_type, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Room Type.csv",
#          row.names = FALSE)





#------------------------------------------------------------------
# Separating Listing price table 
Listing.Prices <- data.table(Listing[,c("id","price","weekly_price","monthly_price","extra_people","security_deposit","cleaning_fee")])
Listing.Prices <- Listing.Prices[order(Listing.Prices$id, decreasing = FALSE)]
colnames(Listing.Prices) <- c("listing_id","price_per_night","weekly_price","monthly_price","extra_people","security_deposit","cleaning_fee")

# removing $ sign and coverting into numeric
Listing.Prices$price_per_night = gsub("\\$", "", Listing.Prices$price_per_night)
Listing.Prices$price_per_night = as.numeric(gsub(",", "", Listing.Prices$price_per_night))

Listing.Prices$weekly_price = gsub("\\$", "", Listing.Prices$weekly_price)
Listing.Prices$weekly_price = as.numeric(gsub(",", "", Listing.Prices$weekly_price))

Listing.Prices$monthly_price = gsub("\\$", "", Listing.Prices$monthly_price)
Listing.Prices$monthly_price = as.numeric(gsub(",", "", Listing.Prices$monthly_price))

Listing.Prices$monthly_price = gsub("\\$", "", Listing.Prices$monthly_price)
Listing.Prices$extra_people = as.numeric(gsub(",", "", Listing.Prices$extra_people))

Listing.Prices$security_deposit = gsub("\\$", "", Listing.Prices$security_deposit)
Listing.Prices$security_deposit = as.numeric(gsub(",", "", Listing.Prices$security_deposit))

Listing.Prices$cleaning_fee = gsub("\\$", "", Listing.Prices$cleaning_fee)
Listing.Prices$cleaning_fee = as.numeric(gsub(",", "", Listing.Prices$cleaning_fee))


write.csv(Listing.Prices, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing Price details.csv",
          row.names = FALSE)


# removing  listing price columns from listing
Listing <- Listing[, -c("price","weekly_price","monthly_price","extra_people","security_deposit","cleaning_fee")]

#write.csv(Listing, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing WorkInProgress.csv",
#         row.names = FALSE)




#------------------------------------------------------------------
# Separating Listing review details table 
Listing.rev.details <- data.table(Listing[,c("id","number_of_reviews","first_review","last_review",
                                             "reviews_per_month","review_scores_rating",
                                             "review_scores_accuracy",
                                             "review_scores_cleanliness", "review_scores_checkin",
                                             "review_scores_communication","review_scores_location",
                                             "review_scores_value")])
Listing.rev.details <- Listing.rev.details[order(Listing.rev.details$id, decreasing = FALSE)]
colnames(Listing.rev.details) <- c("listing_id","number_of_reviews","first_review","last_review",
                                   "reviews_per_month","review_scores_rating",
                                   "review_scores_accuracy",
                                   "review_scores_cleanliness", "review_scores_checkin",
                                   "review_scores_communication","review_scores_location",
                                   "review_scores_value")

#write.csv(Listing.rev.details, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing Review details.csv",
#          row.names = FALSE)


# removing Listing review details from listing
Listing <- Listing[, -c("number_of_reviews","first_review","last_review",
                        "reviews_per_month","review_scores_rating",
                        "review_scores_accuracy",
                        "review_scores_cleanliness", "review_scores_checkin",
                        "review_scores_communication","review_scores_location",
                        "review_scores_value")]

#write.csv(Listing, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing WorkInProgress.csv",
#          row.names = FALSE)



# Loading csv file of listing review details to format date to load in sql
Listing.rev.details1 <- read_csv("Listing Review details.csv")
Listing.rev.details1$first_review <- (format(as.Date(Listing.rev.details1$first_review, "%m/%d/%y"), "20%y-%m-%d"))
Listing.rev.details1$first_review <- as.POSIXct(Listing.rev.details1$first_review, "%Y-%m-%d")
Listing.rev.details1$last_review <- (format(as.Date(Listing.rev.details1$last_review, "%m/%d/%y"), "20%y-%m-%d"))
Listing.rev.details1$last_review <- as.POSIXct(Listing.rev.details1$last_review, "%Y-%m-%d")


#write.csv(Listing.rev.details1, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing Review details.csv",
#          row.names = FALSE)




#------------------------------------------------------------------
# Separating Listing url table 
Listing.url <- data.table(Listing[,c("id","listing_url","thumbnail_url","medium_url","picture_url","xl_picture_url")])
Listing.url <- Listing.url[order(Listing.url$id, decreasing = FALSE)]
colnames(Listing.url) <- c("listing_id","listing_url","thumbnail_url","medium_url","picture_url","xl_picture_url")

#write.csv(Listing.url, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing URL.csv",
#          row.names = FALSE)


# removing Listing url from listing
Listing <- Listing[, -c("listing_url","thumbnail_url","medium_url","picture_url","xl_picture_url")]

#write.csv(Listing, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing WorkInProgress.csv",
#          row.names = FALSE)




#------------------------------------------------------------------
# Separating cancellation policy type table 
Listing[, .N, by=.(cancellation_policy)]

Cancellation_policy.type <- data.frame(Cancellation_type_id=seq(1:3), 
                                       cancellation_policy = c("strict","moderate","flexible"))

Listing$cancellation_policy[Listing$cancellation_policy == "strict"] <- 1
Listing$cancellation_policy[Listing$cancellation_policy == "moderate"] <- 2
Listing$cancellation_policy[Listing$cancellation_policy == "flexible"] <- 3

#write.csv(Cancellation_policy.type, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Cancellation type.csv",
#          row.names = FALSE)




#------------------------------------------------------------------
# Separating Listing Amenities table 

amenities <- data.table(Listing[,c("id","amenities")])
colnames(amenities) <- c("listing_id","amenities")


# Separating the columns
amenities$Cable_TV <- ifelse(grepl('"Cable TV"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Cable TV"', "", amenities$amenities)

amenities$TV <- ifelse(grepl('TV', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('TV', "", amenities$amenities)

amenities$Indoor_Fireplace <- ifelse(grepl('Indoor Fireplace', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Indoor Fireplace', "", amenities$amenities)

amenities$Wireless_Internet <- ifelse(grepl('"Wireless Internet"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Wireless Internet"', "", amenities$amenities)

amenities$Internet <- ifelse(grepl('Internet', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Internet', "", amenities$amenities)

amenities$Air_Conditioning <- ifelse(grepl('Air Conditioning', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Air Conditioning', "", amenities$amenities)

amenities$Heating <- ifelse(grepl('Heating', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Heating', "", amenities$amenities)

amenities$Kitchen <- ifelse(grepl('Kitchen', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Kitchen', "", amenities$amenities)

amenities$Family_KidFriendly <- ifelse(grepl('"Family/Kid Friendly"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Family/Kid Friendly"', "", amenities$amenities)

amenities$Gym <- ifelse(grepl('Gym', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Gym', "", amenities$amenities)

amenities$Free_premises_parking <- ifelse(grepl('"Free Parking on Premises"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Free Parking on Premises"', "", amenities$amenities)

amenities$Buzzer_WirelessIntercom <- ifelse(grepl('"Buzzer/Wireless Intercom"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Buzzer/Wireless Intercom"', "", amenities$amenities)

amenities$Smoke_Detector <- ifelse(grepl('"Smoke Detector"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Smoke Detector"', "", amenities$amenities)

amenities$Carbon_Monoxide_Detector <- ifelse(grepl('"Carbon Monoxide Detector"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Carbon Monoxide Detector"', "", amenities$amenities)

amenities$First_Aid_Kit <- ifelse(grepl('"First Aid Kit"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"First Aid Kit"', "", amenities$amenities)

amenities$Safety_Card <- ifelse(grepl('"Safety Card"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Safety Card"', "", amenities$amenities)

amenities$Fire_Extinguisher <- ifelse(grepl('"Fire Extinguisher"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Fire Extinguisher"', "", amenities$amenities)

amenities$Hot_Tub <- ifelse(grepl('"Hot Tub"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Hot Tub"', "", amenities$amenities)

amenities$Wheelchair_Accessible <- ifelse(grepl('"Wheelchair Accessible"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Wheelchair Accessible"', "", amenities$amenities)

amenities$Elevator_in_Building <- ifelse(grepl('"Elevator in Building"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Elevator in Building"', "", amenities$amenities)

amenities$Pets_Allowed <- ifelse(grepl('"Pets Allowed"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Pets Allowed"', "", amenities$amenities)

amenities$Pets_on_property <- ifelse(grepl('"Pets live on this property"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Pets live on this property"', "", amenities$amenities)

amenities$Dogs <- ifelse(grepl("Dog", amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub("Dog", "", amenities$amenities)

amenities$Cats <- ifelse(grepl('Cat', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Cat', "", amenities$amenities)

amenities$Other_Pets <- ifelse(grepl('Other pet', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Other pet', "", amenities$amenities)

amenities$Essentials <- ifelse(grepl('Essentials', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Essentials', "", amenities$amenities)

amenities$Shampoo <- ifelse(grepl('Shampoo', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Shampoo', "", amenities$amenities)

amenities$Hair_Dryer <- ifelse(grepl('"Hair Dryer"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Hair Dryer"', "", amenities$amenities)

amenities$Laptop_Friendly_Workspace <- ifelse(grepl('"Laptop Friendly Workspace"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"Laptop Friendly Workspace"', "", amenities$amenities)

amenities$Breakfast <- ifelse(grepl('Breakfast', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Breakfast', "", amenities$amenities)

amenities$Hangers <- ifelse(grepl('Hangers', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Hangers', "", amenities$amenities)

amenities$Iron <- ifelse(grepl('Iron', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Iron', "", amenities$amenities)

amenities$Washer <- ifelse(grepl('Washer', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Washer', "", amenities$amenities)

amenities$Dryer <- ifelse(grepl('Dryer', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Dryer', "", amenities$amenities)

amenities$All_day_Check_in <- ifelse(grepl('"24-Hour Check-in"', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('"24-Hour Check-in"', "", amenities$amenities)

amenities$Smoking_Allowed <- ifelse(grepl('Smoking Allowed', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Smoking Allowed', "", amenities$amenities)

amenities$Suitable_for_Event <- ifelse(grepl('Suitable for Event', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Suitable for Event', "", amenities$amenities)

amenities$Lock_on_Bedroom_Door <- ifelse(grepl('Lock on Bedroom Door', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Lock on Bedroom Door', "", amenities$amenities)

amenities$Pool <- ifelse(grepl('Pool', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Pool', "", amenities$amenities)

amenities$Doorman <- ifelse(grepl('Doorman', amenities$amenities, ignore.case = T), 1 , 0)
amenities$amenities <- gsub('Doorman', "", amenities$amenities)


# removing amenities from amenities
amenities <- amenities[, -c("amenities")]

#write.csv(amenities, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Amenities.csv",
#          row.names = FALSE)



# removing amenities columns from listing
Listing <- Listing[, -c("amenities")]

#write.csv(Listing, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing WorkInProgress.csv",
#          row.names = FALSE)






#------------------------------------------------------------------
# Separating Listing type table 

Listing[, .N, by=.(smart_location)]


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


#Rearranging columns
summary(Listing)
Listing_Final <- Listing[ ,c("id","scrape_id","last_scraped","name","summary","space","description",
                              "notes","host_id", "street_address","city","state","zipcode",
                              "neighborhood_overview","neighbourhood","neighbourhood_cleansed",
                              "neighbourhood_group_cleansed","market", "smart_location",
                              "country_code","country","jurisdiction_names","latitude","longitude",
                              "is_location_exact","property_type", "room_type","accommodates",
                              "bathrooms","bedrooms","beds","bed_type","experiences_offered", 
                              "transit","square_feet","guests_included", "minimum_nights",
                              "maximum_nights","instant_bookable","cancellation_policy",
                              "calendar_updated","has_availability","availability_30", 
                              "availability_60", "availability_90", "availability_365",
                              "calendar_last_scraped","requires_license","license")]

setNames(Listing_Final, "id", "listing_id")


#write.csv(Listing_Final, file =  "~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listings.csv",
#          row.names = FALSE)









###------------------------------------------------------------------------------
###------------- MY SQL ---------------------------------------------------------
###------------------------------------------------------------------------------


if(!"RMariaDB" %in% (.packages())){require(RMariaDB)}
library(RMariaDB)

# Loading database with SQL password
stuffDB <- dbConnect(MariaDB(), user = "root", password = "$Webco123", dbname = "AirbnbSeattle", host = "localhost")


#List tables in Ainbnb SeattleDB
dbListTables(stuffDB)



#------------------------------------------------------------------
# Loading Data in Amenities Table of DB


col_names <- colnames(amenities)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/amenities.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

getwd()

# To check number of characters in code chuncks of each table
#lapply(dataChunk, function(x) max(nchar(x)))


#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "amenities", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Bed Type Table of DB


col_names <- colnames(Bed_type)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Bed type.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Bed type", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Property Type Table of DB


col_names <- colnames(Property_type)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Property type.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Property type", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Room Type Table of DB


col_names <- colnames(Room_type)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Room type.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Room type", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Cancellation Policy Type Table of DB


col_names <- colnames(Cancellation_policy.type)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Cancellation type.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Cancellation Type", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Host URL Table of DB


col_names <- colnames(Host.url)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Host URL.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Host URL", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Host Verifications Table of DB


col_names <- colnames(Host.verify)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Host Verifications.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Host Verifications", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Host Details Table of DB


col_names <- colnames(host.raw1)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Host Details.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Host Details", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Listing Details Table of DB


#Create column name vector
col_names <- c("listing_id","scrape_id","last_scraped","name","summary","space","description",
               "notes","host_id", "street_address","city","state","zipcode",
               "neighborhood_overview","neighbourhood","neighbourhood_cleansed",
               "neighbourhood_group_cleansed","market", "smart_location",
               "country_code","country","jurisdiction_names","latitude","longitude",
               "is_location_exact","property_type", "room_type","accommodates",
               "bathrooms","bedrooms","beds","bed_type","experiences_offered", 
               "transit","square_feet","guests_included", "minimum_nights",
               "maximum_nights","instant_bookable","cancellation_policy",
               "calendar_updated","has_availability","availability_30", 
               "availability_60", "availability_90", "availability_365",
               "calendar_last_scraped","requires_license","license")

#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listings.csv",open="r")   

#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Listing Details", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Listing Price Table of DB


col_names <- colnames(Listing.Prices)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing Price Details.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Listing Price Details", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Listing Review Details Table of DB


col_names <- colnames(Listing.rev.details1)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing Review details.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Listing Review Details", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Listing URL Table of DB


col_names <- colnames(Listing.url)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing URL.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Listing URL", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Reviewer Details Table of DB


col_names <- colnames(reviewer_datails)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/reviewer details.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Reviewer Details", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Reviews Table of DB


col_names <- colnames(review.final)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/reviews.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Reviews", append = TRUE)




#------------------------------------------------------------------
# Loading Data in Listing Availability Table of DB


col_names <- colnames(calendar)
#Open the file connection
con <- file(description="~/OneDrive - The University of Texas at Dallas/BUAN 6320/BUAN 6320 Project/Seattle Airbnb Open Data/Cleaned data/Listing Availability.csv",open="r")   
#Read the data chunkWise
dataChunk <- read.table(con, header=T, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Write & append the tables chunkWise
dbWriteTable(stuffDB, value = dataChunk, row.names = FALSE, name = "Listing Availability", append = TRUE)






#Close the open file connection
close(con)



