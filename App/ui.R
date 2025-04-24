library(shiny)
library(bslib)
library(data.table)
library(compositions)
library(plotly)
library(shinythemes)
library(DT)

source("ui_files/ui_about.R")
source("ui_files/ui_Dashboard.R")

ui <- page_navbar(
  title = "Sequencing QC",
  ui_about,
  ui_dashboard,
  theme =  bs_theme(version = 5, bootswatch = "shiny", secondary = "gray")
)
