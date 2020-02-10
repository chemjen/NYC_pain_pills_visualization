

shinyUI(
  dashboardPage(
 ## Header 
    dashboardHeader(title = "NYC Pain Pills Data"),
 ## Sidebar  
    dashboardSidebar(
      sidebarMenu(
        menuItem("Intro", tabName="intro", icon=icon("book-reader")),
        menuItem("Summary Plots", tabName="summary", icon = icon("chart-line")),
        menuItem("Map", tabName = "map", icon = icon("map")),
        menuItem("Charts", tabName = "charts", icon = icon("chart-bar")),
        checkboxGroupInput(inputId = "drugs",
                           label = "Select Drug(s):",
                           choices = c("Hydrocodone" = "HYDROCODONE", "Oxycodone" = "OXYCODONE"),
                           selected="HYDROCODONE"),
        selectizeInput("year", "Select Year", 2006:2014, selected=2010)
        )),
  
  ## Body 
    dashboardBody(
      tabItems(
        tabItem(tabName="intro",
                p("The data presented was obtained from the Washington Post via this site
                  https://www.washingtonpost.com/graphics/2019/investigations/dea-pain-pill-database/."),
                  br(),
                p("This dataset is the DEA's data on oxycodone and hydrocodone (two opioid pain medications in NYC.) 
                Each row is a transaction from a buyer (a pharmacy or practitioner) buying oxycodone or hydrocodone. 
                The pharmacist/practitioner's address, the date of the transaction, the amount of the drug is given. 
                  The amount of the drug can be a bit complicated - the drug does not always take the form of pills, 
                  and pills have different dosages. A convenient descriptor is the MME, or Milligrams of Morphine Equivalent. 
                  Every opioid is given a MME conversion: for hydrocodone it is 1, for oxycodone 1.5. 
                  Therefore 1 mg of oxycodone is equivalent to 1.5 mg of morphine, and 1 mg of hydrocodone is equivalent to 1 mg of 
                  morphine. This allows for the amount of the active ingredient in milligrams to be converted to a standardized MME."), br(),
                p("This app has a 'summary' tab which shows trends over the years -- line plots of how many pills are bought at which doses,
                the MME, the number of pills, and the number of transactions. There are also bar plots of pharmaceutical companies and 
                pharmacies making and buying the most pills."), br(), 
                p("Then there are the 'Map' and 'Charts'' tabs, which show data for a selected year and selected drugs. 
                  The map shows a color plot by zip-code for the number of pills ordered for that zip code, and hovering the mouse over
                  a region tells you how many transactions, the number of pills, and the MME for that zip code on that year. 
                  The charts tab shows plots of data for that year and the drugs selected: the most popular pharmacies and pharmaceutical companies, 
                  histograms of the MME and number of transactions. There's also a bar plot showing the number of pills ordered at different dosages."), 
                br(), p("Github link: https://github.com/chemjen/NYC_pain_pills_visualization.git .")),
        
        tabItem(tabName="summary", 
                fluidRow(box(plotOutput("PharmaTime")),
                         box(plotOutput("ReporterTime"))),
                fluidRow(box(plotOutput("OxyTime")),
                         box(plotOutput("HydroTime"))),
                fluidRow(box(plotOutput("MMEtime")), 
                         box(plotOutput("TransactionsTime")),
                         box(plotOutput("PillsTime")))),
        tabItem(tabName = "map", leafletOutput("mymap")),
        tabItem(tabName = "charts", 
                fluidRow(box(plotOutput("Buyers")), 
                        box(plotOutput("Pharmas"))),
                fluidRow(box(plotOutput("MMEplot")), 
                      box(plotOutput("TransactionsPlot")),
                      box(plotOutput("DoseStrengths")))#,
            #    fluidRow(plotOutput("DoseStrengths"), plotOutput("Buyers"),
            #            plotOutput("Reporters")
        )
     )
    )
  )
)