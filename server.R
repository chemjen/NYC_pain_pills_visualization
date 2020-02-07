library(leaflet)
library(tigris) 
library(tidyverse)

zips = data$BUYER_ZIP
options(tigris_use_cache = TRUE)
char_zips <- zctas(cb = TRUE, starts_with = c("10", "11"))

data_plot = data %>% group_by(BUYER_ZIP) %>%
  summarise(num_transactions=n(), num_pills=sum(DOSAGE_UNIT),
            MME=sum(MME_Conversion_Factor*CALC_BASE_WT_IN_GM))
char_zips <- geo_join(char_zips, 
                      data_plot, 
                      by_sp = "GEOID10", 
                      by_df = "BUYER_ZIP",
                      how = "inner")

pal <- colorNumeric(
  palette = "Greens",
  domain = char_zips@data$num_pills)

labels <- 
  paste0(
    "Zip Code: ",
    char_zips@data$GEOID10, "<br/>",
    "Number of Pills: ",
    char_zips@data$num_pills) %>%
  lapply(htmltools::HTML)

shinyServer(function(input, output) {
  output$mymap <- renderLeaflet({
    char_zips %>% 
      leaflet %>% 
      # add base map
      addProviderTiles("CartoDB") %>% 
      # add zip codes
      addPolygons(fillColor = ~pal(num_pills),
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
                values = ~num_pills, 
                opacity = 0.7, 
                title = htmltools::HTML("Number of pain <br> 
                                    pill purchases <br> 
                                    by Zip Code <br>
                                    2006"),
                position = "bottomright")
    
    
  })
  
  
})


