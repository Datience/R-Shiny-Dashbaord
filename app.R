#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# install.packages("zoo")
# install.packages("plotly")
# install.packages("shinythemes")
# install.packages("devtools")
# install.packages("gridExtra")
# install.packages("cowplot")
# install.packages("devtools::install_github('hadley/ggplot2')")
# install.packages('rsconnect')
# install.packages("DT")
# install.packages("shinydashboard")
# install.packages("shinyjs")
# install.packages("leaflet")
# install.packages("ggplot2")
# install.packages("dplyr")
# install.packages("shinyWidgets")
# install.packages("stringi")
# install.packages("dygraphs")
# install.packages("forecast")
# install.packages("datasets")

library(datasets)
library(forecast)
library(dygraphs)
library(shinythemes)
library(plotly)
library(shiny)
library(devtools)
library(grid)
library(gridExtra)
library(cowplot)
library(rsconnect)
library(DT)
library(shinydashboard)
library(shinyjs)
library(leaflet)
library(dplyr)
library(shinyWidgets)
library(stringi)
library(zoo)


#install.packages("ggplot2")
#setwd("H:/Dashboard")
library(ggplot2)
#bbrindicatordf <- read.csv("bbr shiny2.csv",header=TRUE)
bbrindicatorindexdf <- read.csv("Data.csv", header = TRUE)
bbrindicatorindexdf1 <- read.csv("Dataupdate.csv", header = TRUE)
#businessexpectations <- read.csv("Book1.csv", header = TRUE)

df1<- read.csv("Datatidy.csv", header = TRUE)
df1$Year <-  as.yearmon(paste(df1$Year, df1$Month), "%Y%m")
#trend_pal <-  c('red','blue', 'yellow', 'green')
#df2 <- read.csv("bbrshiny1.csv", header = TRUE)

#recoding dates to %Y%m
library(zoo)

bbrindicatorindexdf$Date <- as.yearmon(paste(bbrindicatorindexdf$Year, bbrindicatorindexdf$Month), "%Y%m")

#format(as.yearmon(str(1), "%Y%m")) 
#str(bbrindicatordf$Date)

#indicators as numeric
#bbrindicatordfindex$SF.Building.permits <- as.numeric(bbrindicatordf$SF.Building.permits)
#bbrindicatordfindex$Airline.Passengers <- as.numeric(bbrindicatordf$Airline.Passengers)
#bbrindicatordfindex$Us.dollar.exchange <- as.numeric(bbrindicatordf$Us.dollar.exchange)
#bbrindicatordfindex$Initial.Unemployment.Claims <- as.numeric(bbrindicatordf$Initial.Unemployment.Claims)
#bbrindicatordfindex$Weekly.manufacturing.Hours <- as.numeric(bbrindicatordf$Weekly.manufacturing.Hours)
#convvert month number
#bbrindicatordf$Date <- strptime(as.character(bbrindicatordf$Date), "%m/%Y")


appCSS <- "
#loading-content {
position: absolute;
padding: 35% 0 0 0;
background: #fefdfa;
opacity: 0.9;
z-index: 100;
left: 0;
right: 0;
height: 100%;
text-align: center;
color: #d00000;
}
"
#Shiny app---------------------
# Define UI

