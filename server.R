library(leaflet)
library(tigris) 
library(tidyverse)
data = read.csv('./NYC2014.csv')
#head(data)

zips = data$BUYER_ZIP

options(tigris_use_cache = TRUE)
char_zips <- zctas(cb = TRUE, starts_with = c("10", "11"))

num_events = data %>% group_by(BUYER_ZIP) %>%
  summarise(count=n())
char_zips <- geo_join(char_zips, 
                      num_events, 
                      by_sp = "GEOID10", 
                      by_df = "BUYER_ZIP",
                      how = "inner")

pal <- colorNumeric(
  palette = "Greens",
  domain = char_zips@data$count)


labels <- 
  paste0(
    "Zip Code: ",
    char_zips@data$GEOID10, "<br/>",
    "Number of Events: ",
    char_zips@data$count) %>%
  lapply(htmltools::HTML)

shinyServer(function(input, output) {
  output$mymap <- renderLeaflet({
    char_zips %>% 
      leaflet %>% 
      # add base map
      addProviderTiles("CartoDB") %>% 
      # add zip codes
      addPolygons(fillColor = ~pal(count),
                  weight = 2,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = 0.7,
                  highlight = highlightOptions(weight = 2,
                                               color = "#666",
                                               dashArray = "",
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = labels) %>%
      # add legend
      addLegend(pal = pal, 
                values = ~count, 
                opacity = 0.7, 
                title = htmltools::HTML("Number of pain <br> 
                                    pill purchases <br> 
                                    by Zip Code <br>
                                    2006"),
                position = "bottomright")
    
    
  })
  
  
})


