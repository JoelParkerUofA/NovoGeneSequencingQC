library(data.table)
library(ggplot2)
library(plotly)


metadata <- fread("/Users/joelparker/Desktop/Dashboard/SequencingQC/Data/Metadata.csv")
qc <- fread("/Users/joelparker/Desktop/Dashboard/SequencingQC/Data/QCSummaries.csv")


combined <- merge(metadata, qc, by = "Sample_ID")

# var names
plate <- "Plate"
raw <- "Raw reads"
aoi <- "AOIInfo"
region <- "RegionPooled"


form <- as.formula(paste0(aoi, "~", region))


# Plot
plt <- ggplot(combined, aes(x = !!sym(plate), y = log10(!!sym(raw)))) +
  facet_wrap(vars(!!sym(aoi)) ~ vars(!!sym(region))) +
  geom_point() +
  theme_bw()

plt
