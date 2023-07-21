library(dplyr)
library(ggplot2)
library(shiny)
library(DT)
library(ggrepel)
library(tidyr)
library(shinycssloaders)
library(shinythemes)
library(SwimmeR)

#Import Data
BigTop100 <- read.csv("BigTop100.csv")
collegedata <- read.csv("data/college_data.csv")
fiftystatesCAN <- read.csv("fiftystates.csv")

 Events <- ordered(BigTop100$Event, levels = c("50 Free", "100 Free", "200 Free", "500 Free", "1000 Free", "1650 Free", "100 Fly", "200 Fly", "100 Back", "200 Back", "100 Breast", "200 Breast", "100 IM", "200 IM", "400 IM", "200 Free Relay", "400 Free Relay", "800 Free Relay", "200 Medlay Relay", "400 Medlay Relay"))

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
                                                             choices = c("Public" = "1", "Private" = "2"),
                                                             selected = "1"),

                                          # Select which Division(s) to plot
                                          checkboxGroupInput(inputId = "DivisionFinder",
                                                             label = "Select Division(s):",
                                                             choices = c("DI", "DII", "DIII"),
                                                             selected = "DI")
                          ),
                          column(6, offset = 2,
                                 # Select which Region(s) to plot
                                 checkboxGroupInput(inputId = "RegionFinder",
                                                    label = "Select Region(s):",
                                                    choices = c("New England" = 1, "Mid Atlantic" = 2, "Great Lakes" = 3, "Plains" =4, "South" = 5, "Southwest" = 6, "Mountain West" = 7, "Pacific" =8),
                                                    selected = "NewEngland")
                          )),
                          # Select Event
                          selectInput(inputId = "EventFinder",
                                      label = "Select Event",
                                      choices = levels(Events),
                                      selected = "50 Free",
                                      width = "220px"
                                      ),
                          # Set Time Range
                          fluidRow(column(5,
                                          textInput(inputId = "AdmitRateFinderMin",
                                                    label = "From:",
                                                    value = "0",
                                                    width = "100px")
                          ),
                          column(5, ofset = 3,
                                 textInput(inputId = "AdminRateFinderMax",
                                           label = "To:",
                                           value = "100",
                                           width = "100px")
                          )),
                          
                          actionButton(inputId = "EnterTimes", label = "Enter Times"),
                          hr(),
                          titlePanel("School Characteristics"),
                          # Select which School Type to plot
                          checkboxGroupInput(inputId = "School_TypeFinder",
                                             label = "Select School Type(s):",
                                             choices = c("National University", "Regional University", "National Liberal Arts College", "Regional College"),
                                             selected = c("National University", "Regional University", "National Liberal Arts College", "Regional College")),

                          sliderInput(inputId = "School_RankFinder",
                                      label = "School Rank",
                                      min = 1,
                                      max = 250,
                                      value = c(1,250),
                                      width = "220px")
                        ),
                        mainPanel(
                          fluidRow(
                            column(3, offset = 9,

                                   radioButtons(inputId = "show_NamesFinder",
                                                label = "Display:",
                                                choices = c("School Names", "City Names", "Neither"),
                                                 selected = "School Names")
                            )),
                          # hr(),
                          withSpinner(plotOutput(outputId = "scatterplotFinder", click = "click_plotFinder"
                          )),
                          hr(),
                          fluidRow(column(7,
                                          helpText("Tip: Click locations to populate table below with information on schools in a specific area")
                                          #actionButton(inputId = "draw", label = "Input Event and Times")

                          ),
                          column(width = 2, offset = 2, conditionalPanel(
                            condition = "output.schoolstableFinder",
                            actionButton(inputId = "FinderClear", label = "Clear Table")))),
                          br(),
                          fluidRow(
                          withSpinner(dataTableOutput(outputId = "schoolstableFinder"))))
                      )
             ),

             tabPanel("Program Comparisons", fluid = TRUE, icon = icon("graduation-cap"),
                      titlePanel("Program Comparisons"),
                      fluidRow(
                        column(6,
                               selectizeInput(inputId = "SchoolSelectA",
                                              label = "Select Schools (Max 4)",
                                              choices = unique(BigTop100$Team),
                                              multiple = TRUE,
                                              options = list(maxItems = 4, placeholder = 'Enter school name',
                                                             onInitialize = I('function() { this.setValue(""); }'))
                               ),
                               selectInput(inputId = "SchoolCompRace",
                                           label = "Select Event",
                                           choices = levels(Events),
                                           selected = "50 Free"),
                               helpText("Select school and event to create plots")
                        ),
                        column(6,
                               checkboxGroupInput(inputId = "SchoolCompGender",
                                                  label = "Select Gender(s):",
                                                  choices = c("Male" = "M", "Female" = "F"),
                                                  selected = "M"),
                               radioButtons(inputId = "TuitionType",
                                            label = "Use In-State Tution?",
                                            choices = c("Yes", "No"),
                                            selected = "Yes"),
                               helpText("Note: In-state tuition will only apply to public schools")
                        )
                      ),
                      hr(),
                      fluidRow(
                        column(6,
                               withSpinner(plotOutput(outputId = "SchoolCompPlotEvent"
                                          # brush = "brush_SchoolComp"
                               )),
                               br(),
                               dataTableOutput(outputId = "SchoolCompDT")
                        ),
                        column(6,
                               dataTableOutput(outputId = "SchoolCompStats"),
                               helpText("For more information on school types and US News rankings please see More > About > School Types & Rankings")
                        )
             )
  )
)
)

