setwd("/home/ahin017/files.fos/openapi/documentation/usingConduit/pipelines/aucklandRents/modules/nameSuburbs")
rentalListings.csv <- "/home/ahin017/files.fos/openapi/documentation/usingConduit/aucklandRents/data/rentalListings.csv"
suburbIDs.csv <- "/home/ahin017/files.fos/openapi/documentation/usingConduit/aucklandRents/data/suburbIDs.csv"
rentalListings <- read.csv(rentalListings.csv, header = TRUE)
suburbIDs <- read.csv(suburbIDs.csv, header = TRUE, stringsAsFactors = FALSE)

namedListings <- merge(x = rentalListings, y = suburbIDs,
                       by.x = "suburb", by.y = "subIDs")
saveRDS(namedListings, file="namedListings.rds")
