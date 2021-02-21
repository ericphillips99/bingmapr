# Testing the location_recognition function

context("Location Recognition wrapper function for Bing Maps API")
library(bingmapr)

kelowna_address <- location_recognition(lat=49.8682,long=-119.4889)
bay_area_address <- location_recognition(lat=37.7128,long=-122.0293)

test_that("location_recognition gives correct key-info for first business", {
  expect_equal(kelowna_address$business[[1]][[1]]$formattedAddress,
               "665B Patterson Ave, Kelowna, BC V1Y 5C7, CA")
  expect_equal(kelowna_address$business[[1]][[2]]$entityName,"Perception Marketing")
  expect_equal(kelowna_address$business[[1]][[2]]$type, "Business-to-Business")
  expect_equal(bay_area_address$business[[1]][[1]]$formattedAddress,
               "20222 Glenwood Dr, Castro Valley, CA 94552, US")
  expect_equal(bay_area_address$business[[1]][[2]]$entityName,"Hammond Inspection LLC")
  expect_equal(bay_area_address$business[[1]][[2]]$type, "UnKnown")
})

test_that("location_recognition gives correct key-info for second business", {
  expect_equal(kelowna_address$business[[2]][[1]]$formattedAddress,
               "674 Patterson Ave, Kelowna, BC V1Y 5C6, CA")
  expect_equal(kelowna_address$business[[2]][[2]]$entityName,"Mandy & Me Trail Riding")
  expect_equal(kelowna_address$business[[2]][[2]]$type, NULL)
  expect_equal(bay_area_address$business[[2]][[1]]$formattedAddress,
               "20001 Carson Ln, Castro Valley, CA 94552, US")
  expect_equal(bay_area_address$business[[2]][[2]]$entityName,"Jensen Ranch Elementary School")
  expect_equal(bay_area_address$business[[2]][[2]]$type, "Elementary Schools")
})

test_that("location_recognition error handling and status code", {
  expect_error(location_recognition(), regexp = 'argument "lat" is missing, with no default')
  expect_error(location_recognition(lat=49.8682),regexp = 'argument "long" is missing, with no default')
  expect_error(location_recognition(lat=49.8682,long=-1119.4889),
               regexp = 'Error type: Client error, Reason: Bad Request')
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
