svg("boxplot-rentBySuburb.svg")
boxplot(rentalListings$rent ~ rentalListings$suburb, xlab = "Suburb",
        ylab = "Rent per week ($)", main="Rental prices in Auckland")
dev.off()
