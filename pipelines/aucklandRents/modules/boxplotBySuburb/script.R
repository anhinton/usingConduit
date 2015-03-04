setwd("/home/ahin017/files.fos/openapi/documentation/usingConduit/pipelines/aucklandRents/modules/boxplotBySuburb")
listings <- readRDS("/home/ahin017/files.fos/openapi/documentation/usingConduit/pipelines/aucklandRents/modules/chooseSuburbs/shortListings.rds")
svg("boxplot-rentBySuburb.svg")
boxplot(listings$rent ~ listings$subNames, xlab = "Suburb",
        ylab = "Rent per week ($)", main="Rental prices in Auckland")
dev.off()

