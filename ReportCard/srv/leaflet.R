
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
    onClick=JS("function(btn, map){map.locate({setView: true}).on('locationfound', function(e){Shiny.setInputValue('locate_easyButton', [e.longitude,e.latitude] )})}"))) %>%
  
  addCircleMarkers(
    data=pwqmn,
    stroke=TRUE,
    color= ~pwqmnPal(STATUS),
    weight=1,
    opacity = .6,
    fillOpacity = .5,
    group="PWQMN",
    label = ~NAME,
    popup = ~paste0(
      '<b>Station Name: ',NAME,'</b>',
      '<br>',DESCRIPTION,
      '<br><br>station ID: ',STATION,
      '<br>status: ',STATUS,
      '<br>dates: ',FIRST_YEAR,'-',LAST_YEAR,
      '<br>years missing: ',MISS_YEARS,
      '<br><a href="https://data.ontario.ca/dataset/provincial-stream-water-quality-monitoring-network">data source</a>'
    ),
  ) %>%
  
  setView(lng = -79.0, lat = 44.1, zoom = 10) %>%
  
  addLegend("topright", 
            data = pwqmn, 
            pal = pwqmnPal, 
            values = ~STATUS,
            title = "Legend"
  ) %>%
  
  # addLayersControl(
  #   overlayGroups = c("PWQMN"),
  #   position = 'bottomright',
  #   options = layersControlOptions(collapsed = FALSE)
  # ) %>% hideGroup( c("Well Records","Plantations/Tree Cultivation","Row crops","Peat/Topsoil extraction")) %>%
  
  addLogo("logo-transp.png", src= "remote", width = 127)
# addLogo("logoGBF_transp.png", src= "remote", width = 234)

