
leaflet() %>%
  
  addTiles(attribution = '<a href="https://stormcoalition.github.io" target="_blank" rel="noopener noreferrer"><b>STORM maps</b></a> | <a href="https://stormcoalition.github.io/sources.html" target="_blank" rel="noopener noreferrer"><b>Source Data</b></a> © <a href="https://www.stormcoalition.com/" target="_blank" rel="noopener noreferrer"><b>Save The Oak Ridges Moraine</b></a>') %>%

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
  
  addPolygons(data = orm, color = 'black', weight=1, fillColor  = "darkorange") %>%

  addPolygons(
    data = CAs,
    color = "darkgreen",
    weight = 2,
    opacity = .5,
    group="Conservation Authorities",
    label = ~LEGAL_NAME,
    popup = ~paste0(
              '<b>', LEGAL_NAME,"</b>"
              ),        
    highlightOptions = highlightOptions(
      opacity = 1, fillOpacity = .65, weight = 5, sendToBack = FALSE
    )
  ) %>%

  addPolygons(
    data = munis,
    color = "darkblue",
    weight = 2,
    opacity = .5,
    fillOpacity = .1,
    group="Municipalities",
    label = ~MUN_NAME,
    popup = ~paste0(
              '<b>', MUN_NAME,"</b>"
              ),    
    highlightOptions = highlightOptions(
      opacity = 1, fillOpacity = .45, weight = 5, sendToBack = FALSE
    )
  ) %>%
  
  addPolygons(
    data = ridings,
    color = "darkred",
    weight = 2,
    opacity = .35,
    group="Member of Provincial Parliament (MPP)",
    label = ~Riding,
    popup = ~paste0(
              '<b>Riding: ', Riding,"</b>",
              '<br>MPP: ', First_name," ",Last_name,
              '<br>email: <a href="mailto:',Email,'">',Email,'</a>',
              '<br>telephone: ', Telephone
              ),
    highlightOptions = highlightOptions(
      opacity = 1, fillOpacity = .65, weight = 5, sendToBack = FALSE
    )
  ) %>%
  
  setView(lng = -79.0, lat = 44.1, zoom = 9) %>%

  addLayersControl(
    baseGroups = c("Member of Provincial Parliament (MPP)", "Municipalities", "Conservation Authorities"), 
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  hideGroup(c("Conservation Authorities", "Municipalities")) %>%
  
  addLogo("https://raw.githubusercontent.com/stormcoalition/shinyapps.io/main/images/logo-transp.png", src= "remote", width = 127)
  # addLogo("logo-transp.png", src= "remote", width = 127)
  # addLogo("logoGBF_transp.png", src= "remote", width = 234)