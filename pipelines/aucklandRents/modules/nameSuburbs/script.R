setwd("/home/ahin017/files.fos/openapi/documentation/usingConduit/pipelines/aucklandRents/modules/nameSuburbs")
rentalListings.csv <- "/home/ahin017/files.fos/openapi/documentation/usingConduit/aucklandRents/data/rentalListings.csv"
suburbIDs.csv <- "/home/ahin017/files.fos/openapi/documentation/usingConduit/aucklandRents/data/suburbIDs.csv"
rentalListings <- read.csv(rentalListings.csv, header = TRUE)
suburbIDs <- read.csv(suburbIDs.csv, header = TRUE, stringsAsFactors = FALSE)
 
rentalListings$suburb <- as.factor(rentalListings$suburb)
subIDs <- levels(rentalListings$suburb)
subNames <- sapply(subIDs, function(subID) suburbIDs[subID == suburbIDs[,1],2])
levels(rentalListings$suburb) <- subNames
saveRDS(rentalListings, file="rentalListings.rds")
