#' geocode
#'
#' Geocodes an address using the Bing Maps Locations API
#' For more information, please see https://docs.microsoft.com/en-us/bingmaps/rest-services/locations/find-a-location-by-address
#'
#' @param addressLine Street address of the location (e.g. "123 Market Street")
#' @param locality City/neighborhood of the location (e.g. "San Francisco")
#' @param adminDistrict Subdivision of the location, such as the state/province (e.g. "CA")
#' @param postalCode Postal/ZIP code of the location (e.g. 94114)
#' @param countryRegion ISO country code of the location (e.g. US)
#' @param includeNeighborhood Whether the response should include the neighborhood of the location (e.g. "0" or "1")
#'
#' @return S3 object containing the API response. Includes: \cr
#' "chords": Named list containing the geocoded coordinates\cr
#' "content": Complete parsed response, including the geocoded coordinates as well as other information about the location\cr
#' "params": Parameters inputted into the API from the user\cr
#' "response": Response object returned from httr, including the request URL, status code returned, and time of request\cr
#'
#' @importFrom httr GET user_agent http_status status_code content
#' @importFrom jsonlite fromJSON
#' @importFrom utils str
#'
#' @export
geocode <- function(addressLine=NULL,locality=NULL,adminDistrict=NULL,postalCode=NULL,countryRegion=NULL,includeNeighborhood=NULL) {
  # Check if user has set API key as env var
  key <- Sys.getenv('api_key')
  if (identical(key,'')) {
    stop('Please set your Bing Maps API key as an enviornment variable with name api_key, i.e. Sys.setenv(api_key=...)','\n','  You can obtain one at https://www.bingmapsportal.com/',call.=FALSE)
  }
  params=list(addressLine=addressLine,locality=locality,adminDistrict=adminDistrict,postalCode=postalCode,countryRegion=countryRegion,maxResults=1,includeNeighborhood=includeNeighborhood,key=key)
  ua=user_agent('https://github.com/ericphillips99/bingmapr/tree/main')
  response <- GET(url='http://dev.virtualearth.net/REST/v1/Locations/',query=params,user_agent=ua)
  # Check if request was successful
  if (status_code(response)!=200) {
    # Check for invalid API key
    if (http_status(response)$reason=='Unauthorized') {
      stop('Request unsuccessful: Your API key is invalid. Please check that you have entered it correctly.','\n','  You can access your key at https://www.bingmapsportal.com/')
    }
    # Handle all other possible errors
    stop('Request unsuccessful. (Error type: ',http_status(response)$category,', Reason: ',http_status(response)$reason,')',call.=FALSE)
  }
  # Check if response is empty
  if (identical(content(response,'text',simplifyVector=FALSE),'')) {
    stop('Request unsuccessful: Empty response returned. Perhaps you have entered an invalid address?')
  }
  # Parse response
  parsed_response <- fromJSON(content(response,'text'),simplifyVector=FALSE)
  chords=list()
  chords['latitude']=parsed_response$resourceSets[[1]]$resources[[1]]$point$coordinate[[1]]
  chords['longitude']=parsed_response$resourceSets[[1]]$resources[[1]]$point$coordinates[[2]]
  structure(list(chords=chords,content=parsed_response$resourceSets[[1]]$resources[[1]],params=params,response=response),class='geocode')
}

#' @export
print.geocode <- function(x,...) {
  cat('Geocode Results','\n',sep='')
  cat('Geocoded coordinates:','\n')
  str(x$chords)
  cat('\n','Complete results:','\n')
  str(x$content)
  invisible(x)
}
