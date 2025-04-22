###
## This is to set up the load data page
##

ui_dashboard <- nav_panel(
  title = "Dashboard",
  fluidRow(
    column(3, fileInput("metadata", "Load Metadata")),
    column(3, fileInput("qc", "Load QC Data")),
    column(3, selectInput("mergeVar", "Select Linking Variable",
                          choices = NULL)),
    column(3, actionButton("createReport", "Generate Report"))
  ),
  h1("Sample Accounting"),

  fluidRow(
    column(3, value_box(title = "Metadata Samples",
                        value = uiOutput("nMeta"), theme = "blue")),
    column(3, value_box(title = "QC Samples",
                        value = uiOutput("nQC"), theme = "blue")),
    column(3, value_box(title = "Samples In Common",
                        value = uiOutput("nCommon"), theme = "blue"))
  ),


  h1("Sequencing QC"),

  card(
    card_header("Raw Reads By Plate"),
    fluidRow(
      column(3, selectInput("raw", "Select Raw Reads Variable",
                            choices = NULL)),
      column(3, selectInput("plate", "Select Plate Variable",
                            choices = NULL)),
      column(3, selectInput("region", "Select Region Variable",
                            choices = NULL)),
      column(3, selectInput("aoi", "Select AOI",
                            choices = NULL))
    ),
    plotlyOutput("rawPlot"),
    full_screen = TRUE,
    fill = FALSE
  ),

  card(
    card_header("Centered Log Ratio By Plate"),
    plotlyOutput("clrPlot"),
    full_screen = TRUE,
    fill = FALSE
  ),

  card(
    card_header("GC %"), 
    selectInput("gc", "Select GC% Variable",
                choices = NULL),
    plotlyOutput("gcPlot"),
    full_screen = TRUE,
    fill = FALSE
  ),

  card(
    card_header("Nuclei"), 
    selectInput("nuclei", "Select Nuclei Variable",
                choices = NULL),
    plotlyOutput("nucleiPlot"),
    full_screen = TRUE,
    fill = FALSE
  ),

  card(
    card_header("Tissue Area"), 
    selectInput("area", "Select Tissue Area Variable",
                choices = NULL),
    plotlyOutput("areaPlot"),
    full_screen = TRUE,
    fill = FALSE
  )
)