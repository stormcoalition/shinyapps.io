
output$map <- renderLeaflet({
  orm <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation-dissolve.geojson")
  grnblt <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/GREENBELT_DESIGNATION-simplified-2022.geojson")
  bua <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/BUILT_UP_AREA-simplified.geojson")
  lspp <- st_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/LSPP-simplified.geojson")

  leaflet() %>%
    
    addTiles(attribution = '<a href="https://stormcoalition.github.io/sources.html" target="_blank" rel="noopener noreferrer"><b>METADATA</b></a> © <a href="https://www.stormcoalition.com/" target="_blank" rel="noopener noreferrer"><b>Save The Oak Ridges Moraine</b></a>') %>%
    
    addTiles() %>%
    # addTiles("http://99.249.44.21:8080/ORMbasemap/{z}/{x}/{y}", options = providerTileOptions(attribution=" © Save The Oak Ridges Moraine")) %>%
    
    addMouseCoordinates() %>%
    
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
      data = grnblt,
      color = "green",
      stroke = FALSE,
      weight = 3,
      fillOpacity = .35,
      group="Greenbelt",
      label = "Greenbelt",
      popup = '<a href="https://files.ontario.ca/greenbelt-plan-2017-en.pdf" target="_blank" rel="noopener noreferrer"><b>Greenbelt Plan (2017)</b></a>',
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity = .65, weight = 3, sendToBack = FALSE
      )
    ) %>%

    addPolygons(
      data = lspp,
      color = "darkblue",
      stroke = FALSE,
      weight = 3,
      fillOpacity = .35,
      group="Lake Simcoe Protection Plan",
      label = "Lake Simcoe Protection Plan",
      popup = '<a href="https://rescuelakesimcoe.org/wp-content/uploads/2021/02/Lake-Simcoe-Protection-Plan.pdf" target="_blank" rel="noopener noreferrer"><b>Lake Simcoe Protection Plan (2009)</b></a>',
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity = .65, weight = 3, sendToBack = FALSE
      )
    ) %>%
    
    addPolygons(
      data = orm,
      color = 'black',
      weight = 1,
      fillColor = "darkorange",
      fillOpacity = .35,
      group="Oak Ridges Moraine Conservation Plan",
      label = "Oak Ridges Moraine Conservation Plan",
      popup = '<a href="https://files.ontario.ca/oak-ridges-moraine-conservation-plan-2017.pdf" target="_blank" rel="noopener noreferrer"><b>Oak Ridges Moraine Conservation Plan (2017)</b></a>',
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity = .65, weight = 5, sendToBack = FALSE
      )
    ) %>%    
    
    setView(lng = -79.0, lat = 44.1, zoom = 8) %>%
    addLogo("logo-transp.png", src= "remote", width = 127)
  # addLogo("logoGBF_transp.png", src= "remote", width = 234) # %>%

    # addLayersControl(
    #   baseGroups = c("Municipalities", "Conservation Authorities", "Member of Provincial Parliament (MPP)"),
    #   options = layersControlOptions(collapsed = FALSE)
    # ) %>% 
    # hideGroup(c("Conservation Authorities", "Member of Provincial Parliament (MPP)"))
})