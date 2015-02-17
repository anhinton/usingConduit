setwd("/home/ahin017/files.fos/openapi/documentation/usingConduit/pipelines/aucklandRents/modules/chooseSuburbs")
rentalListings <- readRDS("/home/ahin017/files.fos/openapi/documentation/usingConduit/pipelines/aucklandRents/modules/nameSuburbs/rentalListings.rds")
inKingsland <- rentalListings$suburb == "Kingsland"
inGreyLynn <- rentalListings$suburb == "Grey Lynn"
inPonsonby <- rentalListings$suburb == "Ponsonby"

ofInterest <- inKingsland | inGreyLynn | inPonsonby

rentalListings <- rentalListings[ofInterest,]
rentalListings$suburb <- factor(rentalListings$suburb)

saveRDS(rentalListings, file="rentalListings.rds")
