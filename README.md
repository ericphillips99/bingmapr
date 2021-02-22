# bingmapr

![R build status](https://github.com/ericphillips99/bingmapr/actions/workflows/r2d2.yml/badge.svg)

`bingmapr` is a wrapper for the Bing Maps API written in R.

This build includes wrapper functions for several of the Locations API functions, including geocoding, reverse geocoding, and location recognition, as well as a function for batch geocoding from a CSV.

* `geocode()` find the coordinate pair of a given address
* `reverse_geocode()` find the address nearest to a coordinate pair
* `location_recognition()` finds a list of entities within a given radius
* `geocode_csv()` add coordinate pairs to a list of addresses in a CSV file

## Prerequisites

Install [RStudio](https://rstudio.com/) or another R-compatible IDE to install `bingmapr` - built for R V4.0

### Installation

```R
devtools::install_github("https://github.com/ericphillips99/bingmapr")
```

##### Vignette

If you wish to use the built-in vignette, please install with `devtools::install_github(build_vignettes = TRUE)` and then run `browseVignettes(package='bingmapr')` to view.

NOTE: If you wish to include Vignette in your installation, please set your API Key before installation.

##### API Key

In order to make use of any of the functions contained within this package, you must first obtain a Bing Maps API key [here](https://www.bingmapsportal.com). Once you have your key, you must set it as an environment variable with name `api_key`:

`Sys.setenv(api_key=API_KEY_GOES_HERE)`

## Usage

```R
libarary(bingmapr)

# Geocoding
geocode_test <- geocode(addressLine='2135 Bennett Road', locality='Kelowna', adminDistrict='BC')
geocode_test$chords
# $latitude
# [1] 49.95974
# 
# $longitude
# [1] -119.4602


# Reverse Geocoding
rev_geocode_result <- reverse_geocode(lat=49.8682,long=-119.4889)
rev_geocode_result$address
# "674 Patterson Ave, Kelowna, BC V1Y 5C7, Canada"


# Location Recognition
loc_recog_result <- location_recognition(lat=49.8682,long=-119.4889)
loc_recog_result$business[[1]]
# $businessAddress$addressLine
# [1] "665B Patterson Ave"
# ...
# $businessInfo
# $businessInfo$entityName
# [1] "Perception Marketing"
# ...
# $businessInfo$type
# [1] "Business-to-Business"


geocode_csv("sf_starbucks_sample.csv",addressLine_col="street_addres", locality_col="city")
# Returns CSV saved to working directory with columns added for the latitude and longitude of each address in the original CSV.
```

## Built With

* [Roxygen2](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html) - Documentation
* [Devtools](https://www.r-project.org/nosvn/pandoc/devtools.html) - Package development
* [RStudio](https://rstudio.com/) - Development IDE

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[GNU General Public License ](https://github.com/ericphillips99/bingmapr/blob/main/LICENSE.md)











![R build status](https://github.com/ericphillips99/bingmapr/actions/workflows/r2d2.yml/badge.svg)