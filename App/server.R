library(shiny)
library(compositions)
library(data.table)
library(ggplot2)
library(bslib)
library(plotly)
library(DT)

server <- function(input, output, session) {

  # Meta data
  metadata <- reactive({
    req(input$metadata)
    fread(input$metadata$datapath)
  })

  qc <- reactive({
    req(input$qc)
    fread(input$qc$datapath)
  })

  combined <- reactive({
    req(input$metadata)
    req(input$qc)
    req(input$mergeVar)

    merge(metadata(), qc(), by = input$mergeVar)

  })

  ################################
  ## Update select Options
  ################################
  observeEvent({
    qc()  # Trigger when qc() changes
    metadata()  # Trigger when metadata() changes
  }, {
    req(qc())        # Ensure qc() is processed
    req(metadata())  # Ensure metadata() is processed

    # Get variable names common to QC and metadata
    common_vars <- intersect(names(qc()), names(metadata()))

    # Update the select input with the common variable names
    updateSelectInput(
      session,
      inputId = "mergeVar",
      choices = common_vars
    )
  })

  # Here we update all of the selectInputs to be
  # the column names of the combined data set
  observeEvent(combined(), {
    req(combined())
    updateSelectInput(session, inputId = "raw",
                      choices = names(combined()))

    updateSelectInput(session, inputId = "plate",
                      choices = names(combined()))

    updateSelectInput(session, inputId = "region",
                      choices = names(combined()))

    updateSelectInput(session, inputId = "aoi",
                      choices = names(combined()))

    updateSelectInput(session, inputId = "gc",
                      choices = names(combined()))

    updateSelectInput(session, inputId = "nuclei",
                      choices = names(combined()))

    updateSelectInput(session, inputId = "area",
                      choices = names(combined()))


    ## Show data
    output$combinedDT <- renderDT({
      combined()
    })

    output$QCDT <- renderDT(qc())

    output$metaDT <- renderDT(metadata())


  })

  ###############################
  ## update value boxes
  ###############################
  output$nMeta <- renderText({
    req(input$metadata)
    nrow(metadata())
  })

  output$nQC <- renderText({
    req(input$qc)
    nrow(qc())
  })

  output$nCommon <- renderText({
    req(input$qc)
    req(input$metadata)
    req(combined())
    nrow(combined())
  })


  #########################
  ## Create plots
  #########################
  observeEvent(input$createReport, {
    req(combined())

    # Raw Plot
    output$rawPlot <- renderPlotly({

      form <- as.formula(paste0(input$aoi, "~", input$region))
      # Plot
      plt <- ggplot(combined(),
                    aes(x = !!sym(input$plate), y = log10(!!sym(input$raw)),
                        text = paste0("Sample ID: ", !!sym(input$mergeVar), "\n", # nolint: line_length_linter.
                                      "Raw: ", !!sym(input$raw), "\n",
                                      "Plate: ", !!sym(input$plate), "\n",
                                      "AOI: ", !!sym(input$aoi), "\n",
                                      "Region: ", !!sym(input$region)))) +
        facet_wrap(form) +
        geom_point() +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 45))


      ggplotly(plt, tooltip = "text")
    })

    # GC Plot
    output$gcPlot <- renderPlotly({

      form <- as.formula(paste0("~", input$aoi))
      plt <- ggplot(data = combined(),
                    aes(x = !!sym(input$region),
                        y = !!sym(input$gc),
                        colour = !!sym(input$plate),
                        text = paste0("Sample ID: ", !!sym(input$mergeVar), "\n", # nolint: line_length_linter.
                                      "Raw: ", !!sym(input$raw), "\n",
                                      "Plate: ", !!sym(input$plate), "\n",
                                      "AOI: ", !!sym(input$aoi), "\n",
                                      "Region: ", !!sym(input$region)))) +
        geom_point() +
        #geom_line() +
        facet_wrap(form, scales = "free_y") +
        theme_dark() +
        coord_flip()


      ggplotly(plt, tooltip = "text")
    })
    ################
    # Area Plot
    ################
    output$areaPlot <- renderPlotly({
      form <- as.formula(paste0("~", input$aoi))
      plt <- ggplot(data = combined(),
                    aes(x = !!sym(input$region),
                        y = !!sym(input$area),
                        colour = !!sym(input$plate),
                        text = paste0("Sample ID: ", !!sym(input$mergeVar), "\n", # nolint: line_length_linter.
                                      "Raw: ", !!sym(input$raw), "\n",
                                      "Plate: ", !!sym(input$plate), "\n",
                                      "AOI: ", !!sym(input$aoi), "\n",
                                      "Region: ", !!sym(input$region)))) +
        geom_point() +
        #geom_line() +
        facet_wrap(form, scales = "free_y") +
        theme_dark() +
        coord_flip()


    ggplotly(plt, tooltip = "text")
    })


  #####################
  # Nuclei Plot
  #####################
  output$nucleiPlot <- renderPlotly({
    form <- as.formula(paste0("~", input$aoi))
    plt <- ggplot(data = combined(),
                  aes(x = !!sym(input$region),
                      y = !!sym(input$nuclei),
                      colour = !!sym(input$plate),
                      text = paste0("Sample ID: ", !!sym(input$mergeVar), "\n", # nolint: line_length_linter.
                                    "Raw: ", !!sym(input$raw), "\n",
                                    "Plate: ", !!sym(input$plate), "\n",
                                    "AOI: ", !!sym(input$aoi), "\n",
                                    "Region: ", !!sym(input$region)))) +
      geom_point() +
      #geom_line() +
      facet_wrap(form, scales = "free_y") +
      theme_dark() +
      coord_flip()


    ggplotly(plt, tooltip = "text")
  })
})

  ## Centered Log-Ratio
  #output$clrPlot <- renderPlotly({
    #dat <- copy(combined())

    #dat[, clr := log(.SD) - sum(log(.SD)) / .N,
    #    .SDCols = input$raw, by = input$plate]
    #print(dat$clr)

    #rawHeat <- ggplot(receivedNovaCLRRerun ,
    #                  aes(x= WellC, y=WellR, fill=CLR, text=text)) +
    #  geom_tile() +
    #  facet_wrap(~Plate, ncol = 3) +
   #   ggtitle("Centered log-ratio of raw reads by plate.", subtitle = "Heatmap")


   # ggplotly(rawHeat, tooltip = "text")




#})

}
