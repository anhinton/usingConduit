setwd("/home/ahin017/files.fos/openapi/usingConduit/pipelines/simpleGraph/modules/plotGraph")
Ragraph <- readRDS("/home/ahin017/files.fos/openapi/usingConduit/pipelines/simpleGraph/modules/layoutGraph/Ragraph.rds")
library(gridGraphviz)
png("example.png")
grid.graph(Ragraph, newpage=TRUE)
dev.off()

