  # orm <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation-dissolve.geojson") %>% paste(collapse = "\n")
  orm <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation-dissolve.geojson")
  ridings <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/ELECTORAL_DISTRICT_STORM.geojson")
  CAs <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/CONS_AUTH_ADMIN_AREA_STORM.geojson")
  
  # munis <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/MUNIC_BND_ALL_STORM.geojson")
  munis <- geojson_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/MUNIC_BND_ALL_STORM.geojson", what = "sp")
  neword <- order(-munis@data$area)  # set order
  munis@polygons <- munis@polygons[neword]
  munis@plotOrder <- neword
  munis@data <- munis@data %>% arrange(-area)