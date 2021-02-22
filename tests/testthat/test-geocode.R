test_geocode <- geocode(addressLine='2135 Bennett Road',locality='Kelowna',adminDistrict='BC',postalCode='V1V 2C2',countryRegion='CA',includeNeighborhood=NULL)
test_no_postal_code <- geocode(addressLine='244 Lake Mead Rd',locality='Calgary',adminDistrict='AB',postalCode='',countryRegion='CA',includeNeighborhood=NULL)
test_invalid_country_code <- geocode(addressLine='405 Spray Ave',locality='Banff',adminDistrict='AB',postalCode='T1L 1J4',countryRegion='Canada',includeNeighborhood=NULL)

context("test the geocode function with reasonable inputs with different addresses and some missing/incorrect parameters that might be expected")

library(bingmapr)
Sys.setenv(api_key="AiKOkTc7X6nt2Zlljde8g2AW3zDup7GaDz2LU-kxFzGh-3TnjOsawuZ025p29jUS")

test_that("is latitude correct", {
  expect_equal(round(test_geocode$chords$latitude,digits=2), 49.96 )
})

test_that("is longitude correct", {
  expect_equal(round(test_geocode$chords$longitude,digits=2), -119.46 )
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
  expect_equal(round(test_no_postal_code$chords$latitude,digits=2), 50.94 )
})

test_that("is longitude correct", {
  expect_equal(round(test_no_postal_code$chords$longitude,digits=2), -114.06 )
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
  expect_equal(round(test_invalid_country_code$chords$latitude,digits=2), 51.16)
})

test_that("is longitude correct", {
  expect_equal(round(test_invalid_country_code$chords$longitude,digits=2), -115.56)
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
