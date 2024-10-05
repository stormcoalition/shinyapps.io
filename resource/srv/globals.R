
pits <- read_sf("https://raw.githubusercontent.com/stormcoalition/geojson/main/AGGSITE_AUTHORIZED_STORM.geojson", quiet=TRUE)
till <- read_sf("https://raw.githubusercontent.com/stormcoalition/geojson/main/SOLRIS-tilled-lands.geojson", quiet=TRUE)
peat <- read_sf("https://raw.githubusercontent.com/stormcoalition/geojson/main/SOLRIS-peat-topsoil-extraction.geojson", quiet=TRUE)
plnt <- read_sf("https://raw.githubusercontent.com/stormcoalition/geojson/main/SOLRIS-plantations-trees-cultivated.geojson", quiet=TRUE)
wwis <- read_sf("https://raw.githubusercontent.com/stormcoalition/geojson/main/WWIS_STORM.geojson", quiet=TRUE)



pitsPal <- colorFactor(
  c('#e67e8c','#f0027f','#beaed4','grey40'),
  domain = pits$STATUS
)