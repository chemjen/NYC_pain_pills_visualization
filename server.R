

summarised_drugs <- read.csv("summarised_data.csv")

summarised_reporters <- read.csv("major_drug_buyers.csv")

summarised_pharmas <- read.csv("major_pharma_companies.csv")

dose_strengths <- read.csv("dose_strengths.csv")

dose_strengths$dose_strength = as.factor(dose_strengths$dos_str)

options(tigris_use_cache = TRUE)
char_zips <- zctas(cb = TRUE, starts_with = c("10", "11"))

shinyServer(function(input, output) {
  output$MMEtime <- renderPlot(
    summarised_drugs %>% ggplot(aes(x=year,y=MME)) + 
      geom_line(aes(color=DRUG_NAME)) 
  )
  output$TransactionsTime <- renderPlot(
    summarised_drugs %>% ggplot(aes(x=year,y=num_transactions)) +
      geom_line(aes(color=DRUG_NAME)) + ylab("Number of Purchases")
  )
  
  output$PillsTime <- renderPlot(
    summarised_drugs %>% ggplot(aes(x=year,y=num_pills)) +
      geom_line(aes(color=DRUG_NAME)) + ylab("Number of Pills")
  )
  
  output$ReporterTime <- renderPlot(
    summarised_reporters %>% ggplot(aes(x=year, y=MME)) + 
      geom_line(aes(color=Buyer)) +
      facet_wrap(~ DRUG_NAME, scales="free", nrow=2, ncol=1)
  )

  output$PharmaTime <- renderPlot(
    summarised_pharmas %>% ggplot(aes(x=year, y=MME)) + 
      geom_line(aes(color=Pharma_Company)) + 
      facet_wrap(~ DRUG_NAME, scales="free", nrow=2, ncol=1)
  )
  
  data_year <- reactive({
    fname <- paste0("NYC", input$year, ".csv")
    read.csv(fname) %>% filter(., DRUG_NAME %in% input$drugs)
  })
  
  data_zips <- reactive({
    data_plot = data_year() %>%
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
  
  output$Buyers <- renderPlot(
    data_year() %>% group_by(Reporter_family) %>% summarise(num_transactions=n()) %>% 
      arrange(desc(num_transactions)) %>% head(10) %>% 
      ggplot(aes(x=Reporter_family, y=num_transactions)) + geom_col() +
      theme(axis.text.x = element_text(angle = 90)) + xlab("Drug Buyer") +
      ylab("Number of Transactions")
    
  )
  
  output$Pharmas <- renderPlot(
    data_year() %>% group_by(Combined_Labeler_Name) %>% 
      summarise(num_transactions=n()) %>% 
      arrange(desc(num_transactions)) %>% head(10) %>% 
      ggplot(aes(x=Combined_Labeler_Name, y=num_transactions)) + geom_col() +
      theme(axis.text.x = element_text(angle = 90)) + xlab("Pharma Company") +
      ylab("Number of Transactions")
    
  )
  
  output$OxyTime <- renderPlot(
    dose_strengths %>% filter(., DRUG_NAME=="OXYCODONE") %>%
      ggplot(aes(x=year,y=count)) + geom_line(aes(color=dose_strength)) +
      ylab("Order Count") + ggtitle("Oxycodone")
  )
  
output$HydroTime <- renderPlot(
  dose_strengths %>% filter(., DRUG_NAME=="HYDROCODONE") %>%
    ggplot(aes(x=year,y=count)) + geom_line(aes(color=dose_strength)) +
    ylab("Order Count") + ggtitle("Hydrocodone")
)
  
  output$MMEplot <- renderPlot(
    data_zips()@data %>%  ggplot(aes(x=MME)) + geom_histogram(bins=30) +
      xlab("MME / Zip Code")
    #  geom_col() + xlab("zip code") + theme(axis.text.x = element_text(angle = 90))
  )
  output$TransactionsPlot <- renderPlot(
    data_zips()@data %>% ggplot(aes(x=num_transactions)) + 
      geom_histogram(bins=30) + xlab("Number of Transactions / Zip Code")
  )
  output$DoseStrengths <- renderPlot(
    data_year() %>% ggplot(aes(x=dos_str)) + geom_bar() +
      facet_wrap(~ DRUG_NAME, scales="free") + xlab("Dose Strength (mg)")
  )
  
})


