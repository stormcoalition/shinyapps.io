

aoc <<- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/moraine-watch-aoc.geojson")


output$map <- renderLeaflet({
  hide('panl')
  leaflet(aoc) %>%

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
      data = aoc,
      layerId = ~id,
      color = "red",
      weight = 3,
      # fillColor = ~ormcpPal(LAND_USE_DESIGNATION),
      opacity = .5, 
      # group="ORM Land use",
      label = ~name,
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity = 1, weight = 5, sendToBack = FALSE
      )
    ) %>%
    
    setView(lng = -79.0, lat = 44.1, zoom = 10) %>%
    addLogo("logo-transp.png", src= "remote", width = 127)
    # addLogo("logoGBF_transp.png", src= "remote", width = 234)
})


mwpopup <- function(lat,lng) {
  paste0('<br><a href="mailto:test@example.com?subject=MORAINE WATCH [',lat,',',lng,']',
         '&body=What is the issue that you are concerned about?%0D%0A%0D%0A%0D%0A%0D%0A',
         'Where? (so we know where the issue is):%0D%0A',
         '  Region, Municipality, Town:%0D%0A',
         '  Road Address/Major Intersection (if known):%0D%0A%0D%0A',
         'Who is involved in this issue?:%0D%0A%0D%0A%0D%0A%0D%0A',
         'Why are you concerned?:%0D%0A%0D%0A%0D%0A%0D%0A',
         'When? (so we have an idea of how long has the issue been going on):%0D%0A%0D%0A%0D%0A%0D%0A',
         'Additional Comments/Details (please attach photos if possible):%0D%0A%0D%0A"',
         '><b>Submit Watch</b></a>')
}

clk <- reactiveValues(clickedShape=NULL)

observeEvent(input$map_shape_click, { clk$clickedShape <- input$map_shape_click })

observeEvent(input$map_click, {
  leafletProxy("map") %>% clearPopups()
  event <- input$map_click
  if (is.null(event)) return()
  lat <- round(event$lat, 4)
  lng <- round(event$lng, 4)

  if (!is.null(clk$clickedShape)) {
    click <- clk$clickedShape
    idx <- which(aoc$id == click$id)
    z <- aoc$zoom[[idx]]
    i <- strtoi(aoc$id[[idx]])
    
    show('panl')
    if (i==0) {
      output$shape.info <- renderUI(shiny::includeMarkdown("md/2023/Hwy400Expansion.md"))
    } else if (i==1) {
      output$shape.info <- renderUI(shiny::includeMarkdown("md/2023/MaryLake.md"))
    } else if (i==2 | i==3) {
      output$shape.info <- renderUI(shiny::includeMarkdown("md/2023/King-Bathurst.md"))
    } else {
      hide('panl')
      output$shape.info <- renderUI(shiny::includeMarkdown("md/blank.md"))
    }
    
    leafletProxy("map") %>%
      setView(lng = click$lng, lat = click$lat, zoom = 14) %>%
      addPopups(event$lng,event$lat,paste0('<b>',aoc$name[[idx]],'</b>', 
                                           "<br>Source: ", aoc$source[[idx]], '<a href="', aoc$link[[idx]], '" target="_blank" rel="noopener noreferrer"><i> read more...</i></a>',
                                           "<br>Date submitted: ", aoc$date_recorded[[idx]]))
  } else {
    hide('panl')
    output$shape.info <- renderUI(shiny::includeMarkdown("md/blank.md"))
    leafletProxy("map") %>% 
      addPopups(event$lng,event$lat,paste0(lat, ',', lng, mwpopup(lat, lng)))
  }
  clk$clickedShape <- NULL
})
