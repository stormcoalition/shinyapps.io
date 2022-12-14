
output$map <- renderLeaflet({
  geojson <- readOGR("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation.geojson")
  nhsa <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/NHSAREA-simplified.geojson") %>% paste(collapse = "\n")
  grnblt <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/GREENBELT_DESIGNATION-simplified.geojson") %>% paste(collapse = "\n")
  bua <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/BUILT_UP_AREA-simplified.geojson") %>% paste(collapse = "\n")
  wetlnds <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/wetlands-simplified.geojson") %>% paste(collapse = "\n")
  
  add.1 <- readOGR("https://raw.githubusercontent.com/stormcoalition/geojson/main/Proposed-Greenbelt-modifications.geojson")
  
  pal <- colorFactor(
    c('#7fc97f','#beaed4','#fdc086','#ffff99','#386cb0','#f0027f'),
    domain = geojson@data$LAND_USE_DESIGNATION
  )

  leaflet(geojson) %>%
    addTiles(group='OSM') %>%
    addProviderTiles(providers$OpenTopoMap, group='Topo', options = providerTileOptions(attribution=" Map data: © OpenStreetMap contributors, SRTM | Map style: © OpenTopoMap (CC-BY-SA) | Oak Ridges Moraine Groundwater Program")) %>%
    addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite", options = providerTileOptions(attribution=" Map tiles by Stamen Design, CC BY 3.0 — Map data © OpenStreetMap contributors | Oak Ridges Moraine Groundwater Program")) %>%    

    addTiles(attribution = '<a href="https://www.stormcoalition.com/" target="_blank" rel="noopener noreferrer"><b>Save The Oak Ridges Moraine</b></a>') %>%
    addTiles(attribution = '<a href="https://stormcoalition.github.io/sources.html" target="_blank" rel="noopener noreferrer"><b>Sources</b></a>') %>%
    
    addGeoJSON(bua, weight = 3, color = "darkred", stroke = FALSE, fillOpacity = 0.35, group="Built-up areas") %>%
    addGeoJSON(grnblt, weight = 3, color = "green", stroke = FALSE, fillOpacity = 0.35, group="Greenbelt") %>%
    addGeoJSON(wetlnds, weight = 3, color = "darkgreen", stroke = FALSE, fillOpacity = 0.35, group="Wetlands") %>%
    addGeoJSON(nhsa, weight = 3, color = "blue", stroke = FALSE, fillOpacity = 0.35, group="Natural heritage systems") %>%    
    
    addPolygons(
      color = "black",
      weight = 2,
      fillColor = ~pal(LAND_USE_DESIGNATION),
      opacity = .5,
      label = ~LAND_USE_DESIGNATION,
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity =1, weight = 5, sendToBack = FALSE
      )
    ) %>%
    
    addPolygons(data=add.1, 
                weight = 8, 
                color="red", 
                fillColor = "cyan", 
                fillOpacity = 0.75,
                label = ~paste0('Proposed ', current,' redesignation (click me)'),
                popup = ~paste0('<a href="https://geohub.lio.gov.on.ca/documents/southern-ontario-land-resource-information-system-solris-3-0/about"><b>SOLRIS v3.0</b></a>',' land use:',
                                '<br>Agriculture cover: ', agriculture,
                                '<br>Forest cover: ', forest,
                                '<br><br>Layer converage:',
                                '<br><a href="https://geohub.lio.gov.on.ca/documents/southern-ontario-land-resource-information-system-solris-3-0/about">Natural Heritage: </a>', NHS,
                                '<br><a href="https://geohub.lio.gov.on.ca/documents/southern-ontario-land-resource-information-system-solris-3-0/about">Wetlands: </a>', wetland,
                                '<br><em>(click hyperlinks for source reference)</em>'
                                ),
                group = "ORM Land use",
                highlightOptions = highlightOptions(
                  opacity = 1, fillOpacity =1, weight = 5, sendToBack = FALSE
                )
    ) %>%
    
    addLegend("topright", pal = pal, values = ~LAND_USE_DESIGNATION,
              title = "Oak Ridges Moraine<br>Land Use Designation",
              opacity = 1
    ) %>%
    setView(lng = -79.0, lat = 44.1, zoom = 10) %>%
    addLayersControl (
      baseGroups = c("OSM", "Topo", "Toner Lite"),
      overlayGroups = c("ORM Land use", "Greenbelt", "Built-up areas", "Wetlands", "Natural heritage systems"),
      options = layersControlOptions(collapsed = FALSE) #position = "bottomleft")
    ) %>% hideGroup(c("Greenbelt", "Built-up areas", "Wetlands","Natural heritage systems"))
})


observe({
  leafletProxy("map") %>% clearPopups()
  event <- input$map_click
  if (is.null(event)) return()
  lat <- round(event$lat, 4)
  lng <- round(event$lng, 4)
  leafletProxy("map") %>% addPopups(event$lng,event$lat,paste0(lat, ', ', lng))
})