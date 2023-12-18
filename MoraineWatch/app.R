
library(shiny)
library(shinyjs)
library(shinydashboard)
library(leaflet)
library(leafem)
library(dplyr, warn.conflicts = FALSE)
library(sf)
library(geojsonio)
# library(googlesheets4)
# library(tidygeocoder)


source("func/geocoder.R", local=TRUE)
# gs4_deauth()

ui <- bootstrapPage(
  useShinyjs(),
  leafletOutput("map", height = "100vh"),
  absolutePanel(
    id = "panl", class = "panel panel-default", fixed = TRUE,
    draggable = FALSE, top = 10, left = "auto", right = 10, bottom = "auto",
    width = 420, height = "auto",
    shinydashboard::box(style='width:400px;height:650px;overflow-y: scroll;', uiOutput("shape.info")) #uiOutput
  ),
  absolutePanel(
    bottom = 10, left = 10,
    div(style="display:inline-block",textInput("taddr", NULL, value = "search address...")),
    div(style="display:inline-block",actionButton('baddr', 'Search')) 
  )
)

server <- function(input, output, session) {
  # showNotification("Map is loading...",type="message", duration=30)
  # source("srv/panel.R", local = TRUE)$value
  source("srv/leaflet.R", local = TRUE)$value
  source("srv/getLatLongFromAddress.R", local = TRUE)$value

  session$onSessionEnded(stopApp)
}

shinyApp(ui, server)
