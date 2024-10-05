
leaflet() %>%
  
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
    # onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%
    onClick=JS("function(btn, map){map.locate({setView: true}).on('locationfound', function(e){Shiny.setInputValue('locate_easyButton', [e.longitude,e.latitude] )})}"))) %>%
  
  addPolygons(
    data = pits,
    fillColor = ~pitsPal(STATUS), #"grey40",
    fillOpacity = 1,
    weight = 2,
    group="Pits and Quarries",
    label = ~CL_NAME,
    popup = ~paste0(
      '<b>Name: ', CL_NAME,"</b>",
      '<br>Status: ', STATUS,
      '<br>Type: ', AUTH_TYPE,
      '<br>Depth: ', WATER_STAT,
      '<br>Limit: ', MAX_TN_LMT, "t"
    ),
    highlightOptions = highlightOptions(
      opacity = 1, fillOpacity = 1, weight = 5, sendToBack = FALSE
    )
  ) %>%
  
  addPolygons(
    data=till,
    color="black",
    fillColor = "#ffffbe",
    fillOpacity = .85,
    weight = 1,
    group="Row crops",
    label = "Row crops",
    popup = paste0(
      '<b>From <a href="https://www.arcgis.com/home/item.html?id=0279f65b82314121b5b5ec93d76bc6ba">SOLRIS 3.0</a></b>',
      '<br>Agricultural fields managed as continuous annual row crops inferred from 3observed sequential time periods over a 10 year time period. 
 There can be as many as 2 time periods where fields are rotated with perennial crops. (e.g., hay, improved pasture).'
    ),
    highlightOptions = highlightOptions(
      opacity = 1, fillOpacity = 1, weight = 5, sendToBack = FALSE
    )
  ) %>%
  
  addPolygons(
    data=peat,
    color="black",
    fillColor = "#ffa77f",
    fillOpacity = .85,
    weight = 1,
    group="Peat/Topsoil extraction",
    label = "Peat/Topsoil extraction",
    popup = paste0(
      '<b>From <a href="https://www.arcgis.com/home/item.html?id=0279f65b82314121b5b5ec93d76bc6ba">SOLRIS 3.0</a></b>',
      '<br>Extraction - Peat/Topsoil.'
    ),
    highlightOptions = highlightOptions(
      opacity = 1, fillOpacity = 1, weight = 5, sendToBack = FALSE
    )
  ) %>%
  
  addPolygons(
    data=plnt,
    color="black",
    fillColor = "#50b062",
    fillOpacity = .85,
    weight = 1,
    group="Plantations/Tree Cultivation",
    label = "Plantations/Tree Cultivation",
    popup = paste0(
      '<b>From <a href="https://www.arcgis.com/home/item.html?id=0279f65b82314121b5b5ec93d76bc6ba">SOLRIS 3.0</a></b>',
      '<br>Plantations - Tree Cultivated: Tree cover > 60%, (trees > 2m height), linear organization, uniform tree type.'
    ),
    highlightOptions = highlightOptions(
      opacity = 1, fillOpacity = 1, weight = 5, sendToBack = FALSE
    )
  ) %>%
  
  addCircles(
    data=wwis,
    stroke=TRUE,
    color='blueviolet',
    weight=1,
    opacity = .6,
    fillOpacity = .5,
    group="Well Records",
    label = ~paste0("Well ID: ",WELL_ID),
    popup = ~paste0(
      '<b><a href="https://data.ontario.ca/dataset/well-records">MECP Well Records</a></b>',
      '<br>This dataset provides information submitted by well contractors as prescribed by Regulation 903, and is stored in the Water Well Information System (WWIS). Spatial information for all of the well records reported in Ontario are also provided.',
      '<br><br>WWIS well ID: ',WELL_ID,
      '<br>completed: ',COMPLETED,
      '<br>depth: ',DEPTH,
      '<br><a href="https://d2khazk8e83rdv.cloudfront.net/moe_mapping/downloads/2Water/Wells_pdfs/',substr(WELL_ID,start=1,stop=3),'/',WELL_ID,'.pdf">access well record</a>'
    ),
    highlightOptions = highlightOptions(
      opacity = 1, fillOpacity = 1, weight = 5, sendToBack = FALSE
    )
  ) %>%
  
  setView(lng = -79.0, lat = 44.1, zoom = 10) %>%
  
  addLayersControl(
    overlayGroups = c("Pits and Quarries","Well Records","Plantations/Tree Cultivation","Row crops","Peat/Topsoil extraction"),
    position = 'bottomright',
    options = layersControlOptions(collapsed = FALSE)
  ) %>% hideGroup( c("Well Records","Plantations/Tree Cultivation","Row crops","Peat/Topsoil extraction")) %>%
  
  addLogo("logo-transp.png", src= "remote", width = 127)
# addLogo("logoGBF_transp.png", src= "remote", width = 234)

