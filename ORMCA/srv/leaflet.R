
ormcp <- readOGR("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation.geojson")

ormcpPal <- colorFactor(
  c('#7fc97f','#beaed4','#fdc086','#ffff99','#386cb0','#f0027f'),
  domain = ormcp@data$LAND_USE_DESIGNATION
)

output$map <- renderLeaflet({
  # ormcp <- readOGR("https://raw.githubusercontent.com/stormcoalition/geojson/main/Oak_Ridges_Moraine_(ORM)_Land_Use_Designation.geojson")
  # nhsa <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/NHSAREA-simplified.geojson") %>% paste(collapse = "\n")
  # grnblt <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/GREENBELT_DESIGNATION-simplified-2022.geojson") %>% paste(collapse = "\n")
  # bua <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/BUILT_UP_AREA-simplified.geojson") %>% paste(collapse = "\n")
  # wetlnds <- readLines("https://raw.githubusercontent.com/stormcoalition/geojson/main/wetlands-simplified.geojson") %>% paste(collapse = "\n")
  # ridings <- readOGR("https://raw.githubusercontent.com/stormcoalition/geojson/main/ELECTORAL_DISTRICT_STORM.geojson")
  # CAs <- readOGR("https://raw.githubusercontent.com/stormcoalition/geojson/main/CONS_AUTH_ADMIN_AREA_STORM.geojson")
  # munis <- readOGR("https://raw.githubusercontent.com/stormcoalition/geojson/main/MUNIC_BND_ALL_STORM.geojson")
  # pits <- readOGR("https://raw.githubusercontent.com/stormcoalition/geojson/main/AGGSITE_AUTHORIZED_STORM.geojson")
  
  # munis <- geojson_read("https://raw.githubusercontent.com/stormcoalition/geojson/main/MUNIC_BND_ALL_STORM.geojson", what = "sp")
  # neword <- order(-munis@data$area)  # set order
  # munis@polygons <- munis@polygons[neword]
  # munis@plotOrder <- neword
  # munis@data <- munis@data %>% arrange(-area)
  
  # add.1 <- readOGR("https://raw.githubusercontent.com/stormcoalition/geojson/main/Proposed-Greenbelt-modifications.geojson")
  
  # # gs4_auth(email = "mason.marchildon@gmail.com")
  # loi <- read_sheet('https://docs.google.com/spreadsheets/d/1l0vin4jgMKQgqMeEefEAIsMDQZ614mx0rnN-8C8Auao/edit#gid=0', sheet = 'GIS-Coordinates')

  
  # pitsPal <- colorFactor(
  #   c('#7fc97f','#f0027f','#beaed4','grey40'),
  #   domain = pits@data$STATUS
  # )

  leaflet(ormcp) %>%
    
    addTiles(attribution = '<a href="https://stormcoalition.github.io/sources.html" target="_blank" rel="noopener noreferrer"><b>META DATA</b></a> | © <a href="https://www.stormcoalition.com/" target="_blank" rel="noopener noreferrer"><b>Save The Oak Ridges Moraine</b></a>') %>%
    
    addTiles() %>%
    # addProviderTiles(providers$OpenTopoMap, group='Topo', options = providerTileOptions(attribution=" Map data: © OpenStreetMap contributors, SRTM | Map style: © OpenTopoMap (CC-BY-SA) | Save The Oak Ridges Moraine")) %>%
    # addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite", options = providerTileOptions(attribution=" Map tiles by Stamen Design, CC BY 3.0 — Map data © OpenStreetMap contributors | Save The Oak Ridges Moraine")) %>%    
    addTiles("http://99.249.44.21:8080/ORMbasemap/{z}/{x}/{y}", options = providerTileOptions(attribution=" © Save The Oak Ridges Moraine")) %>%
    
    # addTiles(attribution = '<a href="https://www.stormcoalition.com/" target="_blank" rel="noopener noreferrer"><b>Save The Oak Ridges Moraine</b></a>') %>%
    
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
    
    # addGeoJSON(bua, weight = 3, color = "darkred", stroke = FALSE, fillOpacity = 0.35, group="Built-up areas") %>%
    # addGeoJSON(grnblt, weight = 3, color = "green", stroke = FALSE, fillOpacity = 0.35, group="Greenbelt") %>%
    # addGeoJSON(wetlnds, weight = 3, color = "darkgreen", stroke = FALSE, fillOpacity = 0.35, group="Wetlands") %>%
    # addGeoJSON(nhsa, weight = 3, color = "blue", stroke = FALSE, fillOpacity = 0.35, group="Natural heritage systems") %>%    
  
    addPolygons(
      color = "black",
      weight = 2,
      fillColor = ~ormcpPal(LAND_USE_DESIGNATION),
      opacity = .5, 
      group="Show Land use Designation",
      label = ~LAND_USE_DESIGNATION,
      popup = ~paste0(
        '<b>Land Use Designation: ', LAND_USE_DESIGNATION,"</b>",
        '<br>Effective: ', as.Date(EFFECTIVE_DATETIME)
      ),
      highlightOptions = highlightOptions(
        opacity = 1, fillOpacity =.8, weight = 5, sendToBack = FALSE
      )
    ) %>%
    
    # addPolygons(
    #   data = CAs,
    #   color = "darkgreen",
    #   weight = 2,
    #   opacity = .5, 
    #   group="Conservation Authorities",
    #   label = ~LEGAL_NAME,
    #   highlightOptions = highlightOptions(
    #     opacity = 1, fillOpacity =1, weight = 5, sendToBack = FALSE
    #   )
    # ) %>%
    
    # addPolygons(
    #   data = munis,
    #   color = "darkorange",
    #   weight = 2,
    #   opacity = .5, 
    #   fillOpacity = .4,
    #   group="Municipalities",
    #   label = ~MUN_NAME,
    #   highlightOptions = highlightOptions(
    #     opacity = 1, fillOpacity =1, weight = 5, sendToBack = FALSE
    #   )
    # ) %>%
    
    # addPolygons(
    #   data = pits,
    #   fillColor = ~pitsPal(STATUS), #"grey40",
    #   fillOpacity = 1,
    #   weight = 2,
    #   group="Pits and Quarries",
    #   label = ~CL_NAME,
    #   popup = ~paste0(
    #     '<b>Name: ', CL_NAME,"</b>",
    #     '<br>Status: ', STATUS,
    #     '<br>Type: ', AUTH_TYPE,
    #     '<br>Depth: ', WATER_STAT,
    #     '<br>Limit: ', MAX_TN_LMT, "t"
    #   ),
    #   highlightOptions = highlightOptions(
    #     opacity = 1, fillOpacity =1, weight = 5, sendToBack = FALSE
    #   )
    # ) %>%
    
    # addPolygons(
    #   data = ridings,
    #   color = "darkred",
    #   weight = 2,
    #   opacity = .35, 
    #   group="Member of Provincial Parliament (MPP)",
    #   label = ~Riding,
    #   popup = ~paste0(
    #             '<b>Riding: ', Riding,"</b>",
    #             '<br>MPP: ', First_name," ",Last_name,
    #             '<br>email: <a href="mailto:',Email,'">',Email,'</a>',
    #             '<br>telephone: ', Telephone
    #             ),
    #   highlightOptions = highlightOptions(
    #     opacity = 1, fillOpacity =1, weight = 5, sendToBack = FALSE
    #   )
    # ) %>%


    # addPolygons(data=add.1,
    #             weight = 8,
    #             color="red",
    #             fillColor = "cyan",
    #             fillOpacity = 0.75,
    #             label = ~paste0('Proposed ', current,' redesignation (click me)'),
    #             popup = ~paste0('<b>Existing land use (<a href="https://geohub.lio.gov.on.ca/documents/southern-ontario-land-resource-information-system-solris-3-0/about" target="_blank" rel="noopener noreferrer">SOLRIS v3.0</a>','):</b>',
    #                             '<br>Agriculture cover: ', agriculture,
    #                             '<br>Forest cover: ', forest,
    #                             '<br><br><b>Map layer coverage:</b>',
    #                             '<br><a href="https://geohub.lio.gov.on.ca/datasets/lio::natural-heritage-system-area/about/" target="_blank" rel="noopener noreferrer">Natural Heritage: </a>', NHS,
    #                             '<br><a href="https://geohub.lio.gov.on.ca/datasets/mnrf::wetlands/about" target="_blank" rel="noopener noreferrer">Wetlands: </a>', wetland,
    #                             '<br><em>(click links for source reference)</em>'
    #                             ),
    #             group = "ORM Land use",
    #             highlightOptions = highlightOptions(
    #               opacity = 1, fillOpacity =1, weight = 5, sendToBack = FALSE
    #             )
    # ) %>%
    
    # addMarkers(data=loi,lng=~long,lat=~lat, label = ~description, popup = ~description_long) %>%
      
    # addLegend("topright", pal = ormcpPal, values = ~LAND_USE_DESIGNATION,
    #           title = "Oak Ridges Moraine<br>Land Use Designation",
    #           opacity = 1
    # ) %>%
    setView(lng = -79.0, lat = 44.1, zoom = 10) %>%
    addLayersControl(
      # baseGroups = c("OSM", "basemap"),
      overlayGroups = "Show Land use Designation",
      position = 'bottomright',
      options = layersControlOptions(collapsed = FALSE)
    )
  
    # addLayersControl (
    #   baseGroups = c("OSM", "Topo", "basemap"), # "Toner Lite"),
    #   overlayGroups = c("ORM Land use", 
    #                     # "Greenbelt", 
    #                     # "Built-up areas", 
    #                     # "Wetlands", 
    #                     # "Natural heritage systems",
    #                     # "Pits and Quarries",
    #                     # "Municipalities",
    #                     # "Conservation Authorities",
    #                     # "Member of Provincial Parliament (MPP)"
    #                     ),
    #   options = layersControlOptions(collapsed = FALSE)) #position = "bottomleft")
    #  %>% hideGroup(c("Greenbelt", 
    #                   "Built-up areas", 
    #                   "Wetlands",
    #                   "Natural heritage systems",
    #                   "Pits and Quarries",
    #                   "Municipalities",
    #                   "Conservation Authorities",
    #                   "Member of Provincial Parliament (MPP)"))

})


observe({
  leafletProxy("map") %>% clearPopups()
  event <- input$map_click
  if (is.null(event)) return()
  lat <- round(event$lat, 4)
  lng <- round(event$lng, 4)
  leafletProxy("map") %>% addPopups(event$lng,event$lat,paste0(lat, ',', lng))
})


observe({
  map <- leafletProxy("map") %>% clearControls()
  if (!is.null(input$map_groups) ) {
    if (input$map_groups == 'Show Land use Designation') {
      map <- map %>%
        # addLegend("bottomleft", pal = ormcpPal, values = ~ormcp$LAND_USE_DESIGNATION,
        #           title = "Oak Ridges Moraine<br>Land Use Designation",
        #           opacity = 1
        # )
        addLegend( #code for gdp legend
          layerId = "lormcp",
          # values=~ormcp@data$LAND_USE_DESIGNATION,
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