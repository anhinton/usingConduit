rentalListings <- read.csv(rentalListings.csv, header = TRUE)
suburbIDs <- read.csv(suburbIDs.csv, header = TRUE, stringsAsFactors = FALSE)
 
rentalListings$suburb <- as.factor(rentalListings$suburb)
subIDs <- levels(rentalListings$suburb)
subNames <- sapply(subIDs, function(subID) suburbIDs[subID == suburbIDs[,1],2])
levels(rentalListings$suburb) <- subNames
