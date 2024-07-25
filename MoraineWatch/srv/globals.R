
aoc <<- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/moraine-watch-aoc.geojson")

ormcp <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation.geojson")

ormcpPal <- colorFactor(
  c('#7fc97f','#beaed4','#fdc086','#ffff99','#386cb0','#f0027f'),
  domain = ormcp$LAND_USE_DESIGNATION
)
