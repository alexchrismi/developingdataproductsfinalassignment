dir <- "<my directory>"
setwd(dir)
load("20210109 data.RData")

library(sf)
library(shiny)
library(tmap)

server <- function(input, output) {
    output$geo.plt <- renderPlot( { # put any code needed for making the plot between these brackets
        
        # filtering and aggregating the dta.pro data frame (results in dta.plt)
        dta.plt <- dta.pro[ which(dta.pro$yr %in% c(min(input$yr)):max(input$yr)), ] # which years?
        dta.plt <- dta.plt[ which(dta.plt$fld.mai %in% gsub(" ", "_", input$fld.mai)), ] # which technology field?
        
        if (input$plt.lev == "Municipalities") { # which level of aggregation?
            
            plt.fil <- "mun"
        } else { plt.fil <- "nts.3"
        }
        
        dta.plt <- dta.plt[, c(1, grep(plt.fil, colnames(dta.plt))) ] # selecting the relevant columns
        dta.plt <- unique(dta.plt) # creating the unique users (per municipality)
        
        validate(need(nrow(dta.plt) != 0, "Please note: Data not available for this selection"))
        
        if (plt.fil == "mun") {
            dta.plt <- aggregate(. ~ mun, dta.plt, length) # aggregating by municipality
        } else { dta.plt <- aggregate(. ~ nts.3, dta.plt, length) # aggregating by nts.3
        }
        
        # merging dta.plt with geo.cod
        dta.plt <- merge(geo.cod, dta.plt, all.x = TRUE) # merging selection with geo.cod table
        dta.plt <- st_as_sf(dta.plt) # conversion to a simple feature (sf)-object 
        
        # creating the plot
        tm_shape(dta.plt) + tm_polygons(col = "use.cod.man",
                                        colorNA = "White",
                                        showNA = FALSE,
                                        title = "Number of users") +
            tm_layout(attr.outside = TRUE,
                      legend.outside = TRUE,
                      legend.outside.position = "right",
                      outer.margins = rep(0, 4))
    })    
}