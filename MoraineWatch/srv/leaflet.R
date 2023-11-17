
output$map <- renderLeaflet({
  aoc <- readOGR("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation.geojson")
  orm <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation-dissolve.geojson") %>% paste(collapse = "\n")

  leaflet() %>%
    addTiles(attribution = '<a href="https://www.stormcoalition.com/" target="_blank" rel="noopener noreferrer"><b>Save The Oak Ridges Moraine</b></a>') %>%    
    addTiles(attribution = '<a href="https://stormcoalition.github.io/sources.html" target="_blank" rel="noopener noreferrer"><b>METADATA</b></a>') %>%
    
    addTiles(group='OSM') %>%
    
    # addProviderTiles(providers$OpenTopoMap, group='Topo', options = providerTileOptions(attribution=" Map data: © OpenStreetMap contributors, SRTM | Map style: © OpenTopoMap (CC-BY-SA) | Save The Oak Ridges Moraine")) %>%
    # # addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite", options = providerTileOptions(attribution=" Map tiles by Stamen Design, CC BY 3.0 — Map data © OpenStreetMap contributors | Save The Oak Ridges Moraine")) %>%    
    # addTiles("http://99.249.44.21:8081/basemap/{z}/{x}/{y}", group = "basemap", options = providerTileOptions(attribution=" © Save The Oak Ridges Moraine")) %>%

    
    addGeoJSON(orm, weight = 3, color='black', fillColor = "transparent", dashArray = '12,9', fillOpacity = 0.35) %>%
    
    setView(lng = -79.0, lat = 44.1, zoom = 10)
})


observe({
  leafletProxy("map") %>% clearPopups()
  event <- input$map_click
  if (is.null(event)) return()
  lat <- round(event$lat, 4)
  lng <- round(event$lng, 4)
  leafletProxy("map") %>% addPopups(event$lng,event$lat,paste0(lat, ',', lng, '<br><a href="mailto:test@example.com?subject=MORAINE WATCH [',lat,',',lng,']:">Send Watch</a>'))
})