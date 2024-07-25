
ormcpPal <- colorFactor(
  # c('#7fc97f','#beaed4','#fdc086','#ffff99','#386cb0','#f0027f'),
  c('#BA9157','#DAC79B','#98E600','#8E3328','#C2C2C2','#3FA427'),
  domain = ormcp$LAND_USE_DESIGNATION,
  levels = c("Rural Settlement","Countryside Area","Natural Linkage Area","Palgrave Estates Residential Community","Settlement Area","Natural Core Area")
)

leaflet() %>%
  
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
    onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%

  addPolygons(
    data = ormcp,
    color = "black",
    weight = 2,
    fillColor = ~ormcpPal(LAND_USE_DESIGNATION),
    opacity = .75, 
    group="Show ORMCP Land use Designation",
    label = ~LAND_USE_DESIGNATION,
    popup = ~paste0(
      '<b>Land Use Designation: ', LAND_USE_DESIGNATION,"</b>",
      '<br>', LAND_USE_DESIG_DEFINITION
    ),
    highlightOptions = highlightOptions(
      opacity = 1, fillOpacity =.85, weight = 5, sendToBack = FALSE
    )
  ) %>%

  setView(lng = -79.0, lat = 44.1, zoom = 10) %>%
  addLayersControl(
    # baseGroups = c("OSM", "basemap"),
    overlayGroups = "Show ORMCP Land use Designation",
    position = 'bottomright',
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  
  addLogo("https://raw.githubusercontent.com/stormcoalition/shinyapps.io/main/images/logo-transp.png", src= "remote", width = 127)
  # addLogo("logo-transp.png", src= "remote", width = 127)
  # addLogo("logoGBF_transp.png", src= "remote", width = 234)