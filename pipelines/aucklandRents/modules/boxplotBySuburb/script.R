setwd("/home/ahin017/files.fos/openapi/documentation/usingConduit/pipelines/aucklandRents/modules/boxplotBySuburb")
rentalListings <- readRDS("/home/ahin017/files.fos/openapi/documentation/usingConduit/pipelines/aucklandRents/modules/chooseSuburbs/rentalListings.rds")
svg("boxplot-rentBySuburb.svg")
boxplot(rentalListings$rent ~ rentalListings$suburb, xlab = "Suburb",
        ylab = "Rent per week ($)", main="Rental prices in Auckland")
dev.off()

