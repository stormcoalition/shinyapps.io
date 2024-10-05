

output$mapMW <- renderLeaflet({
  hide('panl')
  leaflet(aoc) %>%

    addTiles(attribution = '<a href="https://stormcoalition.github.io" target="_blank" rel="noopener noreferrer"><b>STORM maps</b></a> | <a href="https://stormcoalition.github.io/sources.html" target="_blank" rel="noopener noreferrer"><b>Source Data</b></a> © <a href="https://www.stormcoalition.com/" target="_blank" rel="noopener noreferrer"><b>Save The Oak Ridges Moraine</b></a>') %>%
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
      # onClick=JS("function(btn, map){map.locate({setView: true}); }"))) %>%
      onClick=JS("function(btn, map){map.locate({setView: true}).on('locationfound', function(e){Shiny.setInputValue('locate_easyButton', [e.longitude,e.latitude] )})}"))) %>%
    
    addPolygons(
      data = ormcp,
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
    
    addPolygons(
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
    
    addLayersControl(
      # baseGroups = c("OSM", "basemap"),
      overlayGroups = "Show ORMCP Land use Designation",
      position = 'bottomright',
      options = layersControlOptions(collapsed = FALSE)
    ) %>% hideGroup("Show ORMCP Land use Designation") %>%
    
    setView(lng = -79.0, lat = 44.1, zoom = 10) %>%
    addLogo("https://raw.githubusercontent.com/stormcoalition/shinyapps.io/main/images/logo-transp.png", src= "remote", width = 127)
    # addLogo("logo-transp.png", src= "remote", width = 127)
    # addLogo("logoGBF_transp.png", src= "remote", width = 234)
})


mwpopup <- function(lat,lng) {
  paste0('<br><a href="https://docs.google.com/forms/d/e/1FAIpQLSc2vdJSsAJuwqtx1KXNak-dR_0nQVwza96SW4laxJM8qqyNwA/viewform?usp=pp_url&entry.597103671=[',lat,',+',lng,']"',
         '><b>Submit Watch--online form</b></a>',
         '<br><a href="mailto:contact@stormcoalition.com?subject=MORAINE WATCH [',lat,',',lng,']',
         '&body=What is the issue that you are concerned about?%0D%0A%0D%0A%0D%0A%0D%0A',
         'Where? (so we know where the issue is):%0D%0A',
         '  Region, Municipality, Town:%0D%0A',
         '  Road Address/Major Intersection (if known):%0D%0A%0D%0A',
         'Who is involved in this issue?:%0D%0A%0D%0A%0D%0A%0D%0A',
         'Why are you concerned?:%0D%0A%0D%0A%0D%0A%0D%0A',
         'When? (so we have an idea of how long has the issue been going on):%0D%0A%0D%0A%0D%0A%0D%0A',
         'Additional Comments/Details (please attach photos if possible):%0D%0A%0D%0A"',
         '>(alternatively, submit by email)</a>')
}

clk <- reactiveValues(clickedShape=NULL)

observeEvent(input$mapMW_shape_click, { clk$clickedShape <- input$mapMW_shape_click })

observeEvent(input$mapMW_click, {
  leafletProxy("mapMW") %>% clearPopups()
  event <- input$mapMW_click
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
    } else if (i==9) {
      output$shape.info <- renderUI(shiny::includeMarkdown("md/2024/141Malroy.md"))
    } else if (i==10) {
      output$shape.info <- renderUI(shiny::includeMarkdown("md/2024/GoodwoodPit.md"))
    } else if (i==11 | i==12) {
      output$shape.info <- renderUI(shiny::includeMarkdown("md/2024/YRSWP.md"))
    } else if (i==13) {
      output$shape.info <- renderUI(shiny::includeMarkdown("md/2024/durham-kawartha-project-line.md"))
    } else {
      hide('panl')
      output$shape.info <- renderUI(shiny::includeMarkdown("md/blank.md"))
    }
    
    leafletProxy("mapMW") %>%
      setView(lng = click$lng, lat = click$lat, zoom = 14) %>%
      addPopups(event$lng,event$lat,paste0('<b>',aoc$name[[idx]],'</b>', 
                                           "<br>Source: ", aoc$source[[idx]], '<a href="', aoc$link[[idx]], '" target="_blank" rel="noopener noreferrer"><i> read more...</i></a>',
                                           "<br>Date submitted: ", aoc$date_recorded[[idx]]))
  } else {
    hide('panl')
    output$shape.info <- renderUI(shiny::includeMarkdown("md/blank.md"))
    leafletProxy("mapMW") %>% 
      addPopups(event$lng,event$lat,paste0('Coordinates: ', lat, ',', lng, mwpopup(lat, lng)))
  }
  clk$clickedShape <- NULL
})



observe({
  map <- leafletProxy("mapMW") %>% clearControls()
  if (!is.null(input$mapMW_groups) ) {
    if (input$mapMW_groups == 'Show ORMCP Land use Designation') {
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


observeEvent(input$locate_easyButton, {
  cxy <- input$locate_easyButton
  leafletProxy("mapMW") %>%
    clearGroup('locate') %>%
    addCircleMarkers(lng=cxy[1],lat=cxy[2],
                     group = 'locate')
})
