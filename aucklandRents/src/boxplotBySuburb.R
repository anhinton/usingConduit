svg("boxplot-rentBySuburb.svg")
boxplot(listings$rent ~ listings$subNames, xlab = "Suburb",
        ylab = "Rent per week ($)", main="Rental prices in Auckland")
dev.off()
