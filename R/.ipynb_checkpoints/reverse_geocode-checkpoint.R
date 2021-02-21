library(httr)
library(jsonlite)

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
  print(response)
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

print.reverse_geocode <- function(x) {
  cat('Geocode Results','\n',sep='')
  cat('Reverse geocoded address:','\n')
  str(x$address)
  cat('\n','Complete results:','\n')
  str(x$content)
  invisible(x)
}