ui <- tagList(
  useShinyjs(),
  inlineCSS(appCSS),
  div(
    id = "loading-content",
    h2("Loading....")
  ),
  
  fluidPage(theme = shinytheme("journal"),
            HTML('<meta name="viewport" content="width=1024">'),
    
    
    fluidRow(
      
      column(12, img(height = 50, width = 160, src = "rstudio.png"))
    ),
    titlePanel( "", windowTitle = "BBR Dashboard"),
    tabsetPanel(
      tabPanel(
        "Index Values",
        
        theme = "bootstrap.css",
        tags$head(
          tags$style(HTML("
                          @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                          
                          h1 {
                          font-family: 'Times',  face = 'bold';
                          font-weight: 500;
                          line-height: 1.1;
                          color: #d00000;
                          
                          }
                          hr {
                          border-top: 3px solid #d00000;
                          color:#d00000 ;}
                          
                          "))
          ),
        
        
        #theme = shinytheme("united"),
        
        # Application title
        
        headerPanel ("Component Values Seasonally-Adjusted"),
        br(),
        
        
        # Sidebar  
        sidebarLayout(
          sidebarPanel(
            
            
            tags$style(type='text/css', ".selectize-input { font-size: 25px; line-height: 25px; color: black;font-family: 'times'} .selectize-dropdown { font-size: 16px; line-height: 20px; color: grey;font-family: 'times'}"),
            selectInput("indicator",
                        ("Indicators:"),
                        choices = c("Single-Family Building Permits","Airline Passengers",
                                    "The Trade-Weighted Exchange Rate for the U.S. Dollars", "Initial Unemployment Claims", 
                                    "Weekly Manufacturing Hours", "Business Expectations from Monthly Survey of Nebraska Business")),
            
            # dateRangeInput('dateRange',
            #  label= 'Date range input:', format = "m/yyyy",
            # startview = Sys.Date(), end = Sys.Date()),startview = "year", separator = "to"
            
            
            
            
            hr(),
            
            helpText(" Components of the Nebraska Leading Economic Indicator",  style=  "font-family: 'time' ; font-si25pt; color: black" ),
            strong("There are six components of the Leading Economic Indicator - Nebraska.",style=  "font-family: 'times'; font-si25pt; color:black" ),
            p("Several of the components are also part of the U.S. Leading Economic Indicators
              developed by the Conference Board. ", style=  "font-family: 'times'; font-si2pt"),
            div("The 6 components of the Leading Economic Indicator - Nebraska:" , style=  "font-family: 'times'; font-si20pt"),
            div("1. Single-Family Building Permits" ,style=  "font-family: 'times'; font-si20pt"),
            div("2. Airline Passengers" ,style=  "font-family: 'times'; font-si20pt"),
            div("3. The Trade-Weighted Exchange Rate 
                for the U.S. Dollars" ,style=  "font-family: 'times'; font-si20pt"),
            div("4. Initial Unemployment Claims" ,style=  "font-family: 'times'; font-si20pt"),
            div("5. Weekly Manufacturing Hours",style=  "font-family: 'times'; font-si20pt"),
            div("6. Business Expectations from Monthly Survey of Nebraska Business",style=  "font-family: 'times' ; font-si20pt" ),
            br(),
            br(),
            br(),
            a("Click for the Economic Indicator Reports",     href= "https://business.unl.edu/outreach/bureau-of-business-research/leading-economic-indicator-reports/", target="_blank")
            
            
            
            ),
          
          
          
          
          
          
          
          #I DELETED THE 'click = "plot_click"' IN THE PLOTOUTPUT LINE BELOW - WASN'T SURE WE NEEDED IT - ALSO COMMENTED OUT THE VERBATIMTEXTOUTPUT
          mainPanel(
            
            
            plotlyOutput("plot12"),
            
            
            br(),
            h2 (strong("Description of the Indicator:"), style = "color:black"),
            
            
            textOutput("selected_var"),
            tags$head(tags$style(HTML("
                                      #selected_var {
                                      font-size: 20px;
                                      color:grey
                          }
                                      "))),
            
            br(),
            img(src = "BBR.png", height = 100, width = 180, align = "right")
            
            # verbatimTextOutput("dateRangeText")
            
            
            
            
            )
          
            )
            ),
      
      
      
      
      tabPanel("Table: Component Values",
               dataTableOutput("table1")
              # mainPanel( img(src = "BBR.png", height = 100, width = 180, align = "down", position = "left")
                 
               ),
   #   tabPanel( "Monthly Reports", 
      #           sidebarLayout(
      #             sidebarPanel(
      #               #hr(),
      #               helpText("Economic Indicator Reports",  style=  "font-family: 'time' ; font-si45pt; color: black" ),
      #               div("The College of Business Department of Economics provides a monthly initiative through our Leading Economic Indicator reports to measure" , style=  "font-family: 'times'; font-si20pt"),
      #               div("and project the condition of the Nebraska economy." ,style=  "font-family: 'times'; font-si20pt"),
      #               div("The report uses key economic indicators to help people better understand the economy and" ,style=  "font-family: 'times'; font-si20pt"),
      #               div("the factors that play a role in the growth and decline of economic conditions in our communities." ,style=  "font-family: 'times'; font-si20pt"),
      #              # div("4. Initial Unemployment Claims" ,style=  "font-family: 'times'; font-si20pt"),
      #               #div("5. Weekly Manufacturing Hours",style=  "font-family: 'times'; font-si20pt"),
      #               #div("6. Business Expectations from Monthly Survey of Nebraska Business",style=  "font-family: 'times' ; font-si20pt" ),
      #              br(),
      #               actionButton("generate", "June 2018"),
      #              br(),
      #              br(),
      #              actionButton("generate1", "May 2018"),
      #              br(),
      #              br(),
      #              actionButton("generate2", "April 2018")
      #             ),
      #           
      #           mainPanel(
      #             uiOutput("pdfview"),
      #             br(),
      #             uiOutput("pdfview1"),
      #             br(),
      #             uiOutput("pdfview2")
      #            
      #              #br(),
      #             
      #            # img(src = "BBR.png", height = 100, width = 180, align = "right")
      #           )
      #           
      # )
     # ),
      tabPanel("Interactive Graph",
               sidebarLayout(
                 sidebarPanel(
                  pickerInput("All", "Choose 2 or more Indicators", multiple = T,choices = c("Single-Family Building Permits","Airline Passengers",
                                                                                              "Exchange Rate for the U.S. Dollars", "Initial Unemployment Claims", 
                                                                                              "Weekly Manufacturing Hours", "Business Expectations of Nebraska Business"), selected = "Single-Family Building Permits", options = list(`max-options` = 6))),
                  mainPanel(
                  plotlyOutput('plot'))
               
                   
                 )
               )
   #   tabPanel ("try",
    #            mainPanel(
     #             plotOutput("ForecastPlot")
      #          )
              
                
       #        )
        
      )
     
      
          ),
    
        
  tags$footer("This app may time-out if left idle too long, which will cause the screen to grey-out. To use this app again, refresh the page.", align = "center", style = "
           position: absolute;
           bottom:0;
               /* Height of the footer */
              text-align: center;
              color: #d00000;
              left: 0;
              right: 0;
              padding: 16px;
              background-color: #fefdfa ")
  
  )   #end tagList




# I DELETED THE 'SESSION' OUT OF THE FUNCTION IN THE LINE BELOW
server <- function(input, output,session) {
  Sys.sleep(4)
  
  # Hide the loading message when the rest of the server function has executed
  hide(id = "loading-content", anim = TRUE, animType = "fade")  
  
  
  observeEvent(input$generate, {
 output$pdfview <- renderUI({
   tags$iframe(style="height:600px; width:100%", src="LEI_6_2018.pdf")
 })
 
 
  })
  
  
  observeEvent(input$generate1, {
    output$pdfview1 <- renderUI({
      tags$iframe(style="height:600px; width:100%", src="LEI_5_2018.pdf")
    })
    
    
  })
  
  
  observeEvent(input$generate2, {
    output$pdfview2 <- renderUI({
      tags$iframe(style="height:600px; width:100%", src="LEI_4_2018.pdf")
    })
    
    
  })
  # DT::datatable(indicators, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  # })
  
  #Daterange
  # Dates <- reactiveValues()
  #observe({
  #  Dates$SelectedDates <- c(as.yearmon(format(input$dateRange[1],format="%m%Y")), as.yearmon(format(input$dateRange[2], format= "%m%Y")))
  #})
  # output$dateRangeText <- renderText({Dates$SelectedDates})
  
  
  # output$table <- renderDataTable(bbrindicatordf) 
  output$table1 <- renderDataTable(bbrindicatorindexdf1)
  
  output$selected_var <-  renderText({
    
    if ("Single-Family Building Permits" %in% input$indicator) return ("The measure is the number of single-family permits issued by local governments in each of Nebraska's two metropolitan areas of Omaha and Lincoln. 
                                                                       
                                                                       Source: Building Permits Nebraska (City of Lincoln, City of Omaha, Greater Omaha Chamber website)" )
    if ("Airline Passengers" %in% input$indicator) return("The measure is a count of all passengers on commercial airlines and private jets,though commercial passengers account for the vast majority of the count.The data reflects both business and leisure travel. 
                                                          
                                                          Source: Lincoln Airport Authority, Omaha Airport webiste")
    if("The Trade-Weighted Exchange Rate for the U.S. Dollars" %in% input$indicator) return("The index is the weighted(by volume) composite of the exchange rate with all major trading partners including the European Union, Canada, Mexico, China, Japan, and others.The trade-weighted index is utilized because Nebraska, with its large agricultural, manufacturing, and freight sector,is closely linked with exports. 
                                                                                             
                                                                                             Source:Federal Reserve Bank of Saint Louis FRED data base ")
    if("Initial Unemployment Claims" %in% input$indicator) return("This component is the number of persons filing their initial claim to the program during the month.National unemployment insurance claims are a component of the U.S.Leading Economic Indicators developed by the Conference Board. 
                                                                  
                                                                  Source:Nebraska Department of Labor Website ")
    if("Weekly Manufacturing Hours" %in% input$indicator) return("This component is the total hours worked each week by production workers in the manufacturing industry in Nebraska,specifically the average number of hours worked each week multiplied by the average number of production workers in Nebraska during the month.Manufacturing hours is also component of the U.S.Leading Indicators.
                                                                 
                                                                 Source:U.S. Bureau of Labor Statistics Web Site")
    
    if ("Business Expectations from Monthly Survey of Nebraska Business" %in% input$indicator) return ("The sixth component of the Leading Economic Indicators - Nebraska is information on business
                                                                                                       expectations that are reported each month in Survey of Nebraska Business. That monthly survey is
                                                                                                       conducted by the CBA Bureau of Business Research. The survey is sent to 500 Nebraska businesses each
                                                                                                       month. The business expectation measure is
                                                                                                       a weighted average of a diffusion index based on business responses to the questions about sales and
                                                                                                       employment expectations. The questions asked whether sales (or employment) are expected to increase,
                                                                                                       decrease, or stay the same over the next 6 months. Source: Source is monthly Survey of Nebraska Business (BBR) ")
  })
  
  
  
  
  
  
  
  plots1 <- reactive({
    
    #HERE ARE EXAMPLE GRAPHS - THESE SHOULD PRODUCE LINE GRAPHS FOR YOU - YOU WILL NEED TO CHANGE THE NAME OF THE DATA FRAME AND THE NAMES OF THE X AND Y VARIABLES
    #ONCE WE GET THESE TO WORK WE CAN WORK ON MAKING THEM LOOK NICER
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                    
                    
                    
                    "))
    
    mynamestheme <- theme(
      plot.title = element_text( face = "bold", size = (25), colour = "black"), 
      #legend.title = element_text(colour = "blue",  face = "bold.italic",  "Helvetica"), 
      #legend.text = element_text(face = "italic", colour="blue4","Helvetica"), 
      axis.title = element_text( size = (15), colour = "black"),
      axis.text = element_text( colour = "black", size = (15)),
      axis.title.x = element_text(margin = unit(c(0, 0, 0, 0), "mm"), angle = 0),
      axis.title.y = element_text(margin = unit(c(0, 0, 0, 0), "mm"), angle = 0),
      plot.background=element_rect(fill="#fefdfa",color=NA))
    
    
    
    buildpermit1 <- ggplot(bbrindicatorindexdf, aes(x=Date, y= Single.Family.Building.Permits))+ 
      
      geom_line( color="#d00000", size =0.5)+ mynamestheme + scale_x_yearmon(format= "%Y", n = 8) + labs(title = "Single-Family Building Permits"
                                                                                                         , y = "Single-Family Building Permits")
    
    airline1 <- ggplot(bbrindicatorindexdf, aes(x=Date, y=Airline.Passengers)) +
      geom_line(color = "#d00000", size = 0.5)+scale_x_yearmon(format= "%Y", n = 8)+ mynamestheme + labs(title = "Airline Passengers" , y = "Airline Passengers")
    
    dollarx1 <- ggplot(bbrindicatorindexdf, aes(x=Date, y= Exchange.Rate.for.the.U.S..Dollars)) +
      geom_line(color = "#d00000", size = 0.5)+scale_x_yearmon(format= "%Y", n = 8)  + mynamestheme + labs(title = "The Trade-Weighted Exchange Rate for the U.S. Dollars" , y = "U.S.Dollar Exchange")
    
    unemp1 <- ggplot(bbrindicatorindexdf, aes(x=Date, y= Initial.Unemployment.Claims)) +
      geom_line(color = "#d00000", size = 0.5)+scale_x_yearmon(format= "%Y", n = 8) + mynamestheme  + labs(title = "Initial Unemployment Claims" , y = "Initial Unemployment Claims")
    
    manufacture1 <- ggplot(bbrindicatorindexdf, aes(x=Date, y=Weekly.Manufacturing.Hours)) +
      geom_line(color = "#d00000", size = 0.5)+scale_x_yearmon(format= "%Y", n = 8)  + mynamestheme  + labs(title = "Weekly Manufacturing Hours" , y = "Weekly Manufacturing Hours")
    
    business <- ggplot(bbrindicatorindexdf, aes(x=Date, y=Business.Expecations)) +
      geom_line(color = "#d00000", size = 0.5)+scale_x_yearmon(format= "%Y", n = 8)  + mynamestheme  + labs(title = "Business Expectations" , y = "Business Expectations")
    
    
    if("Single-Family Building Permits" %in% input$indicator) return(buildpermit1)
    if("Airline Passengers" %in% input$indicator) return(airline1)
    if("The Trade-Weighted Exchange Rate for the U.S. Dollars" %in% input$indicator) return(dollarx1)
    if("Initial Unemployment Claims" %in% input$indicator) return(unemp1)
    if("Weekly Manufacturing Hours" %in% input$indicator) return(manufacture1)
    if("Business Expectations from Monthly Survey of Nebraska Business" %in% input$indicator) return(business)
    
    
    
    
  })  
  
  
  
  output$plot12 <- renderPlotly({
    dataplots1 = plots1()
    print(dataplots1)
    ggplotly(dataplots1, tooltip = "y")})
  
  
  output$plot <- renderPlotly({
    #Filtering data based on user input
   
    
    p <- ggplot(subset(df1,df1$Indicators %in% input$All)) +
      geom_line()+(aes(Year, Value, colour=Indicators)) 
    ggplotly (p, tooltip = "y")
  })
  
  # output$ForecastPlot <- renderPlot({
  #  plot1 <- auto.arima(businessexpectations$Business.Expecations)
  #plot (forecast(plot1, h = 12))
  
  #})
  #WE CAN USE THE LINE BELOW TO SUBSET BY DATE ONCE WE GET THE PLOTS FIGURED OUT
  #dataplots %+% subset(bbrindicatordf, Date %in% input$indicators)
  
  
  
  }

# Run the application 
shinyApp(ui = ui, server = server)
 

