setwd("/home/ahin017/files.fos/openapi/documentation/usingConduit/pipelines/aucklandRents/modules/chooseSuburbs")
namedListings <- readRDS("/home/ahin017/files.fos/openapi/documentation/usingConduit/pipelines/aucklandRents/modules/nameSuburbs/namedListings.rds")
ofInterest <-
    namedListings$subNames %in% c("Kingsland", "Grey Lynn", "Ponsonby")

shortListings <- namedListings[ofInterest,]
shortListings$subNames <- factor(shortListings$subNames)

saveRDS(shortListings, file="shortListings.rds")
