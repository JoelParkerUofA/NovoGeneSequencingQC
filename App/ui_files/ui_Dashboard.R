###
## This is to set up the load data page
##

ui_dashboard <- nav_panel(
  title = "Dashboard",


  card(
    card_header("Data Loading"),
    fluidRow(
      column(3, fileInput("metadata", "Load Metadata")),
      column(3, fileInput("qc", "Load QC Data")),
      column(3, selectInput("mergeVar", "Select Linking Variable",
                            choices = NULL))
    ), fill = FALSE
  ),
  h1("Sample Accounting"),
  'Checking the number of samples (rows)
   in the metadata and quality control data. The "Samples for QC" shows
   the number of samples that were matched via the "linking" variable and
   represents the number of samples for downstream analysis.',
  fluidRow(
    column(3, value_box(title = "Metadata Samples",
                        value = uiOutput("nMeta"), theme = "blue")),
    column(3, value_box(title = "QC Samples",
                        value = uiOutput("nQC"), theme = "blue")),
    column(3, value_box(title = "Samples For QC",
                        value = uiOutput("nCommon"), theme = "blue"))
  ),

  # Display data
  fluidRow(
    column(12,
      navset_card_tab(
        nav_panel(
          title = "Metadata",
          dataTableOutput("metaDT")
        ),
        nav_panel(
          title = "QC Data",
          dataTableOutput("QCDT")
        ),
        nav_panel(
          title = "Combined",
          dataTableOutput("combinedDT")
        )
      )
    )
  ),

  # Select Variables
  card(
    card_header("Select Variables"),
    "Select variables to generate dashboard",
    fluidRow(
      column(3, selectInput("raw", "Select Raw Reads Variable",
                            choices = "Raw reads")),
      column(3, selectInput("plate", "Select Plate Variable",
                            choices = "Plate")),
      column(3, selectInput("region", "Select Region Variable",
                            choices = "Region")),
      column(3, selectInput("aoi", "Select AOI",
                            choices = "AOI")),
      column(3, selectInput("gc", "Select GC% Variable",
                            choices = "GC%")),
      column(3, selectInput("nuclei", "Select Nuclei Variable",
                            choices = "Nuclei")),
      column(3, selectInput("area", "Select Tissue Area Variable",
                            choices = "area")),
      column(3, selectInput("wellRow", "Well Row",
                            choices = "WellR")),
      column(3, selectInput("wellCol", "Well Column",
                            choices = "wellC")),
      column(3, actionButton("createReport", "Generate Report"))

    ), fill = FALSE
  ),

  h1("Sequencing QC Dashboard"),

  fluidRow(
    column(12,
      navset_card_tab(
        tabPanel(
          title = "Raw",
          plotlyOutput("rawPlot")
        )
      )
    )
  ),

#  card(
#    card_header("Raw Reads By Plate"),
#    plotlyOutput("rawPlot"),
#    full_screen = TRUE,
#    fill = FALSE
#  ),

  card(
    card_header("Centered Log Ratio By Plate"),
    plotlyOutput("clrPlot"),
    full_screen = TRUE,
    fill = FALSE
  ),

  card(
    card_header("GC %"),
    plotlyOutput("gcPlot"),
    full_screen = TRUE,
    fill = FALSE
  ),

  card(
    card_header("Nuclei"),
    plotlyOutput("nucleiPlot"),
    full_screen = TRUE,
    fill = FALSE
  ),

  card(
    card_header("Tissue Area"),
    plotlyOutput("areaPlot"),
    full_screen = TRUE,
    fill = FALSE
  )
)
