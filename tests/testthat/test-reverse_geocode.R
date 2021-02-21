# Testing the reverse_geocode function

kelowna_address <- reverse_geocode(lat=49.8682,long=-119.4889)
bay_area_address <- reverse_geocode(lat=37.7128,long=-122.0293)

test_that("reverse_geocode gives CANADA address components", {
  expect_equal(kelowna_address$content$address$addressLine, "674 Patterson Ave")
  expect_equal(kelowna_address$content$address$locality, "Kelowna")
  expect_equal(kelowna_address$content$address$adminDistrict, "BC")
  expect_equal(kelowna_address$content$address$countryRegion, "Canada")
  expect_equal(kelowna_address$content$address$postalCode, "V1Y 5C7")
})

test_that("reverse_geocode gives USA address components", {
  expect_equal(bay_area_address$content$address$addressLine, "20222 Glenwood Dr")
  expect_equal(bay_area_address$content$address$locality, "Castro Valley")
  expect_equal(bay_area_address$content$address$adminDistrict, "CA")
  expect_equal(bay_area_address$content$address$countryRegion, "United States")
  expect_equal(bay_area_address$content$address$postalCode, "94552")
})

test_that("reverse_geocode gives FULL addresses", {
  expect_equal(kelowna_address$address, "674 Patterson Ave, Kelowna, BC V1Y 5C7, Canada")
  expect_equal(bay_area_address$address, "20222 Glenwood Dr, Castro Valley, CA 94552")
})

test_that("reverse_geocode error handling and status code", {
  expect_error(reverse_geocode(), regexp = 'argument "lat" is missing, with no default')
  expect_error(reverse_geocode(lat=49.8682),regexp = 'argument "long" is missing, with no default')
  expect_error(reverse_geocode(lat=49.8682,long=-1119.4889),
               regexp = 'Error type: Client error, Reason: Bad Request')
})

# Setup for the NO API KEY test
temp_api_key <- Sys.getenv('api_key')
Sys.unsetenv('api_key')
# Run the NO API KEY test
test_that("reverse_geocode no API KEY set", {
  expect_error(reverse_geocode(lat=37.7128,long=-122.0293),
               regexp = 'Please set your Bing Maps API key as an enviornment variable')
})
# Teardown for the NO API KEY test
Sys.setenv(api_key=temp_api_key)