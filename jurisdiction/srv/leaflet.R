
output$map <- renderLeaflet({
  orm <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation-dissolve.geojson") %>% paste(collapse = "\n")
  ridings <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/ELECTORAL_DISTRICT_STORM.geojson")
  CAs <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/CONS_AUTH_ADMIN_AREA_STORM.geojson")
  
  # munis <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/MUNIC_BND_ALL_STORM.geojson")
  munis <- geojson_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/MUNIC_BND_ALL_STORM.geojson", what = "sp")
  neword <- order(-munis@data$area)  # set order
  munis@polygons <- munis@polygons[neword]
  munis@plotOrder <- neword
  munis@data <- munis@data %>% arrange(-area)
  
  leaflet() %>%
    
    addTiles(attribution = '<a href="https://stormcoalition.github.io/sources.html" target="_blank" rel="noopener noreferrer"><b>METADATA</b></a> © <a href="https://www.stormcoalition.com/" target="_blank" rel="noopener noreferrer"><b>Save The Oak Ridges Moraine</b></a>') %>%
    
    addTiles() %>%
    # addTiles("http://99.249.44.21:8080/ORMbasemap/{z}/{x}/{y}", options = providerTileOptions(attribution=" © Save The Oak Ridges Moraine")) %>%
    
    addMouseCoordinates() %>%
    
    addMeasure(
      position = "topleft",
      primaryLengthUnit = "meters",
      primaryAreaUnit = "hectares",
      secondaryAreaUnit = "acres",
      activeColor = "#3D535D",
      completedColor = "#7D4479"
      ) %>%
  
    addEasyButton(easyButton(
      icon="fa-crosshairs", title="Locate Me",
      onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%
    
    addGeoJSON(orm, color = 'black', weight=1, fillColor  = "darkorange") %>%

    addPolygons(
      data = CAs,
      color = "darkgreen",
      weight = 2,
      opacity = .5,
      group="Conservation Authorities",
      label = ~LEGAL_NAME,
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity = .65, weight = 5, sendToBack = FALSE
      )
    ) %>%

    addPolygons(
      data = munis,
      color = "darkblue",
      weight = 2,
      opacity = .5,
      fillOpacity = .1,
      group="Municipalities",
      label = ~MUN_NAME,
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity = .45, weight = 5, sendToBack = FALSE
      )
    ) %>%
    
    addPolygons(
      data = ridings,
      color = "darkred",
      weight = 2,
      opacity = .35,
      group="Member of Provincial Parliament (MPP)",
      label = ~Riding,
      popup = ~paste0(
                '<b>Riding: ', Riding,"</b>",
                '<br>MPP: ', First_name," ",Last_name,
                '<br>email: <a href="mailto:',Email,'">',Email,'</a>',
                '<br>telephone: ', Telephone
                ),
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity = .65, weight = 5, sendToBack = FALSE
      )
    ) %>%
    
    setView(lng = -79.0, lat = 44.1, zoom = 9) %>%

    addLayersControl(
      baseGroups = c("Municipalities", "Conservation Authorities", "Member of Provincial Parliament (MPP)"),
      options = layersControlOptions(collapsed = FALSE)
    ) %>% 
    hideGroup(c("Conservation Authorities", "Member of Provincial Parliament (MPP)"))
})