# Define server
server <- function(input, output, session) {

  #Program Finder

#  AdmitRateFinderDF <- reactive({
 #   req(input$AdmitRateFinderMin)
  #  AdmitRateFinderDF <- as.data.frame(c(input$AdmitRateFinderMin, input$AdmitRateFinderMax))
   # names(AdmitRateFinderDF)[1] <- "UserTimes"
    # AdmitRateFinderDF$UserTimes <- as.character(AdmitRateFinderDF$UserTimes)
    # AdmitRateFinderDF <- tidyr::separate(AdmitRateFinderDF, col = UserTimes, c("min", "sec"), sep = ":", remove = FALSE, extra = "drop", fill = "left")
    # AdmitRateFinderDF[is.na(AdmitRateFinderDF)] <- 0
    # AdmitRateFinderDF$sec <- as.numeric(AdmitRateFinderDF$sec)
    # AdmitRateFinderDF$min <- as.numeric(AdmitRateFinderDF$min)
    # AdmitRateFinderDF <- AdmitRateFinderDF %>%
    # mutate(Time = (AdmitRateFinderDF$min*60) + AdmitRateFinderDF$sec)
#  })

  CollegeDataFinder <- reactive({
    req(input$AdmitRateFinderMin)
    req(input$AdmitRateFinderMax)
    req(input$School_TypeFinder)
    req(input$RegionFinder)
    filter(collegedata, ADM_RATE >= input$AdmitRateFinderMin) %>%
    filter(collegedata, ADM_RATE <= input$AdmitRateFinderMax) %>%
    filter(REGION %in% input$RegionFinder) %>%
    filter(SCHTYPE %in% input$SchoolStatusFinder)
  })
  
  BigTop100_finder <- reactive({
    #req(input$DivisionFinder)
    req(input$RegionFinder)
    req(input$School_TypeFinder)
    req(input$GenderFinder)
    req(input$EventFinder)
    #req(Input$School_Rank)
    filter(BigTop100, Division %in% input$DivisionFinder) %>%
      filter(Region %in% input$RegionFinder) %>%
      filter(Event %in% input$EventFinder) %>%
      filter(Time >= TimeFinderDF()$Time[1], Time <= TimeFinderDF()$Time[2]) %>%
      filter(Sex %in% input$GenderFinder) %>%
      filter(Type %in% input$School_TypeFinder) %>%
      filter(Y2019 >= input$School_RankFinder[1], Y2019 <= input$School_RankFinder[2]) %>%
      filter(RankInEvent_Team >= input$RankOnTeam[1], RankInEvent_Team <= input$RankOnTeam[2]) %>%
      group_by(Team, Event) %>%
      dplyr::mutate(Entries = n()) %>%
      dplyr::mutate(MinTime = mmss_format(min(Time))) %>%
      dplyr::mutate(MaxTime = mmss_format(max(Time)))

  })

  fiftystatesCAN_Finder <- reactive({
    req(input$RegionFinder)
    filter(fiftystatesCAN, GeoRegion %in% input$RegionFinder)
  })

  output$scatterplotFinder <- renderPlot({
    input$EnterTimes
    input$show_NamesFinder
    input$SchoolTypeFinder
    input$DivisionFinder
    input$RegionFinder
    input$RankOnTeam
    input$School_TypeFinder
    input$School_RankFinder
    isolate({
      if (length(BigTop100_finder()$Address) == 0) {
        ggplot() +
          geom_polygon(data = fiftystatesCAN_Finder(), aes(x = long, y = lat, group = group), color = "white", fill = "grey") +
          coord_quickmap() +
          theme_void() +
          ggtitle("No programs fit selected characteristics. \nPlease modify selections.") +
          theme(plot.title = element_text(face = "bold", color = "#FF8D1E", size = 20))
      } else {
        ggplot() +
          geom_polygon(data = fiftystatesCAN_Finder(), aes(x = long, y = lat, group = group), color = "white", fill = "grey") +
          {if(input$show_NamesFinder == "School Names") geom_text_repel(data = CollegeDataFinder(), aes(x = LONGITUDE, y = LATITUDE, label = as.character(ALIAS)))}
          coord_quickmap() +
          guides(fill = FALSE) +
          geom_point(data = CollegeDataFinder(), aes(x = LONGITUDE, y = LATITUDE, color = ADM_RATE, shape = SCHTYPE), alpha = 0.5) +
          theme_void() +
          labs(color = "Admit Rate", shape = "School Type"
               #, title = pretty_plot_title()
          ) +
          {if(length(input$DivisionFinder) <= 1) scale_color_manual(guide = "none", values = c("DI" = "#1E90FF", "DII" = "#FF8D1E", "DIII" = "#20FF1E"))} +
          {if(length(input$DivisionFinder) > 1)
            scale_color_manual(values = c("DI" = "blue", "DII" = "red", "DIII" = "green"))} +
            {if(length(input$GenderFinder) <= 1) scale_shape_manual(guide = "none", values = c("M" = "circle", "F" = "triangle"))} +
            {if(length(input$GenderFinder) > 1)
              scale_shape_manual(values = c("M" = "circle", "F" = "triangle"))} +
          theme(axis.text = element_blank(), axis.ticks = element_blank()) +
          theme(plot.title = element_text(hjust=0.5, face = "bold")) +
          theme(plot.background = element_rect(fill = "white"), plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm")) +
          guides(alpha = FALSE) +
          theme(legend.text = element_text(size = 12),
                legend.title = element_text(size = 15)) +
          theme(plot.background = element_rect(
            color = "white"
          ))

      }
    })
  })

  user_clickFinder <- reactiveValues()
  reactive({
    user_clickFinder$DT <- data.frame(matrix(0, ncol = ncol(BigTop100), nrow = 1))
    names(user_clickFinder$DT) <- colnames(BigTop100)
  })

  observeEvent(input$click_plotFinder, {
    add_row <-     nearPoints(BigTop100_finder(), input$click_plotFinder, xvar = "lon", yvar = "lat", threshold = 5)
    user_clickFinder$DT <- rbind(add_row, user_clickFinder$DT)
  })

  brushFinder <- reactive({
    req(length(user_clickFinder$DT) > 1)
    user_clickFinder$DT
  })

  observeEvent({
    input$FinderClear
    #input$EnterTimes
  },{
    user_clickFinder$DT <- NULL
  })

  output$schoolstableFinder<-DT::renderDataTable({

    DT::datatable(unique(brushFinder()[,c("Name", "SAT Verbal", "SAT Math", "Admit Rate", "Completion 1st Gen", "Completion Not 1st Gen", "Address", "Y2019", "Type", "Time")]),
                  colnames = c("Sort" = "Time", "Time" = "X.swim_time", "US News School Ranking" = "Y2019", "School Type" = "Type", "Swimmer Rank In Event On Team" = "Relative_RankInEvent_Team"),
                  rownames = FALSE,
                  options = list(order = list(9, 'asc'),
                                 columnDefs = list(list(visible=FALSE, targets=c(9)),
                                                   list(className = "dt-center", targets = 1:7),
                                                   list(classname = "dt-right", targets = 8))
                  ))

  })

  # ALIAS, SATVRMD, SATMTMD, ADM_RATE, FIRSTGEN_COMP_ORIG_RT, NOT1STGEN_COMP_ORIG_RT
  #Program Comparisons

  BigTop100_SchoolComp <- reactive({
    req(input$SchoolCompGender)
    req(input$SchoolSelectA)
    req(input$SchoolCompRace)
    filter(BigTop100, Sex %in% input$SchoolCompGender) %>%
      filter(Event %in% input$SchoolCompRace) %>%
      filter(Team %in% input$SchoolSelectA | Team %in% input$SchoolSelectB)

  })
  reactive({
    BigTop100_SchoolComp$Time <- as.numeric(format(BigTop100_SchoolComp()$Time, nsmall = 2))
  })

  output$SchoolCompPlotEvent <- renderPlot({
    ggplot(data = BigTop100_SchoolComp(), aes(y = Time, x = Team, color = Team)) +
      geom_boxplot(outlier.shape = NA) +
      geom_jitter(position = position_jitter(width = 0.05), alpha = 0.8) +
      scale_color_manual(values=c("#1E90FF", "#20FF1E", "#FF8D1E", "#FD1EFF")) +
      theme_minimal() +
      labs(x = NULL, y = NULL) +
      theme(legend.title=element_blank(), panel.grid.major = element_line(color = "white"), panel.grid.minor = element_line(color = "white")) +
      theme(plot.title = element_text(hjust=0.5, face = "bold")) +
      theme(legend.position="none") +
      scale_y_continuous(labels = scales::trans_format("identity", mmss_format)) +
      theme(legend.text = element_text(size = 12),
            legend.title = element_text(size = 15),
            axis.text.x = element_text(size = 15),
            axis.text.y = element_text(size = 15))


  })

  output$SchoolCompDT<-DT::renderDataTable({
    DT::datatable(BigTop100_SchoolComp()[,c("Name", "Team", "X.swim_time", "Class", "Rank", "Division", "Time")],
                  colnames = c("Sort" = "Time", "Time" = "X.swim_time"),
                  rownames = FALSE,
                  options = list(order = list(6, 'asc'),
                                 columnDefs = list(list(visible=FALSE, targets=6),
                                                   list(className = "dt-center", targets = 1:5)
                                                   #list(className = "dt-right", targets = 5)
                                 ))

    )
  })


  output$SchoolCompStats<-DT::renderDataTable({
    if(input$TuitionType == "Yes"){
      DT::datatable(unique(BigTop100_SchoolComp()[,c("Team", "Type", "Y2019", "Tuition_In", "Enrollment", "Public")]),
                    colnames = c("US News Ranking" = "Y2019", "Tuition" = "Tuition_In"),
                    rownames = FALSE,
                    options = list(order = list(0, 'asc'),
                                   columnDefs = list(list(className = "dt-center", targets = 1:5)),
                                   dom = 't'

                    ))
    }
    else if(input$TuitionType == "No"){
      DT::datatable(unique(BigTop100_SchoolComp()[,c("Team", "Type", "Y2019", "Tuition_Out", "Enrollment", "Public")]),
                    colnames = c("US News Ranking" = "Y2019", "Tuition" = "Tuition_Out"),
                    rownames = FALSE,
                    options = list(order = list(0, 'asc'),
                                   dom = 't',
                                   list(columnDefs = list(list(className = "dt-center", targets = 1:5)))
                    ))
    }
  })

}
# Run the application
shinyApp(ui = ui, server = server)