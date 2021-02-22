# Testing the geocode_csv function

context("Location Geocode CSV function for Bing Maps API")
library(bingmapr)
Sys.setenv(api_key="AiKOkTc7X6nt2Zlljde8g2AW3zDup7GaDz2LU-kxFzGh-3TnjOsawuZ025p29jUS")

test_that("csv throws error when column names does not exist", {
  expect_error(geocode_csv("sf_starbucks_sample.csv",addressLine_col="street_addres",
                           locality_col="city",adminDistrict_col="state",postalCode_col="zipcode",
                           countryRegion_col="country"),
               regexp = 'Perhaps you have misttyped the column name?')
  expect_error(geocode_csv("sf_starbucks_sample.csv",addressLine_col="street_address",
                           locality_col="city",adminDistrict_col="stat",postalCode_col="zipcode",
                           countryRegion_col="country"),
               regexp = 'Perhaps you have misttyped the column name?')
})

geocode_csv("sf_starbucks_sample.csv",addressLine_col="street_address",
            locality_col="city",adminDistrict_col="state",postalCode_col="zipcode",
            countryRegion_col="country")

test_csv_tib <- read_csv("sf_starbucks_sample.csv")
ouput_csv_tib <- read_csv("sf_starbucks_sample_geocoded.csv")

test_that("latitude and longitude of output CSV match input Test CSV", {
  expect_equal(round(test_csv_tib$long, 2), round(ouput_csv_tib$longitude, 2))
  expect_equal(round(test_csv_tib$lat, 2), round(ouput_csv_tib$latitude, 2))
})


# Setup for the NO API KEY test
temp_api_key <- Sys.getenv('api_key')
Sys.unsetenv('api_key')
# Run the NO API KEY test
test_that("location_recognition no API KEY set", {
  expect_error(location_recognition(lat=37.7128,long=-122.0293),
               regexp = 'Please set your Bing Maps API key as an enviornment variable')
})
# Teardown for the NO API KEY test
Sys.setenv(api_key=temp_api_key)
