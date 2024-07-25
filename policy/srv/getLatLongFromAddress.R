

observeEvent(input$baddr, {
  isolate(
    if( input$taddr != "search address..."){
      lat_longs <- getLatLongFromAddress(input$taddr, c(43.5,44.3,-80.2,-77.9))
      print(paste0("result: ",lat_longs$latitude, " ", lat_longs$longitude))

      if(nrow(lat_longs)>0){
        leafletProxy("mapPolicy") %>%
          clearMarkers() %>% 
          addMarkers(lng = lat_longs$longitude, lat = lat_longs$latitude) %>%
          setView(lat_longs$longitude, lat_longs$latitude, zoom = 16)          
      } else {
        showNotification("Address not found. Please re-enter address (may need to be more specific).",type="warning")
      }
    }
  )
})