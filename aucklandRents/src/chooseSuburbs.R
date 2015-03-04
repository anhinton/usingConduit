ofInterest <-
    namedListings$subNames %in% c("Kingsland", "Grey Lynn", "Ponsonby")

shortListings <- namedListings[ofInterest,]
shortListings$subNames <- factor(shortListings$subNames)

