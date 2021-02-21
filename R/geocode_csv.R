#' geocode_csv
#'
#' Geocodes a set of addresses from a CSV file using the geocode function from bingmapr
#'
#' @param csv_path File path of the CSV file with addresses to geocode
#' @param addressLine_col Name of the column in the CSV containing the addressLine of the locations
#' @param locality_col Name of the column in the CSV containing the locality of the locations
#' @param adminDistrict_col Name of the column in the CSV containing the adminDistrict of the locations
#' @param postalCode_col Name of the column in the CSV containing the postalCode of the locations
#' @param countryRegion_col Name of the column in the CSV containing the countryRegion of the locations
#'
#' @return Tibble containing the original CSV with the columns "latitude" and "longitude" appended \cr
#' Saves a copy of the inputted CSV including the geocoded coordinates to the same location as the original CSV with '_geocoded' appended to the filename

#' @importFrom readr read_csv write_csv
#' @importFrom stringr str_split
#'
geocode_csv <- function(csv_path,addressLine_col=NULL,locality_col=NULL,adminDistrict_col=NULL,postalCode_col=NULL,countryRegion_col=NULL) {
  csv <- read_csv(csv_path)
  # Check if provided columns exist
  if (is.null(addressLine_col)==FALSE) {
    if (addressLine_col %in% colnames(csv)==FALSE) {
      stop('Specified addressLine column does not exist in CSV: ',addressLine_col,'\n','  Perhaps you have misttyped the column name?')
    }
  }
  if (is.null(locality_col)==FALSE) {
    if (locality_col %in% colnames(csv)==FALSE) {
      stop('Specified locality column does not exist in CSV: ',locality_col,'\n','  Perhaps you have misttyped the column name?')
    }
  }
  if (is.null(adminDistrict_col)==FALSE) {
    if (adminDistrict_col %in% colnames(csv)==FALSE) {
      stop('Specified adminDistrict column does not exist in CSV: ',adminDistrict_col,'\n','  Perhaps you have misttyped the column name?')
    }
  }
  if (is.null(postalCode_col)==FALSE) {
    if (postalCode_col %in% colnames(csv)==FALSE) {
      stop('Specified postalCode column does not exist in CSV: ',postalCode_col,'\n','  Perhaps you have misttyped the column name?')
    }
  }
  if (is.null(countryRegion_col)==FALSE) {
    if (countryRegion_col %in% colnames(csv)==FALSE) {
      stop('Specified countryRegion column does not exist in CSV: ',countryRegion_col,'\n','  Perhaps you have misttyped the column name?')
    }
  }

  lats <- c()
  longs <- c()

  # Iterate through rows in df
  for (i in 1:nrow(csv)) {
    row <- csv[i,]
    # Geocode row
    geocoded_row <- geocode(addressLine=row[addressLine_col],locality=row[locality_col],adminDistrict=row[adminDistrict_col],postalCode=row[postalCode_col],countryRegion=row[countryRegion_col])
    lats <- append(lats,geocoded_row$chords$latitude)
    longs <- append(longs,geocoded_row$chords$longitude)
    Sys.sleep(0.25)
    cat('Geocoded',i,'of',nrow(csv),'addresses!','\n')
  }

  # Append to df
  csv$latitude <- lats
  csv$longitude <- longs

  # Save to disk
  path_to_csv <- paste(str_split(csv_path,'.csv')[[1]][1],'_geocoded.csv',sep='')
  write_csv(csv,file=path_to_csv)

  # Return tibble with geocoded chords
  csv
}
