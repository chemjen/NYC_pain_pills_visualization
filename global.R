library(leaflet)
library(tigris) 
library(tidyverse)
library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(shinydashboard)
library(DT)

data = read.csv('NYC_clean.csv')

drugs = c("hydrocodone", "oxycodone") #, "both")

years = sort(unique(lubridate::year(data$TRANSACTION_DATE)))
