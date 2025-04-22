# Create the function for the QC plots
QCPlots <- function(data,X,Y,colour,tex,...){
  
  # Create plot
  g = ggplot(data = data, aes(x={{X}},y={{Y}}, colour = {{colour}},text={{tex}})) +
    geom_point() +
    #geom_line() +
    facet_wrap(...,nrow = 4) +
    theme_dark() +
    coord_flip() +
    theme(axis.text.x  = element_text(angle = 90))
  
  return(g)
  
}