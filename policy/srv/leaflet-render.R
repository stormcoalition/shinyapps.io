
output$mapPolicy <- renderLeaflet(source("srv/leaflet.R", local = TRUE)$value)

observeEvent(input$locate_easyButton, {
  cxy <- input$locate_easyButton
  leafletProxy("mapPolicy") %>%
    clearGroup('locate') %>%
    addCircleMarkers(lng=cxy[1],lat=cxy[2],
                     group = 'locate')
})