#' reverse_geocode
#'
#' Reverse geocodes an address using the Bing Maps Locations API
#' For more information, please see https://docs.microsoft.com/en-us/bingmaps/rest-services/locations/find-a-location-by-point
#'
#' @param lat Latitude of the location (e.g. '37.7708' )
#' @param long Longitude of the location (e.g. '-122.4195')
#' @param includeEntityTypes Only include the specified entity types (e.g. 'naturalPOI')
#' @param verboseplacenames Whether the returned location names should be represented with their official abbreviations or in expanded form (e.g. 'true' or 'false'), default value is 'false'
#' @param includeNeighborhood Whether the response should include the neighborhood of the location (e.g. "0" or "1")
#'
#' @return S3 object containing the API response. Includes: \cr
#' "address": Complete geocoded address\cr
#' "content": Complete parsed response, including the geocoded address separated by descriptor as well as other information about the location\cr
#' "params": Parameters inputted into the API from the user\cr
#' "response": Response object returned from httr, including the request URL, status code returned, and time of request\cr
#'
#' @importFrom httr GET user_agent http_status status_code content
#' @importFrom jsonlite fromJSON
#' @importFrom utils str

#' @export
reverse_geocode <- function(lat,long,includeEntityTypes=NULL,verboseplacenames=NULL,includeNeighborhood=NULL) {
  # Check if user has set API key as env var
  key <- Sys.getenv('api_key')
  if (identical(key,'')) {
    stop('Please set your Bing Maps API key as an enviornment variable with name api_key, i.e. Sys.setenv(api_key=...)','\n','  You can obtain one at https://www.bingmapsportal.com/',call.=FALSE)
  }
  chords=paste(as.character(lat),',',as.character(long),sep='')
  params=list(includeEntityTypes=includeEntityTypes,verboseplacenames=verboseplacenames,includeNeighborhood=includeNeighborhood,key=key)
  ua=user_agent('https://github.com/ericphillips99/bingmapr/tree/main')
  response <- GET(url='http://dev.virtualearth.net',path=paste('/REST/v1/Locations/',chords,sep=''),query=params,user_agent=ua)

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
  parsed_response <- jsonlite::fromJSON(content(response,'text'),simplifyVector=FALSE)
  address <- parsed_response$resourceSets[[1]]$resources[[1]]$name
  structure(list(address=address,content=parsed_response$resourceSets[[1]]$resources[[1]],params=params,response=response),class='reverse_geocode')
}
#' @export
print.reverse_geocode <- function(x,...) {
  cat('Geocode Results','\n',sep='')
  cat('Reverse geocoded address:','\n')
  str(x$address)
  cat('\n','Complete results:','\n')
  str(x$content)
  invisible(x)
}
