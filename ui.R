shinyUI(
  dashboardPage(
 ## Header 
    dashboardHeader(title = "NYC Pain Pills Data"),
 ## Sidebar  
    dashboardSidebar(
      sidebarMenu(
        menuItem("Map", tabName = "map", icon = icon("map")),
        menuItem("Data", tabName = "data", icon = icon("database")),
#        selectizeInput("drugname",
#                      "Select Drug",
#                       drugs,
#                       selected="hydrocodone"),
        selectizeInput("year",
                       "Select Year",
                       years,
                       selected=2010)
        )
       ),
    
  ## Body 
    dashboardBody(
      tabItems(
        tabItem(tabName = "map", leafletOutput("mymap")),
        tabItem(tabName = "data", 
                fluidRow(box(DT::dataTableOutput("mytable"), width = 12)))
        )
     )
    )
  )