
output$mapPolicy <- renderLeaflet({
  
  grnblt <- grnblt %>% filter(DESG_E != "Oak Ridges Moraine Conservation Plan")
  grnbltPal <- colorFactor(
    c('#C6D69E','#88CD66','#B4D69E','#798EF5','#C29ED6','#C29ED6'),
    levels = c("Oak Ridges Moraine Conservation Plan",
               "Protected Countryside",
               "Niagara Escarpment Plan",
               "Urban River Valley",
               "Holland Marsh",
               "Niagara Peninsula Tender Fruit and Grape Area"),
    domain = grnblt$DESG_E
  )

  leaflet() %>%
    
    addTiles(attribution = '<a href="https://stormcoalition.github.io" target="_blank" rel="noopener noreferrer"><b>STORM maps</b></a> | <a href="https://stormcoalition.github.io/sources.html" target="_blank" rel="noopener noreferrer"><b>Source Data</b></a> © <a href="https://www.stormcoalition.com/" target="_blank" rel="noopener noreferrer"><b>Save The Oak Ridges Moraine</b></a>') %>%
    # addTiles("https://tile.oakridgeswater.ca/ORMbasemap/{z}/{x}/{y}") %>%
    
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
    
    addPolygons(data = bua, 
                weight = 3, 
                color = "darkred", 
                stroke = FALSE, 
                fillOpacity = 0.35, 
                group="Built-up areas"
                ) %>%
    
    addPolygons(
      data = lspp,
      color = "darkblue",
      stroke = TRUE,
      weight = 1,
      fillOpacity = .15,
      group="Lake Simcoe Protection Plan",
      label = "Lake Simcoe Protection Plan",
      popup = '<a href="https://rescuelakesimcoe.org/wp-content/uploads/2021/02/Lake-Simcoe-Protection-Plan.pdf" target="_blank" rel="noopener noreferrer"><b>Lake Simcoe Protection Plan (2009)</b></a>',
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity = .65, weight = 3, sendToBack = TRUE, bringToFront = TRUE
      )
    ) %>%
    
    addPolygons(
      data = grnblt,
      color = "darkgreen",
      stroke = TRUE,
      weight = 1,
      fillColor = ~grnbltPal(DESG_E),
      fillOpacity = .55,
      group="Greenbelt",
      label = ~paste0("Greenbelt: ",DESG_E),
      popup = '<a href="https://files.ontario.ca/greenbelt-plan-2017-en.pdf" target="_blank" rel="noopener noreferrer"><b>Greenbelt Plan (2017)</b></a>',
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity = .85, weight = 3, sendToBack = FALSE
      )
    ) %>%
    
    addPolygons(
      data = orm,
      color = 'black',
      weight = 1,
      fillColor = "#C6D69E",
      fillOpacity = .55,
      group="Oak Ridges Moraine Conservation Plan Area",
      label = "Oak Ridges Moraine Conservation Plan Area",
      popup = '<a href="https://files.ontario.ca/oak-ridges-moraine-conservation-plan-2017.pdf" target="_blank" rel="noopener noreferrer"><b>Oak Ridges Moraine Conservation Plan (2017)</b></a>',
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity = .85, weight = 5, sendToBack = FALSE
      )
    ) %>%

    setView(lng = -79.0, lat = 44.0, zoom = 9) %>%
    addLogo("logo-transp.png", src= "remote", width = 127)
    # addLogo("logoGBF_transp.png", src= "remote", width = 234) # %>%

    # addLayersControl(
    #   baseGroups = c("Municipalities", "Conservation Authorities", "Member of Provincial Parliament (MPP)"),
    #   options = layersControlOptions(collapsed = FALSE)
    # ) %>% 
    # hideGroup(c("Conservation Authorities", "Member of Provincial Parliament (MPP)"))
})