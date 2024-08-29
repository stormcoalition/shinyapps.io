
output$map <- renderLeaflet(source("srv/leaflet.R", local = TRUE)$value)

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
    print(input$map_groups)
    if ('Show ORMCP Land use Designation' %in% input$map_groups) {
      map <- map %>%
        addLegend( #code for gdp legend
          layerId = "lormcp",
          # values=~ormcp@data$LAND_USE_DESIGNATION
          opacity=0.9,
          title = "<a href='https://files.ontario.ca/oak-ridges-moraine-conservation-plan-2017.pdf'>Oak Ridges Moraine Conservation Plan</a><br>Land Use Designation (2017)",
          position = "bottomright",
          # pal = ormcpPal
          colors = c('#DAC79B','#3FA427','#98E600','#8E3328','#BA9157','#C2C2C2'),
          labels = c("Countryside Area", "Natural Core Area", "Natural Linkage Area", "Palgrave Estates Residential Community", "Rural Settlement", "Settlement Area")
        )
    }
  }
})

observeEvent(input$locate_easyButton, {
  cxy <- input$locate_easyButton
  leafletProxy("map") %>%
    clearGroup('locate') %>%
    addCircleMarkers(lng=cxy[1],lat=cxy[2],
                     group = 'locate')
})