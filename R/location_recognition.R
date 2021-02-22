#' location_recognition
#'
#' Returns a list of entities (business entities and natural points of interest) near an inputted coordinate pair using the Bing Maps Locations API
#' For more information, please see https://docs.microsoft.com/en-us/bingmaps/rest-services/locations/location-recognition
#'
#' @param lat Latitude of the location (e.g. '37.7708' )
#' @param long Longitude of the location (e.g. '-122.4195')
#' @param radius Radius (using units specified in distanceUnit) in which to find locations (e.g. '1.5'), default value is 0.25, maximum is 2
#' @param top Number of nearby entities to include (e.g. '10'), default value is 5, maximum is 20
#' @param dateTime Only include entities open at the specified date and time (e.g. '2021-01-01 12:00:00')
#' @param type Only include entities with the specified category types (e.g. 'EatDrink')
#' @param distanceUnit Units used for the radius parameter (e.g. 'km' or 'mi'), default value is 'mi'
#' @param includeEntityTypes Only include the specified entity types (e.g. 'naturalPOI')
#' @param verboseplacenames Whether the returned location names should be represented with their official abbreviations or in expanded form (e.g. 'true' or 'false'), default value is 'false'
#'
#' @return S3 object containing the API response. Includes: \cr
#' "business": Business entities returned, including their name, address, website, phone number, etc.\cr
#' "naturalPOI": Natural POIs returned, including their name and type\cr
#' "params": Parameters inputted into the API from the user\cr
#' "response": Response object returned from httr, including the request URL, status code returned, and time of request\cr
#'
#' @importFrom httr GET user_agent http_status status_code content
#' @importFrom jsonlite fromJSON
#' @importFrom utils str
#'
#' @export
location_recognition <- function(lat,long,radius=0.25,top=5,dateTime=NULL,type=NULL,distanceUnit='mi',includeEntityTypes=NULL,verboseplacenames=NULL) {
  # Check if user has set API key as env var
  key <- Sys.getenv('api_key')
  if (identical(key,'')) {
    stop('Please set your Bing Maps API key as an enviornment variable with name api_key, i.e. Sys.setenv(api_key=...)','\n','  You can obtain one at https://www.bingmapsportal.com/',call.=FALSE)
  }
  chords=paste(as.character(lat),',',as.character(long),sep='')
  params=list(radius=radius,top=top,dateTime=dateTime,type=type,distanceUnit=distanceUnit,includeEntityTypes=includeEntityTypes,verboseplacenames=verboseplacenames,key=key)
  ua=user_agent('https://github.com/ericphillips99/bingmapr/tree/main')
  response <- GET(url='http://dev.virtualearth.net',path=paste('/REST/v1/LocationRecog/',chords,sep=''),query=params,user_agent=ua)

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
    stop('Request unsuccessful: Empty response returned. Perhaps you have entered an invalid coordinate pair?')
  }
  # Parse response
  parsed_response <- fromJSON(content(response,'text'),simplifyVector=FALSE)
  structure(list(business=parsed_response$resourceSets[[1]]$resources[[1]]$businessesAtLocation,naturalPOI=parsed_response$resourceSets[[1]]$resources[[1]]$naturalPOIAtLocation,params=params,response=response),class='location_recognition')
}
#' @export
print.location_recognition <- function(x,...) {
  cat('Location Recognition Results','\n',sep='')
  cat('Businesses at location:','\n')
  str(x$business)
  cat('\n','Natural POIs at location:','\n')
  str(x$naturalPOI)
  invisible(x)
}
