dir <- "<my directory>"
setwd(dir)
load("20210109 data.RData")

library(sf)
library(shiny)
library(tmap)

ui <- fluidPage(
    titlePanel("Distribution of R&D activities across the Netherlands"),
    sidebarLayout(
        sidebarPanel(
            # text
            h2("Welcome!"),
            h3(span("Created on 10 January 2021"), style = "color:red"),
            p("Thank you for taking the time to review this app. It is not perfect yet, but it already gives a good idea of where I want it to go."),
            p("This app visualizes a data set that I have collected for one of my research projects. This data contains information about Dutch organizations involved in one or more R&D projects in the Netherlands. For each organization, we know (1) the",
              em(strong("year")),
              "of involvement, (2) the",
              em(strong("technological focus")),
              "of the project, and (3) its",
              em(strong("location."))),
            p("Below you can select the period, the technology field and the geographical aggregation level. The map shows how many organizations were involved in an R&D project in the technology field chosen and time range, and where these organizations are located."),
            br(),
            p("Have fun!"),
            br(),
            
            # slider for selecting years
            sliderInput(inputId = "yr", # refer to this as input$yr in the server function
                        label = "Select time range",
                        min = 1982, max = 2004, value = c(1982,2004),
                        sep = ""),
            
            # select box for selecting technology fields
            selectInput(inputId = "fld.mai", # refer to this as input$fld.mai in the server function
                        label = "Select a technology field",
                        choices = c("Chemistry", "Civil Engineering", "Electrical Engineering", "Instruments", "Life Sciences", "Mechanical Engineering", "Medical Technology")),
            
            # select level of geographical aggregation
            radioButtons(inputId = "plt.lev", # refer to this as input$plt.fil in the server function
                         label = "Select geographical aggregation level",
                         choices = c("Municipalities", "Regions")),
            width = 4
        ), # end of sidebarPanel
        mainPanel(
            plotOutput("geo.plt",
                       width = "170%",
                       height = "680px"), # refer to this as output$geo.plt in the server function
            width = 8
        ) # end of mainPane
    ) # end of sidebarLayout
) # end of fluidPage()