
ormcp <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation.geojson")

ormcpPal <- colorFactor(
  c('#7fc97f','#beaed4','#fdc086','#ffff99','#386cb0','#f0027f'),
  domain = ormcp$LAND_USE_DESIGNATION
)

output$map <- renderLeaflet({

  leaflet(ormcp) %>%
    
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
      onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%

    addPolygons(
      color = "black",
      weight = 2,
      fillColor = ~ormcpPal(LAND_USE_DESIGNATION),
      opacity = .5, 
      group="Show ORMCP Land use Designation",
      label = ~LAND_USE_DESIGNATION,
      popup = ~paste0(
        '<b>Land Use Designation: ', LAND_USE_DESIGNATION,"</b>",
        '<br>', LAND_USE_DESIG_DEFINITION
      ),
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity =.8, weight = 5, sendToBack = FALSE
      )
    ) %>%

    setView(lng = -79.0, lat = 44.1, zoom = 10) %>%
    addLayersControl(
      # baseGroups = c("OSM", "basemap"),
      overlayGroups = "Show ORMCP Land use Designation",
      position = 'bottomright',
      options = layersControlOptions(collapsed = FALSE)
    ) %>%
    
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


observe({
  map <- leafletProxy("map") %>% clearControls()
  if (!is.null(input$map_groups) ) {
    if (input$map_groups == 'Show ORMCP Land use Designation') {
      map <- map %>%
        addLegend( #code for gdp legend
          layerId = "lormcp",
          # values=~ormcp@data$LAND_USE_DESIGNATION
          opacity=0.9,
          title = "<a href='https://files.ontario.ca/oak-ridges-moraine-conservation-plan-2017.pdf'>Oak Ridges Moraine Conservation Plan</a><br>Land Use Designation (2017)",
          position = "bottomright",
          # pal = ormcpPal
          colors = c('#7fc97f','#beaed4','#fdc086','#ffff99','#386cb0','#f0027f'),
          labels = c("Countryside Area", "Natural Core Area", "Natural Linkage Area", "Palgrave Estates Residential Community", "Rural Settlement", "Settlement Area")
        )
    }
  }
})