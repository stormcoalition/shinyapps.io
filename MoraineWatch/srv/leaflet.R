

aoc <<- readOGR("https://raw.githubusercontent.com/stormcoalition/shinyapps.io/main/MoraineWatch/json/aoc1.geojson")


output$map <- renderLeaflet({
  
  orm <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation-dissolve.geojson") %>% paste(collapse = "\n")

  leaflet(aoc) %>%
    addTiles(attribution = '<a href="https://www.stormcoalition.com/" target="_blank" rel="noopener noreferrer"><b>Save The Oak Ridges Moraine</b></a>') %>%    
    addTiles(attribution = '<a href="https://stormcoalition.github.io/sources.html" target="_blank" rel="noopener noreferrer"><b>METADATA</b></a>') %>%
    
    addTiles(group='OSM') %>%
    
    # addProviderTiles(providers$OpenTopoMap, group='Topo', options = providerTileOptions(attribution=" Map data: © OpenStreetMap contributors, SRTM | Map style: © OpenTopoMap (CC-BY-SA) | Save The Oak Ridges Moraine")) %>%
    # # addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite", options = providerTileOptions(attribution=" Map tiles by Stamen Design, CC BY 3.0 — Map data © OpenStreetMap contributors | Save The Oak Ridges Moraine")) %>%    
    addTiles("http://99.249.44.21:8080/basemap/{z}/{x}/{y}", group = "basemap", options = providerTileOptions(attribution=" © Save The Oak Ridges Moraine")) %>%

    
    addGeoJSON(orm, weight = 3, color='black', fillColor = "transparent", dashArray = '12,9', fillOpacity = 0.35) %>%

    addPolygons(
      data = aoc,
      layerId = ~id,
      color = "red",
      weight = 3,
      # fillColor = ~ormcpPal(LAND_USE_DESIGNATION),
      opacity = .5, 
      # group="ORM Land use",
      label = ~Name,
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity = 1, weight = 5, sendToBack = FALSE
      )
    ) %>%
        
    addLayersControl(
      baseGroups = c("OSM", "basemap")
    ) %>%
    
    setView(lng = -79.0, lat = 44.1, zoom = 10)
})


observe({
  leafletProxy("map") %>% clearPopups()
  event <- input$map_click
  if (is.null(event)) return()
  lat <- round(event$lat, 4)
  lng <- round(event$lng, 4)

  click <- input$map_shape_click
  if(is.null(click)) {
    output$shape.info <- renderUI(shiny::includeMarkdown("md/blank.md"))
    leafletProxy("map") %>% 
      addPopups(event$lng,event$lat,paste0(lat, ',', lng, '<br>',
                                           '<a href="mailto:test@example.com?subject=MORAINE WATCH [',lat,',',lng,']',
                                           '&body=What is the issue that you are concerned about?%0D%0A%0D%0A%0D%0A%0D%0A',
                                           'Where? (so we know where the issue is):%0D%0A',
                                           '  Region, Municipality, Town:%0D%0A',
                                           '  Road Address/Major Intersection (if known):%0D%0A%0D%0A',
                                           'Who is involved in this issue?:%0D%0A%0D%0A%0D%0A%0D%0A',
                                           'Why are you concerned?:%0D%0A%0D%0A%0D%0A%0D%0A',
                                           'When? (so we have an idea of how long has the issue been going on):%0D%0A%0D%0A%0D%0A%0D%0A',
                                           'Additional Comments/Details (please attach photos if possible):%0D%0A%0D%0A"',
                                           '>Submit Watch</a>'))
  } else {
    idx <- which(aoc$id == click$id)
    z <- aoc$zoom[[idx]]
    
    # print(idx)
    if (idx[1]==1) {
      output$shape.info <- renderUI(shiny::includeMarkdown("md/2023/Hwy400Expansion.md"))
    } else if (idx[1]==2) {
      output$shape.info <- renderUI(shiny::includeMarkdown("md/2023/MaryLake.md"))
    } else {
      output$shape.info <- renderUI(shiny::includeMarkdown("md/2023/King-Bathurst.md"))
    }

    leafletProxy("map") %>%
      setView(lng = click$lng, lat = click$lat, zoom = 14)

    leafletProxy("map") %>% 
      addPopups(event$lng,event$lat,paste0(aoc$Name[[idx]], '<br>',
                 '<a href="mailto:test@example.com?subject=MORAINE WATCH [',lat,',',lng,']',
                 '&body=What is the issue that you are concerned about?%0D%0A%0D%0A%0D%0A%0D%0A',
                 'Where? (so we know where the issue is):%0D%0A',
                 '  Region, Municipality, Town:%0D%0A',
                 '  Road Address/Major Intersection (if known):%0D%0A%0D%0A',
                 'Who is involved in this issue?:%0D%0A%0D%0A%0D%0A%0D%0A',
                 'Why are you concerned?:%0D%0A%0D%0A%0D%0A%0D%0A',
                 'When? (so we have an idea of how long has the issue been going on):%0D%0A%0D%0A%0D%0A%0D%0A',
                 'Additional Comments/Details (please attach photos if possible):%0D%0A%0D%0A"',
                 '>Submit Watch</a>'))
  }
})

# 
# # from https://stackoverflow.com/questions/73314170/distinguish-between-inputmap-click-and-inputmap-shape-click-in-leaflet-r-shiny
# clicked <- reactiveVal()
# observeEvent(input$map_shape_click, {
#   freezeReactiveValue(input, 'map_click')
#   clicked(input$map_shape_click)
# })
# observeEvent(input$map_click, {
#   clicked(input$map_click)
# })
# 
# 
# output$shape.info <- renderUI({
#   req(clk <- clicked())
#   if(is.null(clk[['id']])) return(div("Nothing selected"))
#   
#   leafletProxy("map") %>% clearPopups()
#   event <- input$map_click
#   if (is.null(event)) return()
#   lat <- round(event$lat, 4)
#   lng <- round(event$lng, 4)
#   
#   # click <- input$map_shape_click
#   if(is.null(clk)) {
#     leafletProxy("map") %>% addPopups(event$lng,event$lat,paste0(lat, ',', lng, '<br><a href="mailto:test@example.com?subject=MORAINE WATCH [',lat,',',lng,']:">Send Watch</a>'))
#     return(renderUI(shiny::includeMarkdown("md/blank.md")))
#   } else {
#     idx <- which(aoc$id == clk$id)
#     z <- aoc$zoom[[idx]]
#     print(idx)
#     if (idx[1]==1) {
#       return( renderUI(shiny::includeMarkdown("md/2023/Hwy400Expansion.md")))
#     } else if (idx[1]==2) {
#       return( renderUI(shiny::includeMarkdown("md/2023/MaryLake.md")))
#     } else {
#       return( renderUI(shiny::includeMarkdown("md/2023/King-Bathurst.md")))
#     }
#     
#     leafletProxy("map") %>% 
#       setView(lng = clk$lng, lat = clk$lat, zoom = 14)
#     
#     leafletProxy("map") %>% addPopups(event$lng,event$lat,paste0('<a href="mailto:test@example.com?subject=MORAINE WATCH [',lat,',',lng,']:">Send Watch</a>'))
#   }  
# })
