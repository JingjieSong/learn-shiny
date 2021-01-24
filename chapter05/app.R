library(shiny)
library(vroom)
library(tidyverse)

injuries <- vroom::vroom('neiss/injuries.tsv.gz')
injuries

products <- vroom::vroom('neiss/products.tsv')
products

population <- vroom::vroom('neiss/population.tsv')
population

selected <- injuries %>% filter(prod_code == 649)


count_top <- function(df, var, n = 5) {
  df %>% 
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>% 
             group_by({{ var}}) %>% 
             summarise(n = as.integer(sum(weight)))
}

ui <- fluidPage(
  fluidRow(
    column(8,
           selectInput('code', 'Product', setNames(products$prod_code,
                                                   products$title),
                       width = '100%')
           ),
    column(2, selectInput('y', 'Y axis', c('rate', 'count')))
  ),
  fluidRow(
    column(4, tableOutput('diag')),
    column(4, tableOutput('body_part')),
    column(4, tableOutput('location'))
  ),
  fluidRow(
    column(12, plotOutput('age_sex'))
  ),
  fluidRow(
    column(2, actionButton('story', 'Tell me a story')),
    column(10, textOutput('narrative'))
  )
)

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  
  output$diag <- renderTable(count_top(selected(), diag), width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
  output$location <- renderTable(count_top(selected(), location), width = "100%")
  
  summary <- reactive({
    selected() %>% 
      count(age, sex, wt=weight) %>% 
      left_join(population, by = c('age', 'sex')) %>% 
      mutate(rate = n / population * 1e4)
  })
  
  output$age_sex <- renderPlot({
    if (input$y == 'count') {
      summary() %>% 
        ggplot(aes(age, n, colour = sex))+
        geom_line() +
        labs(y = 'Estimated number of injuries')
    } else {
      summary() %>% 
        ggplot(aes(age, rate, colour = sex)) +
        geom_line(na.rm = T) + 
        labs(y = 'Injuries per 10,000 people')
    }
    }, res = 96)
  
  output$narrative <- renderText({
    input$story
    selected() %>% pull(narrative) %>% sample(1)
  })
    
}

shinyApp(ui, server)
