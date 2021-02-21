test_geocode <- geocode(addressLine='2135 Bennett Road',locality='Kelowna',adminDistrict='BC',postalCode='V1V 2C2',countryRegion='CA',maxResults=1,includeNeighborhood=NULL)
test_no_postal_code <- geocode(addressLine='244 Lake Mead Rd',locality='Calgary',adminDistrict='AB',postalCode='',countryRegion='CA',maxResults=1,includeNeighborhood=NULL)
test_invalid_country_code <- geocode(addressLine='405 Spray Ave',locality='Banff',adminDistrict='AB',postalCode='T1L 1J4',countryRegion='Canada',maxResults=1,includeNeighborhood=NULL)

context("test the geocode function with reasonable inputs with different addresses and some missing/incorrect parameters that might be expected")

library(bingmapr)

test_that("is latitude correct", {
  expect_equal(round(test_geocode$chords$latitude,digits=3), 49.960 )
})

test_that("is longitude correct", {
  expect_equal(round(test_geocode$chords$longitude,digits=3), -119.461 )
})

test_that("Check status code is 200", {
  expect_equal(test_geocode$response$status_code, 200 )
})

# Setup for the NO API KEY test
temp_api_key <- Sys.getenv('api_key')
Sys.unsetenv('api_key')

test_that("error handling", {
  expect_error(geocode(),regexp = 'Please set your Bing Maps API key as an enviornment variable with name api_key')
})

# Teardown for the NO API KEY test
Sys.setenv(api_key=temp_api_key)

test_that("function inputs merge properly", {
  expect_equal(test_geocode$content$address$formattedAddress, '2135 Bennett Rd, Kelowna, BC V1V 2C2, Canada')
})






test_that("is latitude correct", {
  expect_equal(round(test_no_postal_code$chords$latitude,digits=3), 50.938 )
})

test_that("is longitude correct", {
  expect_equal(round(test_no_postal_code$chords$longitude,digits=3), -114.061 )
})

test_that("Check status code is 200", {
  expect_equal(test_no_postal_code$response$status_code, 200 )
})

# Setup for the NO API KEY test
temp_api_key <- Sys.getenv('api_key')
Sys.unsetenv('api_key')

test_that("error handling", {
  expect_error(geocode(),regexp = 'Please set your Bing Maps API key as an enviornment variable with name api_key')
})

# Teardown for the NO API KEY test
Sys.setenv(api_key=temp_api_key)

test_that("function inputs merge properly", {
  expect_equal(test_no_postal_code$content$address$formattedAddress, '244 Lake Mead Rd SE, Calgary, AB T2J 4A5, Canada')
})







test_that("is latitude correct", {
  expect_equal(round(test_invalid_country_code$chords$latitude,digits=3), 51.164)
})

test_that("is longitude correct", {
  expect_equal(round(test_invalid_country_code$chords$longitude,digits=3), -115.561 )
})

test_that("Check status code is 200", {
  expect_equal(test_invalid_country_code$response$status_code, 200 )
})

# Setup for the NO API KEY test
temp_api_key <- Sys.getenv('api_key')
Sys.unsetenv('api_key')

test_that("error handling", {
  expect_error(geocode(),regexp = 'Please set your Bing Maps API key as an enviornment variable with name api_key')
})

# Teardown for the NO API KEY test
Sys.setenv(api_key=temp_api_key)

test_that("function inputs merge properly", {
  expect_equal(test_invalid_country_code$content$address$formattedAddress, '405 Spray Ave, Banff, AB T1L, Canada')
})
