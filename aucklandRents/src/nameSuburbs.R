rentalListings <- read.csv(rentalListings.csv, header = TRUE)
suburbIDs <- read.csv(suburbIDs.csv, header = TRUE, stringsAsFactors = FALSE)

namedListings <- merge(x = rentalListings, y = suburbIDs,
                       by.x = "suburb", by.y = "subIDs")
