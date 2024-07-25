
output$mapPolicy <- renderLeaflet(source("srv/leaflet.R", local = TRUE)$value)