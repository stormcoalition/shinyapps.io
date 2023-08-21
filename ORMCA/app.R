
library(shiny)
library(leaflet)
library(rgdal)
library(geojsonio)
library(googlesheets4)
library(dplyr, warn.conflicts = FALSE)
library(tidygeocoder)


source("func/geocoder.R", local=TRUE)
gs4_deauth()

ui <- bootstrapPage(
  leafletOutput("map", height = "100vh"),
  absolutePanel(
    bottom = 10, left = 10,
    div(style="display:inline-block",textInput("taddr", NULL, value = "search address...")),
    div(style="display:inline-block",actionButton('baddr', 'Search')) 
  )
)

server <- function(input, output, session) {
  showNotification("Map is loading...",type="message", duration=30)
  source("srv/leaflet.R", local = TRUE)$value
  source("srv/getLatLongFromAddress.R", local = TRUE)$value
  session$onSessionEnded(stopApp)
}


shinyApp(ui, server)
