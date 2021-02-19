library(httr)
library(jsonlite)

geocode <- function(addressLine=NULL,locality=NULL,adminDistrict=NULL,postalCode=NULL,countryRegion=NULL,maxResults=1,includeNeighborhood=FALSE) {
  # Check if user has set API key as env var
  key <- Sys.getenv('api_key')
  if (identical(key,'')) {
    stop('Please set your Bing Maps API key as an enviornment variable with name api_key, i.e. Sys.setenv(api_key=...)','\n','  You can obtain one at https://www.bingmapsportal.com/',call.=FALSE)
  }
  params=list(addressLine=addressLine,locality=locality,adminDistrict=adminDistrict,postalCode=postalCode,countryRegion=countryRegion,maxResults=maxResults,includeNeighborhood=includeNeighborhood,key=key)
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
  parsed_response <- jsonlite::fromJSON(content(response,'text'),simplifyVector=FALSE)
  chords=list()
  chords['latitude']=parsed_response$resourceSets[[1]]$resources[[1]]$point$coordinate[[1]]
  chords['longitude']=parsed_response$resourceSets[[1]]$resources[[1]]$point$coordinates[[2]]
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
