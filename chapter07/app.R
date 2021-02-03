library(shiny)
library(ggplot2)

ui <- basicPage(
  plotOutput('plot', click = 'plot_click'),
  verbatimTextOutput('info')
)

server <- function(input, output) {
  output$plot <- renderPlot({
    plot(mtcars$wt, mtcars$mpg)
  }, res = 96)
  
  output$info <- renderPrint({
    req(input$plot_click)
    x <- round(input$plot_click$x, 2)
    y <- round(input$plot_click$y, 2)
    cat('[', x, ', ', y, ']', sep = '')
  })
}

shinyApp(ui, server)

ui <- fluidPage(
  plotOutput('plot', click = 'plot_click'),
  tableOutput('data')
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    plot(mtcars$wt, mtcars$mpg)
  }, res = 96)
  
  output$data <- renderTable({
    nearPoints(mtcars, input$plot_click, xvar = 'wt', yvar = 'mpg')
  })
}

shinyApp(ui, server)

ui <- fluidPage(
  plotOutput('plot', click = 'plot_click'),
  tableOutput('data')
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) + geom_point()
  }, res = 96)
  
  output$data <- renderTable({
    nearPoints(mtcars, input$plot_click)
  })
}

shinyApp(ui, server)

ui <- fluidPage(
  plotOutput('plot', brush = 'plot_brush'),
  tableOutput('data')
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) + geom_point()
  }, res = 96)
  
  output$data <- renderTable({
    brushedPoints(mtcars, input$plot_brush)
  })
}

shinyApp(ui, server)

df <- data.frame(x = rnorm(100), y = rnorm(100))

ui <- fluidPage(
  plotOutput('plot', click = 'plot_click')
)

server <- function(input, output, session) {
  dist <- reactiveVal(rep(1, nrow(df)))
  observeEvent(input$plot_click,
               dist(nearPoints(df, input$plot_click, allRows = T,
                               addDist = T)$dist_)
               )
  output$plot <- renderPlot({
    df$dist <- dist()
    ggplot(df, aes(x, y, size = dist)) + 
      geom_point() +
      scale_size_area(limits = c(0, 1000), max_size = 10, guide = NULL)
  })
}

library(thematic)
thematic_on(bg = "#222222", fg = "white", accent = "#0CE3AC")

library(ggplot2)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  geom_smooth()

ui <- fluidPage(
  sliderInput('height', 'height', min = 100, max = 500, value = 250),
  sliderInput('width', 'width', min = 100, max = 500, value = 250),
  sliderInput('n', 'n', min = 10, max = 100, value = 25),
  plotOutput('plot', width = 250, height = 250)
)

server <- function(input, output, session) {
  output$plot <- renderPlot(
    width = function() input$width,
    height = function() input$height,
    res = 96,
    {
      plot(rnorm(input$n), rnorm(input$n))
    }
  )
}

shinyApp(ui, server)

ui <- fluidPage(
  selectInput('x', 'X', choices = names(diamonds), selected = 'carat'),
  selectInput('y', 'Y', choices = names(diamonds), selected = 'price'),
  plotOutput('diamonds')
)

server <- function(input, output, session) {
  output$diamonds <- renderCachedPlot({
    ggplot(diamonds, aes(.data[[input$x]], .data[[input$y]])) +
      geom_point()
  },
  cacheKeyExpr = list(input$x, input$y))
}
shinyApp(ui, server)
