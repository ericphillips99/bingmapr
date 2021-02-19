library(httr)
library(jsonlite)

geocode <- function(addressLine=NULL,locality=NULL,adminDistrict=NULL,postalCode=NULL,countryRegion=NULL,maxResults=1,includeNeighborhood=FALSE) {
  key <- Sys.getenv('api_key')
  if (identical(key,'')) {
    stop('Please set your Bing Maps API key as an enviornment variable with name api_key',call.=FALSE)
  }
  params=list(addressLine=addressLine,locality=locality,adminDistrict=adminDistrict,postalCode=postalCode,countryRegion=countryRegion,maxResults=maxResults,includeNeighborhood=includeNeighborhood,key=key)
  response <- GET(url='http://dev.virtualearth.net/REST/v1/Locations/',query=params)
  parsed_response <- jsonlite::fromJSON(content(response,'text'),simplifyVector=FALSE)
  chords=list()
  chords['latitude']=parsed_response$resourceSets[[1]]$resources[[1]]$geocodePoints[[2]]$coordinates[[1]]
  chords['longitude']=parsed_response$resourceSets[[1]]$resources[[1]]$geocodePoints[[2]]$coordinates[[2]]
  structure(list(chords=chords,content=parsed_response$resourceSets[[1]]$resources[[1]],params=params,response=response),class='geocode')
}

print.geocode <- function(x) {
  cat('Geocode Results','\n',sep='')
  cat('Geocoded coordinates:','\n')
  str(x$chords)
  cat('\n','Complete results:','\n')
  str(x$content)
  invisible(x)
}
