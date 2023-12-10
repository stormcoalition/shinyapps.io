
library(leaflet)
library(sf)
library(rnaturalearth)


lakes10 <- ne_download(scale = 10, type = "lakes", category = "physical")
lakes10_sf <- lakes10 %>%
  st_as_sf() %>%
  filter(name %in% c("Lake Ontario","Lake Erie","Lake Simcoe","Lake Huron","Lake Nipissing","Indiana","Ohio","Pennsylvania","New York"))



m <- leaflet(lakes10_sf) %>%
  
  # addProviderTiles("Esri.WorldImagery") %>%

  addTiles("http://99.249.44.21:8081/ORMbasemap/{z}/{x}/{y}", options = providerTileOptions(attribution=" © Save The Oak Ridges Moraine")) %>%
  
  addMouseCoordinates()  %>%
  
  addPolygons(weight = 1,
              label = ~name,
  )%>%
  
  setView(lng = -78.78, lat = 44.1, zoom = 8)
  
htmlwidgets::saveWidget(m,file="ORMbasemap.html")

  
  