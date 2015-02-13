library(conduit)
scripts <- "~/files.fos/openapi/scripts/aucklandRents"

## MODULE: rentalListings
rentalListings <-
    module(name = "rentalListings", platform = "R",
           description = "load rentalListings.csv into session",
           outputs = list(
               moduleOutput(name = "rentalListings.csv", type = "external",
                            format = "CSV file",
                            ref = file.path(scripts, "data/rentalListings.csv"))))

## MODULE: suburbIDs
suburbIDs <-
    module("suburbIDs", "R", "load suburbIDs.csv into session",
           outputs = list(
               moduleOutput("suburbIDs.csv", "external", "CSV file",
                            ref = file.path(scripts, "data/suburbIDs.csv"))))

## PIPE: pipe1
pipe1 <- pipe("rentalListings", "rentalListings.csv",
              "nameSuburbs", "rentalListings.csv")
pipe2 <- pipe("suburbIDs", "suburbIDs.csv",
              "nameSuburbs", "suburbIDs.csv")

## MODULE: nameSuburbs
nameSuburbs <-
    module(name = "nameSuburbs", platform = "R",
           description = "name suburbs in rentalListings.csv using key in suburbIDs.csv",
           inputs = list(
               moduleInput("rentalListings.csv", "external", "CSV file"),
               moduleInput("suburbIDs.csv", "external", "CSV file")),
           sources = list(
               moduleSource(ref = file.path(scripts, "src/nameSuburbs.R"))),
           outputs=list(
               moduleOutput("rentalListings", "internal", "R data frame")))

pipe3 <- pipe("nameSuburbs", "rentalListings",
              "chooseSuburbs", "rentalListings")

## MODULE: chooseSuburbs
chooseSuburbs <-
    module(name = "chooseSuburbs", platform = "R",
           description = "produces a data frame of rent prices for the named suburbs",
           inputs = list(
               moduleInput("rentalListings", "internal", "R data frame")),
           sources = list(
               moduleSource(ref = file.path(scripts, "src/chooseSuburbs.R"))),
           outputs = list(
               moduleOutput("rentalListings", "internal", "R data frame")))

pipe4 <- pipe("chooseSuburbs", "rentalListings",
              "boxplotBySuburb", "rentalListings")

## MODULE: boxplotBySuburb
boxplotBySuburb <-
    module("boxplotBySuburb", platform="R",
           inputs=list(
               moduleInput("rentalListings", "internal", "R data frame")),
           sources=list(
               moduleSource(ref=file.path(scripts, "src/boxplotBySuburb.R"))),
           outputs=list(
               moduleOutput("boxplot-rentBySuburb.png", "external",
                            ref="boxplot-rentBySuburb.png")))

aucklandRents <- pipeline("aucklandRents",
    components = list(rentalListings = rentalListings,
        nameSuburbs = nameSuburbs, suburbIDs = suburbIDs,
        chooseSuburbs = chooseSuburbs, boxplotBySuburb=boxplotBySuburb),
    pipes = list(pipe1, pipe2, pipe3, pipe4))

exportPipeline(aucklandRents, "~/files.fos/openapi/xml")
