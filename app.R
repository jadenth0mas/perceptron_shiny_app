# Get dependencies
library(shiny)
library(tidyverse)
library(shinythemes)

# Get perceptron functions
source("perceptron.r") 

x <- iris
iris_sub <- filter(iris, Species=="setosa"|Species=="versicolor") %>%
  select(Sepal.Length, Petal.Length, Species)
d <- iris_sub %>% mutate(Species_num=recode(Species, setosa=1, versicolor=-1)) #Change into form for perceptron functions
tt <- train_test(d, "Sepal.Length", "Petal.Length", "Species_num") # Train test split iris data
perc <- perceptronTrain(tt[[1]], tt[[2]], 0.001, 200) # train model
ip <- perceptronPredict(tt[[3]], perc$weights) # make predictions
iris_graph <- sep_graph(d, "Sepal.Length", "Petal.Length", "Species", perc) # make the graph


# Define UI for application that draws a histogram
ui <- fluidPage(theme=shinytheme("flatly"),
    navbarPage(title="Perceptron Visualizer",
               tabPanel("Plot",
                 sidebarLayout(
                   sidebarPanel(
                     selectInput(inputId="selected", label="Select a Dataset: ", choices=c("Example Data", "Create Data"), selected="Example Data"),
                     conditionalPanel("input.selected=='Example Data'", selectInput("example", "Choose Example Dataset: ", choices=c("Iris"), selected="Iris")),
                     conditionalPanel("input.selected=='Create Data'", numericInput("n", "Number of Observations", value=10, min=1),
                                      numericInput("seed", "Input Seed Number", value=2023, min=0),
                                      actionButton("do", "Generate")),
                     conditionalPanel("")
                     ),
                   mainPanel(
                     fluidRow(
                       column(12, plotOutput(outputId="plot", height=500))
                     )
                   )
    )
  ),
              tabPanel("Summary",
                       sidebarLayout(
                         sidebarPanel(
                           numericInput("x1", "Input X1: ", value=0),
                           numericInput("x2", "Input X2: ", value=0),
                           actionButton("predict", "Predict"),
                           textOutput("y_val")
                         ),
                         mainPanel(
                           fluidRow(
                           htmlOutput("summary"),
                           tableOutput("sumTable"),
                           plotOutput(outputId="points", height=500)
                           )
                       )
                       )),
              tabPanel("Data",
                       verbatimTextOutput("data_text"),
                       dataTableOutput("df")),
              tabPanel("About",
                       htmlOutput("markdown")
                       )
)
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  
  create_data <- eventReactive(input$do, { # Create the data and model when button pressed
    df1 <- create_seperable(input$n, input$seed)
    tt1 <- train_test(df1, "x1", "x2", "y")
    perc1 <- perceptronTrain(tt1[[1]], tt1[[2]], 0.001, 200)
    p <- perceptronPredict(tt1[[3]], perc1$weights)
    return(list(df1, perc1, p, tt1))
  })
  
  # Plot Page
  output$plot <- renderPlot(
  if(input$selected=="Example Data" && input$example=="Iris") {
    iris_graph +
      labs(title="Graph of Data and Decision Line for Iris Data", color="Species")
  } else if(input$selected=="Create Data") {
    x <- create_data()
    sep_graph(x[[1]], "x1", "x2", "y", x[[2]]) +
      labs(title="Graph of Data and Decision Line for Generated Data", color="Y Category")
  }
  ) 
  
  #Data Page
  output$df <- renderDataTable(
    if(input$selected=="Example Data" && input$example=="Iris") {
      iris 
    } else if(input$selected=="Create Data") {
      x <- create_data()
      x[[1]]
    }
  ) 
  output$data_text <- renderText(if(input$selected=="Example Data" && input$example=="Iris") {
    "Iris Dataset"
  } else if(input$selected=="Create Data") {
    "Generated Dataset"
  }
  )
  
  # Summary Page
  output$summary <- renderUI(if(input$selected=="Example Data" && input$example=="Iris") {
    str1 <- paste0("Number of Training Iterations: ", perc$epochs)
    str2 <- paste0("Correct Rate: ", correct_rate(ip, tt[[4]]))
    str3 <- paste0("Test Set Size: ", length(tt[[4]]))
    HTML("<p>",paste(str1, str2, str3, sep="<br/>"),"</p>")
  } else if(input$selected=="Create Data") {
    x <- create_data()
    str1 <- paste0("Number of Training Iterations: ", x[[2]]$epochs)
    str2 <- paste0("Correct Rate: ", correct_rate(x[[3]], x[[4]][[4]]))
    str3 <- paste("Test Set Size: ", length(x[[4]][[4]]))
    HTML("<p>", paste(str1, str2, str3, sep="<br/>"), "</p>")
  }
)
  
  pred_button <- eventReactive(input$predict, {
    if(input$selected=="Example Data" && input$example=="Iris") {
      if(perceptronPredict(data.frame(input$x1, input$x2), perc$weights)<0) {
        "Predicted: Versicolor"
      } else {
        "Predicted: Setosa"
      }
    } else if(input$selected=="Create Data") {
      x <- create_data()
      if (perceptronPredict(data.frame(input$x1, input$x2), x[[2]]$weights)<0) {
        "Predicted: -1"
      } else {
        "Predicted: 1"
      }
    }
  }
  )
  output$y_val <- renderText(
    pred_button()
  )
  
  # Data Page
  output$sumTable <- renderTable(if(input$selected=="Example Data" && input$example=="Iris") {
    as.data.frame.matrix(table(ip, tt[[4]]))
  } else if(input$selected=="Create Data") {
    x <- create_data()
    as.data.frame.matrix(table(x[[3]], x[[4]][[4]]))
  },
  rownames=T
  )
  
  # About Page
  output$markdown <- renderUI({
    page <- tags$iframe(src="about_md.html", style='width:100vw;height:100vh;')
    page
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
