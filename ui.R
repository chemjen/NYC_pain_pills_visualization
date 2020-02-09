shinyUI(
  dashboardPage(
 ## Header 
    dashboardHeader(title = "NYC Pain Pills Data"),
 ## Sidebar  
    dashboardSidebar(
      sidebarMenu(
        menuItem("Map", tabName = "map", icon = icon("map")),
        
        menuItem("Charts", tabName = "charts", icon = icon("chart-bar")),
        checkboxGroupInput(inputId = "drugs",
                           label = "Select Drug(s):",
                           choices = c("Hydrocodone" = "HYDROCODONE", "Oxycodone" = "OXYCODONE"),
                           selected="HYDROCODONE"),
        selectizeInput("year", "Select Year", years, selected=2010)
       )),
  
  ## Body 
    dashboardBody(
      tabItems(
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