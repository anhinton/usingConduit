inKingsland <- rentalListings$suburb == "Kingsland"
inGreyLynn <- rentalListings$suburb == "Grey Lynn"
inPonsonby <- rentalListings$suburb == "Ponsonby"

ofInterest <- inKingsland | inGreyLynn | inPonsonby

rentalListings <- rentalListings[ofInterest,]
rentalListings$suburb <- factor(rentalListings$suburb)

