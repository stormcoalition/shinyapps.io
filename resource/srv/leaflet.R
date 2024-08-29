
output$map <- renderLeaflet({
  pits <- read_sf("https://raw.githubusercontent.com/stormcoalition/geojson/main/AGGSITE_AUTHORIZED_STORM.geojson")
  
  pitsPal <- colorFactor(
    c('#7fc97f','#f0027f','#beaed4','grey40'),
    domain = pits$STATUS
  )

  leaflet() %>%
    
    addTiles(attribution = '<a href="https://stormcoalition.github.io" target="_blank" rel="noopener noreferrer"><b>STORM maps</b></a> | <a href="https://stormcoalition.github.io/sources.html" target="_blank" rel="noopener noreferrer"><b>Source Data</b></a> © <a href="https://www.stormcoalition.com/" target="_blank" rel="noopener noreferrer"><b>Save The Oak Ridges Moraine</b></a>') %>%
    
    addTiles() %>%
    addTiles("https://tile.oakridgeswater.ca/ORMbasemap/{z}/{x}/{y}", options = providerTileOptions(attribution=" © Save The Oak Ridges Moraine")) %>%

    # addMouseCoordinates() %>%
    
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
      # onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%
      onClick=JS("function(btn, map){map.locate({setView: true}).on('locationfound', function(e){Shiny.setInputValue('locate_easyButton', [e.longitude,e.latitude] )})}"))) %>%
    
    addPolygons(
      data = pits,
      fillColor = ~pitsPal(STATUS), #"grey40",
      fillOpacity = 1,
      weight = 2,
      group="Pits and Quarries",
      label = ~CL_NAME,
      popup = ~paste0(
        '<b>Name: ', CL_NAME,"</b>",
        '<br>Status: ', STATUS,
        '<br>Type: ', AUTH_TYPE,
        '<br>Depth: ', WATER_STAT,
        '<br>Limit: ', MAX_TN_LMT, "t"
      ),
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity =1, weight = 5, sendToBack = FALSE
      )
    ) %>%
  
    setView(lng = -79.0, lat = 44.1, zoom = 10) %>%
    addLogo("logo-transp.png", src= "remote", width = 127)
    # addLogo("logoGBF_transp.png", src= "remote", width = 234)

})


observe({
  leafletProxy("map") %>% clearPopups()
  event <- input$map_click
  if (is.null(event)) return()
  lat <- round(event$lat, 4)
  lng <- round(event$lng, 4)
  leafletProxy("map") %>% addPopups(event$lng,event$lat,paste0(lat, ',', lng))
})

observeEvent(input$locate_easyButton, {
  cxy <- input$locate_easyButton
  leafletProxy("map") %>%
    clearGroup('locate') %>%
    addCircleMarkers(lng=cxy[1],lat=cxy[2],
                     group = 'locate')
})