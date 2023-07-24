library(dplyr)
library(ggplot2)
library(shiny)
library(DT)
library(ggrepel)
library(tidyr)
library(shinycssloaders)
library(shinythemes)
library(SwimmeR)
library(tidyverse)

#Import Data
collegedata <- read.csv("data/college_data.csv")
fiftystates <- read.csv("fiftystates.csv")

button_color_css <- "
#DivCompClear, #FinderClear, #EnterTimes{
/* Change the background color of the update button
to blue. */
background: DodgerBlue;

/* Change the text size to 15 pixels. */
font-size: 15px;
}"

# Define UI
ui <- fluidPage(

#Navbar structure for UI
  navbarPage("College Characteristics Map", theme = shinytheme("cerulean"),
             tabPanel("College Finder", fluid = TRUE, icon = icon("globe-americas"),
                      tags$style(button_color_css),
                      # Sidebar layout with a input and output definitions
                      sidebarLayout(
                        sidebarPanel(
                          titlePanel("Desired College Characteristics"),
                          #shinythemes::themeSelector(),
                          fluidRow(column(3,
                                          # Select which Status(s) to plot
                                         checkboxGroupInput(inputId = "SchoolStatusFinder",
                                                             label = "Select School Type:",
                                                             choices = c("Public" = 1, "Private" = 2),
                                                             selected = 1),

                          ),
                          column(6, offset = 2,
                                 # Select which Region(s) to plot
                                 checkboxGroupInput(inputId = "RegionFinder",
                                                    label = "Select Region(s):",
                                                    choices = c("New England" = 1, "Mid Atlantic" = 2, "Great Lakes" = 3, "Plains" =4, "South" = 5, "Southwest" = 6, "Mountain West" = 7, "Pacific" =8),
                                                    selected = 1)
                          )),
                          
                         
                          # Set Admit RAte Range
                          fluidRow(column(5,
                                          textInput(inputId = "AdmitRateFinderMin",
                                                    label = "Min Admit Rate",
                                                    value = 0,
                                                    width = "100px")
                          ),
                          column(5, ofset = 3,
                                 textInput(inputId = "AdminRateFinderMax",
                                           label = "Max Admit Rate",
                                           value = 1,
                                           width = "100px")
                          )),
                          
                        ),
                        mainPanel(
                          fluidRow(
                            column(3, offset = 9,
                                   radioButtons(inputId = "show_NamesFinder",
                                                label = "Display:",
                                                choices = c("School Names", "No names"),
                                                 selected = "School Names")
                            )),
                          hr(),
                          plotOutput(outputId = "scatterplotFinder")
                          # hr(),
                          # fluidRow(column(7,
                          #                 helpText()# "Tip: Click locations to populate table below with information on schools in a specific area")
                                          #actionButton(inputId = "draw", label = "Input Event and Times")

                          # ),
                          # column(width = 2, offset = 2, conditionalPanel(
                          #  condition = "output.schoolstableFinder",
                          #  actionButton(inputId = "FinderClear", label = "Clear Table")))),
                          # br(),
                          # fluidRow(
                          # withSpinner(dataTableOutput(outputId = "schoolstableFinder"))
                          # )
                        )
                      )
             )
)
)

# Define server
server <- function(input, output, session) {
  
  output$collegetable <-reactive({
      req(input$AdmitRateFinderMin)
      req(input$AdmitRateFinderMax)
      req(input$SchoolStatusFinder)
      req(input$RegionFinder)
      filter(collegedata, ADM_RATE >= input$AdmitRateFinderMin) %>%
        filter(ADM_RATE <= input$AdmitRateFinderMax) %>%
        filter(REGION %in% input$RegionFinder) %>%
        filter(SCHTYPE %in% input$SchoolStatusFinder)
    })
  
  CollegeDataFinder <- reactive({
    req(input$AdmitRateFinderMin)
    req(input$AdmitRateFinderMax)
    req(input$SchoolStatusFinder)
    req(input$RegionFinder)
    filter(collegedata, ADM_RATE >= input$AdmitRateFinderMin) %>%
    filter(ADM_RATE <= input$AdmitRateFinderMax) %>%
    filter(REGION %in% input$RegionFinder) %>%
    filter(SCHTYPE %in% input$SchoolStatusFinder)
  })

  fiftystates_Finder <- reactive({
    req(input$RegionFinder)
    filter(fiftystates, REGION_CODE %in% input$RegionFinder)
  })
  
  output$scatterplotFinder <- renderPlot(
    reactive({
    input$fiftystates_Finder
    input$show_NamesFinder
    input$CollegeDataFinder
    isolate(
        ggplot() +
          geom_polygon(data = fiftystates_Finder(), aes(x = long, y = lat, group = group), color = "white", fill = "grey") +
          coord_quickmap() +
          guides(fill = "none") +
          geom_point(data = CollegeDataFinder(), aes(x = LONGITUDE, y = LATITUDE, color = ADM_RATE, shape = SCHTYPE), alpha = 0.5) +
          theme_void() +
          labs(color = "Admit Rate", shape = "School Type", title = pretty_plot_title("Selected Colleges")
          )   +
           theme(axis.text = element_blank(), axis.ticks = element_blank()) +
           theme(plot.title = element_text(hjust=0.5, face = "bold")) +
           theme(plot.background = element_rect(fill = "white"), plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm")) +
           guides(alpha = FALSE) +
           theme(legend.text = element_text(size = 12),
                 legend.title = element_text(size = 15)) +
           theme(plot.background = element_rect(
             color = "white"
           ))
     )
    })
  )



  # ALIAS, SATVRMD, SATMTMD, ADM_RATE, FIRSTGEN_COMP_ORIG_RT, NOT1STGEN_COMP_ORIG_RT

}
# Run the application
shinyApp(ui = ui, server = server)