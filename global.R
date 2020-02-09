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

years=2006:2014

summarised_drugs <- read.csv("summarised_data.csv")

summarised_reporters <- read.csv("major_drug_buyers.csv")

summarised_pharmas <- read.csv("major_pharma_companies.csv")

dose_strengths <- read.csv("dose_strengths.csv")

dose_strengths$dose_strength = as.factor(dose_strengths$dos_str)


