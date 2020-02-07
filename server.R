library(leaflet)
library(tigris) 
library(tidyverse)

zips = data$BUYER_ZIP
options(tigris_use_cache = TRUE)
char_zips <- zctas(cb = TRUE, starts_with = c("10", "11"))

data_plot = data %>% group_by(BUYER_ZIP) %>%
  summarise(num_transactions=n(), num_pills=sum(DOSAGE_UNIT),
            MME=sum(MME_Conversion_Factor*CALC_BASE_WT_IN_GM))

shinyServer(function(input, output) {
  data_zips <- reactive({
    data_plot = data %>% 
      filter(., lubridate::year(data$TRANSACTION_DATE)==input$year,
             DRUG_NAME %in% input$drugs) %>% 
      group_by(BUYER_ZIP) %>%
      summarise(num_transactions=n(), num_pills=sum(DOSAGE_UNIT),
                MME=sum(MME_Conversion_Factor*CALC_BASE_WT_IN_GM))
   geo_join(char_zips, 
                 data_plot, 
                 by_sp = "GEOID10", 
                 by_df = "BUYER_ZIP",
                 how = "inner")  
  })
  
  output$mymap <- renderLeaflet({
    pal <- colorNumeric(
      palette = "Greens",
      domain = data_zips()@data$num_pills)
    labels <- 
      paste0(
        "Zip Code: ",
        char_zips@data$GEOID10, "<br/>",
        "Number of Transactions: ",
        as.character(data_zips()@data$num_transactions), "<br/>",
        "Number of Pills: ",
        as.character(data_zips()@data$num_pills), "<br/>",
        "MME: ", as.character(data_zips()@data$MME)) %>%
      lapply(htmltools::HTML)
    
    data_zips() %>% 
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
                title = htmltools::HTML(paste0("Pain Pills <br> 
                                    by Zip Code <br>", as.character(input$year))),
                position = "bottomright")
  })
  
  output$MMEplot <- renderPlot(
    data_zips()@data %>%  ggplot(aes(x=MME)) + geom_histogram(bins=30)
    #  geom_col() + xlab("zip code") + theme(axis.text.x = element_text(angle = 90))
  )
  output$TransactionsPlot <- renderPlot(
    data_zips()@data %>% ggplot(aes(x=num_transactions)) + geom_histogram(bins=30)
  )
  
  
})


