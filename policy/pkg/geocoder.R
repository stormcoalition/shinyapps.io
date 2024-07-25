
Sys.setenv(LOCATIONIQ_API_KEY="pk.8fcc7051a94262fc4947ec73621e589f")

getLatLongFromAddress <- function(input.address, limits) {
  # modified from https://jessecambon.github.io/tidygeocoder/
  # create a dataframe with addresses
  some_addresses <- tibble::tribble(
    ~name,                  ~addr,
    "me",                   input.address
  )

  # geocode the addresses
  # lat_longs <- some_addresses %>%
  #   geocode(addr, method = 'osm', lat = latitude , long = longitude, limit=100, return_input=F)
  lat_longs <- some_addresses %>%
    geocode(addr, method = 'iq', lat = latitude , long = longitude, limit=100, return_input=F)
  
  lat_longs = lat_longs[lat_longs$latitude>limits[1] &
                          lat_longs$latitude<limits[2] &
                          lat_longs$longitude>limits[3] &
                          lat_longs$longitude<limits[4] ,]
  
  return(lat_longs)
}



# getLatLongFromAddress("21 Western Ave", c(43.5,44.3,-80.2,-77.9))