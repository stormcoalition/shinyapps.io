
output$map <- renderLeaflet({
  source("srv/globals.R", local = TRUE)$value
  source("srv/leaflet.R", local = TRUE)$value
})