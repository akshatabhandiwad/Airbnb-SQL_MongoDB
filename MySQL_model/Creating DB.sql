-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema AirbnbSeattle
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema AirbnbSeattle
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `AirbnbSeattle` DEFAULT CHARACTER SET utf8 ;
USE `AirbnbSeattle` ;

-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Amenities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Amenities` (
  `Listing_id` INT NOT NULL,
  `Cable_TV` INT NULL DEFAULT NULL,
  `TV` INT NULL DEFAULT NULL,
  `Indoor_Fireplace` INT NULL DEFAULT NULL,
  `Wireless_Internet` INT NULL DEFAULT NULL,
  `Internet` INT NULL DEFAULT NULL,
  `Air_Conditioning` INT NULL DEFAULT NULL,
  `Heating` INT NULL DEFAULT NULL,
  `Kitchen` INT NULL DEFAULT NULL,
  `Family_KidFriendly` INT NULL DEFAULT NULL,
  `Gym` INT NULL DEFAULT NULL,
  `Free_premises_parking` INT NULL DEFAULT NULL,
  `Buzzer_WirelessIntercom` INT NULL DEFAULT NULL,
  `Smoke_Detector` INT NULL DEFAULT NULL,
  `Carbon_Monoxide_Detector` INT NULL DEFAULT NULL,
  `First_Aid_Kit` INT NULL DEFAULT NULL,
  `Safety_Card` INT NULL DEFAULT NULL,
  `Fire_Extinguisher` INT NULL DEFAULT NULL,
  `Hot_Tub` INT NULL DEFAULT NULL,
  `Wheelchair_Accessible` INT NULL DEFAULT NULL,
  `Elevator_in_Building` INT NULL DEFAULT NULL,
  `Pets_Allowed` INT NULL DEFAULT NULL,
  `Pets_on_property` INT NULL DEFAULT NULL,
  `Dogs` INT NULL DEFAULT NULL,
  `Cats` INT NULL DEFAULT NULL,
  `Other_Pets` INT NULL DEFAULT NULL,
  `Essentials` INT NULL DEFAULT NULL,
  `Shampoo` INT NULL DEFAULT NULL,
  `Hair_Dryer` INT NULL DEFAULT NULL,
  `Laptop_Friendly_Workspace` INT NULL DEFAULT NULL,
  `Breakfast` INT NULL DEFAULT NULL,
  `Hangers` INT NULL DEFAULT NULL,
  `Iron` INT NULL DEFAULT NULL,
  `Washer` INT NULL DEFAULT NULL,
  `Dryer` INT NULL DEFAULT NULL,
  `All_day_Check_in` INT NULL DEFAULT NULL,
  `Smoking_Allowed` INT NULL DEFAULT NULL,
  `Suitable_for_Event` INT NULL DEFAULT NULL,
  `Lock_on_Bedroom_Door` INT NULL DEFAULT NULL,
  `Pool` INT NULL DEFAULT NULL,
  `Doorman` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Listing_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `Listing_id_UNIQUE` ON `AirbnbSeattle`.`Amenities` (`Listing_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Bed Type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Bed Type` (
  `Bedtype_id` INT NOT NULL AUTO_INCREMENT,
  `Bed_Type` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Bedtype_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `Bedtype_id_UNIQUE` ON `AirbnbSeattle`.`Bed Type` (`Bedtype_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Cancellation Type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Cancellation Type` (
  `Cancellation_type_id` INT NOT NULL AUTO_INCREMENT,
  `cancellation_policy` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Cancellation_type_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `Cancellation_type_id_UNIQUE` ON `AirbnbSeattle`.`Cancellation Type` (`Cancellation_type_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Host URL`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Host URL` (
  `host_id` INT NOT NULL,
  `host_url` VARCHAR(2000) NULL DEFAULT NULL,
  `host_thumbnail_url` VARCHAR(2000) NULL DEFAULT NULL,
  `host_picture_url` VARCHAR(2000) NULL DEFAULT NULL,
  PRIMARY KEY (`host_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `host_id_UNIQUE` ON `AirbnbSeattle`.`Host URL` (`host_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Host Verifications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Host Verifications` (
  `host_id` INT NOT NULL,
  `host_has_profile_pic` INT NULL DEFAULT NULL,
  `host_identity_verified` INT NULL DEFAULT NULL,
  `email_verify` INT NULL DEFAULT NULL,
  `phone_verify` INT NULL DEFAULT NULL,
  `facebook_verify` INT NULL DEFAULT NULL,
  `linkedin_verify` INT NULL DEFAULT NULL,
  `reviews_verify` INT NULL DEFAULT NULL,
  `kba_verify` INT NULL DEFAULT NULL,
  `google_verify` INT NULL DEFAULT NULL,
  `jumio_verify` INT NULL DEFAULT NULL,
  `amex_verify` INT NULL DEFAULT NULL,
  `manual_offline_verify` INT NULL DEFAULT NULL,
  `manual_online_verify` INT NULL DEFAULT NULL,
  `photographer_verify` INT NULL DEFAULT NULL,
  `sent_id_verify` INT NULL DEFAULT NULL,
  `weibo_verify` INT NULL DEFAULT NULL,
  PRIMARY KEY (`host_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `host_id_UNIQUE` ON `AirbnbSeattle`.`Host Verifications` (`host_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Host Details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Host Details` (
  `host_id` INT NOT NULL,
  `host_name` VARCHAR(45) NULL DEFAULT NULL,
  `host_since` DATE NULL DEFAULT NULL,
  `City1` VARCHAR(500) NULL DEFAULT NULL,
  `State1` VARCHAR(45) NULL DEFAULT NULL,
  `Country1` VARCHAR(45) NULL DEFAULT NULL,
  `City2` VARCHAR(45) NULL DEFAULT NULL,
  `State2` VARCHAR(45) NULL DEFAULT NULL,
  `Country2` VARCHAR(45) NULL DEFAULT NULL,
  `City3` VARCHAR(45) NULL DEFAULT NULL,
  `State3` VARCHAR(45) NULL DEFAULT NULL,
  `Country3` VARCHAR(45) NULL DEFAULT NULL,
  `host_about` VARCHAR(4500) NULL DEFAULT NULL,
  `host_response_time` VARCHAR(45) NULL DEFAULT NULL,
  `host_response_rate` DECIMAL(6,2) NULL DEFAULT NULL,
  `host_acceptance_rate` DECIMAL(6,2) NULL DEFAULT NULL,
  `host_is_superhost` INT NULL DEFAULT NULL,
  `host_neighbourhood` VARCHAR(45) NULL DEFAULT NULL,
  `host_listings_count` INT NULL DEFAULT NULL,
  `host_total_listings_count` INT NULL DEFAULT NULL,
  PRIMARY KEY (`host_id`),
  CONSTRAINT `fk_Host Details_Host URL1`
    FOREIGN KEY (`host_id`)
    REFERENCES `AirbnbSeattle`.`Host URL` (`host_id`),
  CONSTRAINT `fk_Host Details_Host Verifications1`
    FOREIGN KEY (`host_id`)
    REFERENCES `AirbnbSeattle`.`Host Verifications` (`host_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `host_id_UNIQUE` ON `AirbnbSeattle`.`Host Details` (`host_id` ASC) VISIBLE;

CREATE INDEX `fk_Host Details_Host Verifications1_idx` ON `AirbnbSeattle`.`Host Details` (`host_id` ASC) VISIBLE;

CREATE INDEX `fk_Host Details_Host URL1_idx` ON `AirbnbSeattle`.`Host Details` (`host_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Property Type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Property Type` (
  `Property_type_id` INT NOT NULL,
  `Property_type` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Property_type_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `Property_type_id_UNIQUE` ON `AirbnbSeattle`.`Property Type` (`Property_type_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Room Type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Room Type` (
  `Room_type_id` INT NOT NULL AUTO_INCREMENT,
  `room_type` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Room_type_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `Room_type_id_UNIQUE` ON `AirbnbSeattle`.`Room Type` (`Room_type_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Listing Details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Listing Details` (
  `listing_id` INT NOT NULL,
  `scrape_id` BIGINT NULL DEFAULT NULL,
  `last_scraped` DATETIME NULL DEFAULT NULL,
  `name` VARCHAR(50) NULL DEFAULT NULL,
  `summary` VARCHAR(1500) NULL DEFAULT NULL,
  `space` VARCHAR(1500) NULL DEFAULT NULL,
  `description` VARCHAR(2000) NULL DEFAULT NULL,
  `experiences_offered` VARCHAR(1000) NULL DEFAULT NULL,
  `neighborhood_overview` VARCHAR(1500) NULL DEFAULT NULL,
  `notes` VARCHAR(1500) NULL DEFAULT NULL,
  `transit` VARCHAR(1500) NULL DEFAULT NULL,
  `host_id` INT NOT NULL,
  `neighbourhood` VARCHAR(45) NULL DEFAULT NULL,
  `neighbourhood_cleansed` VARCHAR(45) NULL DEFAULT NULL,
  `neighbourhood_group_cleansed` VARCHAR(45) NULL DEFAULT NULL,
  `street_address` VARCHAR(70) NULL DEFAULT NULL,
  `city` VARCHAR(45) NULL DEFAULT NULL,
  `state` VARCHAR(45) NULL DEFAULT NULL,
  `zipcode` INT NULL DEFAULT NULL,
  `market` VARCHAR(45) NULL DEFAULT NULL,
  `smart_location` VARCHAR(45) NULL DEFAULT NULL,
  `country_code` VARCHAR(45) NULL DEFAULT NULL,
  `country` VARCHAR(45) NULL DEFAULT NULL,
  `latitude` DECIMAL(12,6) NULL DEFAULT NULL,
  `longitude` DECIMAL(12,6) NULL DEFAULT NULL,
  `is_location_exact` INT NULL DEFAULT NULL,
  `property_type` INT NOT NULL,
  `room_type` INT NOT NULL,
  `accommodates` INT NULL DEFAULT NULL,
  `bathrooms` DECIMAL(3,2) NULL DEFAULT NULL,
  `bedrooms` INT NULL DEFAULT NULL,
  `beds` INT NULL DEFAULT NULL,
  `bed_type` INT NOT NULL,
  `square_feet` DECIMAL(6,2) NULL DEFAULT NULL,
  `guests_included` INT NULL DEFAULT NULL,
  `minimum_nights` INT NULL DEFAULT NULL,
  `maximum_nights` INT NULL DEFAULT NULL,
  `calendar_updated` VARCHAR(45) NULL DEFAULT NULL,
  `has_availability` INT NULL DEFAULT NULL,
  `availability_30` INT NULL DEFAULT NULL,
  `availability_60` INT NULL DEFAULT NULL,
  `availability_90` INT NULL DEFAULT NULL,
  `availability_365` INT NULL DEFAULT NULL,
  `calendar_last_scraped` DATETIME NULL DEFAULT NULL,
  `requires_license` INT NULL DEFAULT NULL,
  `license` VARCHAR(45) NULL DEFAULT NULL,
  `jurisdiction_names` VARCHAR(45) NULL DEFAULT NULL,
  `instant_bookable` INT NULL DEFAULT NULL,
  `cancellation_policy` INT NOT NULL,
  `require_guest_profile_picture` INT NULL DEFAULT NULL,
  `require_guest_phone_verification` INT NULL DEFAULT NULL,
  `calculated_host_listings_count` INT NULL DEFAULT NULL,
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_Listing Details_Amenities`
    FOREIGN KEY (`listing_id`)
    REFERENCES `AirbnbSeattle`.`Amenities` (`Listing_id`),
  CONSTRAINT `fk_Listing Details_Bed Type1`
    FOREIGN KEY (`bed_type`)
    REFERENCES `AirbnbSeattle`.`Bed Type` (`Bedtype_id`),
  CONSTRAINT `fk_Listing Details_Cancellation Type1`
    FOREIGN KEY (`cancellation_policy`)
    REFERENCES `AirbnbSeattle`.`Cancellation Type` (`Cancellation_type_id`),
  CONSTRAINT `fk_Listing Details_Host Details1`
    FOREIGN KEY (`host_id`)
    REFERENCES `AirbnbSeattle`.`Host Details` (`host_id`),
  CONSTRAINT `fk_Listing Details_Property Type1`
    FOREIGN KEY (`property_type`)
    REFERENCES `AirbnbSeattle`.`Property Type` (`Property_type_id`),
  CONSTRAINT `fk_Listing Details_Room Type1`
    FOREIGN KEY (`room_type`)
    REFERENCES `AirbnbSeattle`.`Room Type` (`Room_type_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_UNIQUE` ON `AirbnbSeattle`.`Listing Details` (`listing_id` ASC) VISIBLE;

CREATE INDEX `fk_Listing Details_Amenities_idx` ON `AirbnbSeattle`.`Listing Details` (`listing_id` ASC) VISIBLE;

CREATE INDEX `fk_Listing Details_Property Type1_idx` ON `AirbnbSeattle`.`Listing Details` (`property_type` ASC) VISIBLE;

CREATE INDEX `fk_Listing Details_Bed Type1_idx` ON `AirbnbSeattle`.`Listing Details` (`bed_type` ASC) VISIBLE;

CREATE INDEX `fk_Listing Details_Cancellation Type1_idx` ON `AirbnbSeattle`.`Listing Details` (`cancellation_policy` ASC) VISIBLE;

CREATE INDEX `fk_Listing Details_Room Type1_idx` ON `AirbnbSeattle`.`Listing Details` (`room_type` ASC) VISIBLE;

CREATE INDEX `fk_Listing Details_Host Details1_idx` ON `AirbnbSeattle`.`Listing Details` (`host_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Listing Availability`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Listing Availability` (
  `calendar_id` INT NOT NULL,
  `listing_id` INT NOT NULL,
  `date` DATE NULL DEFAULT NULL,
  `available` INT NULL DEFAULT NULL,
  `price` INT NULL DEFAULT NULL,
  PRIMARY KEY (`calendar_id`),
  CONSTRAINT `listing_id`
    FOREIGN KEY (`listing_id`)
    REFERENCES `AirbnbSeattle`.`Listing Details` (`listing_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `listing_id_UNIQUE` ON `AirbnbSeattle`.`Listing Availability` (`calendar_id` ASC) VISIBLE;

CREATE INDEX `listing_id_idx` ON `AirbnbSeattle`.`Listing Availability` (`listing_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Listing Price Details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Listing Price Details` (
  `listing_id` INT NOT NULL,
  `price_per_night` INT NULL DEFAULT NULL,
  `weekly_price` INT NULL DEFAULT NULL,
  `monthly_price` INT NULL DEFAULT NULL,
  `extra_people` INT NULL DEFAULT NULL,
  `security_deposit` INT NULL DEFAULT NULL,
  `cleaning_fee` INT NULL DEFAULT NULL,
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_Listing Price Details_Listing Details1`
    FOREIGN KEY (`listing_id`)
    REFERENCES `AirbnbSeattle`.`Listing Details` (`listing_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `listing_id_UNIQUE` ON `AirbnbSeattle`.`Listing Price Details` (`listing_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Listing Review Details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Listing Review Details` (
  `listing_id` INT NOT NULL,
  `number_of_reviews` INT NULL DEFAULT NULL,
  `first_review` DATE NULL DEFAULT NULL,
  `last_review` DATE NULL DEFAULT NULL,
  `reviews_per_month` FLOAT NULL DEFAULT NULL,
  `review_scores_rating` INT NULL DEFAULT NULL,
  `review_scores_accuracy` INT NULL DEFAULT NULL,
  `review_scores_cleanliness` INT NULL DEFAULT NULL,
  `review_scores_checkin` INT NULL DEFAULT NULL,
  `review_scores_communication` INT NULL DEFAULT NULL,
  `review_scores_location` INT NULL DEFAULT NULL,
  `review_scores_value` INT NULL DEFAULT NULL,
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_Listing Review Details_Listing Details1`
    FOREIGN KEY (`listing_id`)
    REFERENCES `AirbnbSeattle`.`Listing Details` (`listing_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `listing_id_UNIQUE` ON `AirbnbSeattle`.`Listing Review Details` (`listing_id` ASC) VISIBLE;

CREATE INDEX `fk_Listing Review Details_Listing Details1_idx` ON `AirbnbSeattle`.`Listing Review Details` (`listing_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Listing URL`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Listing URL` (
  `listing_id` INT NOT NULL,
  `listing_url` VARCHAR(300) NULL DEFAULT NULL,
  `medium_url` VARCHAR(300) NULL DEFAULT NULL,
  `picture_url` VARCHAR(300) NULL DEFAULT NULL,
  `xl_picture_url` VARCHAR(300) NULL DEFAULT NULL,
  `thumbnail_url` VARCHAR(300) NULL DEFAULT NULL,
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_Listing URL_Listing Details1`
    FOREIGN KEY (`listing_id`)
    REFERENCES `AirbnbSeattle`.`Listing Details` (`listing_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `listing_id_UNIQUE` ON `AirbnbSeattle`.`Listing URL` (`listing_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Reviewer Details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Reviewer Details` (
  `reviewer_id` INT NOT NULL,
  `reviewer_name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`reviewer_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `reviewer_id_UNIQUE` ON `AirbnbSeattle`.`Reviewer Details` (`reviewer_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AirbnbSeattle`.`Reviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirbnbSeattle`.`Reviews` (
  `review_id` INT NOT NULL,
  `listing_id` INT NOT NULL,
  `Review_date` DATETIME NULL DEFAULT NULL,
  `reviewer_id` INT NOT NULL,
  `comments` VARCHAR(3500) NULL DEFAULT NULL,
  PRIMARY KEY (`review_id`, `listing_id`, `reviewer_id`),
  CONSTRAINT `fk_Reviews_Listing Details1`
    FOREIGN KEY (`listing_id`)
    REFERENCES `AirbnbSeattle`.`Listing Details` (`listing_id`),
  CONSTRAINT `fk_Reviews_Reviewer Details1`
    FOREIGN KEY (`reviewer_id`)
    REFERENCES `AirbnbSeattle`.`Reviewer Details` (`reviewer_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `review_id_UNIQUE` ON `AirbnbSeattle`.`Reviews` (`review_id` ASC) VISIBLE;

CREATE INDEX `fk_Reviews_Reviewer Details1_idx` ON `AirbnbSeattle`.`Reviews` (`reviewer_id` ASC) VISIBLE;

CREATE INDEX `fk_Reviews_Listing Details1_idx` ON `AirbnbSeattle`.`Reviews` (`listing_id` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
