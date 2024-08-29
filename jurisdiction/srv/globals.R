  # orm <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation-dissolve.geojson") %>% paste(collapse = "\n")
  orm <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation-dissolve.geojson", quiet=TRUE)
  ridings <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/ELECTORAL_DISTRICT_STORM.geojson", quiet=TRUE)
  CAs <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/CONS_AUTH_ADMIN_AREA_STORM.geojson", quiet=TRUE)
  
  # munis <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/MUNIC_BND_ALL_STORM.geojson", quiet=TRUE)
  munis <- geojson_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/MUNIC_BND_ALL_STORM.geojson", what = "sp")
  neword <- order(-munis@data$area)  # set order
  munis@polygons <- munis@polygons[neword]
  munis@plotOrder <- neword
  munis@data <- munis@data %>% arrange(-area)