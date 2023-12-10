
library(shiny)
# library(shinyjs)
library(leaflet)
# library(leaflet.extras)
library(leafem)
library(sf)
library(geojsonio)
# library(googlesheets4)
library(dplyr, warn.conflicts = FALSE)
library(tidygeocoder)


source("pkg/geocoder.R", local=TRUE)
# source("pkg/mobile.R", local=TRUE)
# gs4_deauth()

ui <- bootstrapPage(
  leafletOutput("map", height = "100vh"),
  absolutePanel(id = 'basemapLegend', class = "panel panel-default", fixed = TRUE, width = 240,
                draggable = FALSE, top = 10, left = "auto", right = 10, bottom = "auto",
                h4("Basemap"),
                img(src="basemap_legend.png", align='right', width='100%'),
  ),
  absolutePanel(id = 'addrpanl',
    bottom = 10, left = 10,
    div(style="display:inline-block",textInput("taddr", NULL, value = "search address...")),
    div(style="display:inline-block",actionButton('baddr', 'Search')) 
  )#,
  # mobileDetect('isMobile') ## from: https://g3rv4.com/2017/08/shiny-detect-mobile-browsers
)

server <- function(input, output, session) {
  # showNotification("Map is loading...",type="message", duration=30)
  source("srv/leaflet.R", local = TRUE)$value
  source("srv/getLatLongFromAddress.R", local = TRUE)$value
  # source("srv/mobile.R", local = TRUE)$value
  session$onSessionEnded(stopApp)
}


shinyApp(ui, server)
