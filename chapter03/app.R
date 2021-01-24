library(shiny)

ui <- fluidPage(
  textInput('name', "What's your name?"),
  passwordInput('password', "What's your password?"),
  textAreaInput("story", "Tell me about yourself", rows = 3)
)

server <- function(input, output, session){
  
}

shinyApp(ui, server)

ui <- fluidPage(
  numericInput("num", "Number one", value = 0, min = 0, max = 100),
  sliderInput("num2", "Number two", value = 50, min = 0, max = 100),
  sliderInput('rng', 'Range', value = c(10, 20), min = 0, max =100)
)

ui <- fluidPage(
  dateInput('dob', 'When were you born?'),
  dateRangeInput('holiday', 'When do you want to go on vacation next?')
)

animals <- c('dog', 'cat', 'mouse', 'bird', 'other', 'I hate animals')

ui <- fluidPage(
  selectInput('state', "What's your favourite state?", state.name),
  radioButtons('animal', "What's your favourite animal?", animals)
)

shinyApp(ui, server)

ui <- fluidPage(
  radioButtons('rb', 'Choose one:',
               choiceNames = list(
                 icon('angry'),
                 icon('smile'),
                 icon('sad-tear')
               ),
               choiceValues = list(
                 'angry', 'happy', 'sad'
               )
               )
)

shinyApp(ui, server)

ui <- fluidPage(
  selectInput(
    'state',
    "What's your favourite state?",
    state.name,
    multiple = TRUE
  )
)

shinyApp(ui, server)

ui <- fluidPage(
  checkboxInput('cleanup', 'Clean up?', value = TRUE),
  checkboxInput('shutdown', 'Shutdown?')
)

shinyApp(ui, server)

ui <- fluidPage(
  fileInput('upload', NULL)
)

ui <- fluidPage(
  actionButton('click', 'Click me!'),
  actionButton('drink', 'Drink me!', icon = icon('cocktail'))
)

shinyApp(ui, server)

ui <- fluidPage(
  fluidRow(
    actionButton('click', 'Click me!', class = 'btn-danger'),
    actionButton('drink', 'Drink me!', class = 'btn-lg btn-success')
  ),
  fluidRow(
    actionButton('eat', 'Eat me!', class = 'btn-block')
  )
)

shinyApp(ui, server)

ui <- fluidPage(
  textOutput('text'),
  verbatimTextOutput('code')
)

server <- function(input, output, session) {
  output$text <- renderText({
    "Hello friend!"
  })
  output$code <- renderPrint({
    summary(1:10)
  })
}

shinyApp(ui, server)
library(DT)

ui <- fluidPage(
  tableOutput('static'),
  dataTableOutput('dynamic')
)
server <- function(input, output, session) {
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDataTable(mtcars, options = list(pageLength = 5))
}

shinyApp(ui, server)

ui <- fluidPage(
  plotOutput('plot', width = '400px')
)
server <- function(input, output, session){
  output$plot <- renderPlot(plot(1:5), res = 96)
}
shinyApp(ui, server)

ui <- fluidPage(
  titlePanel('Central limit theorem'),
  sidebarLayout(
    sidebarPanel(
      numericInput('m', 'Number of samples:', 2, min = 1, max = 100)
    ),
    mainPanel(
      plotOutput('hist')
    )
  )
)

server <- function(input, output, session) {
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
}

shinyApp(ui, server)
