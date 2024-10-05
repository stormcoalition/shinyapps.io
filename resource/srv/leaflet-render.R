
output$map <- renderLeaflet({
  source("srv/globals.R", local = TRUE)$value
  source("srv/leaflet.R", local = TRUE)$value
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