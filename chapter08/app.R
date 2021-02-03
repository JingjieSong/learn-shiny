library(shiny)

ui <- fluidPage(
	shinyFeedback::useShinyFeedback(),
	numericInput('n', 'n', value = 10),
	textOutput('half')
)

server <- function(input, output, session) {
	observeEvent(input$n,
							shinyFeedback::feedbackWarning(
								'n',
								input$n %% 2 !=0,
								'Please select an even number'
							)
						)
	output$half <- renderText(input$n / 2)
}

shinyApp(ui, server)

server <- function(input, output, session) {
	half <- reactive({
		even <- input$n %% 2 == 0
		shinyFeedback::feedbackWarning('n', !even, "please select an even number")
		req(even)
		input$n /2
	})
	output$half <- renderText(half())
}

ui <- fluidPage(
	selectInput('language', 'Language', choices = c('', 'English', 'Maori')),
	textInput('name', 'Name'),
	textOutput('greeting')
)

server <- function(input, output, session) {
	greetings <- c(
		English = 'Hello',
		Maori = 'Ki ora'
	)
	output$greeting <- renderText({
		req(input$language, input$name)
		paste0(greetings[[input$language]], ' ', input$name, '!')
	})
}

shinyApp(ui, server)

ui <- fluidPage(
	shinyFeedback::useShinyFeedback(),
	textInput('dataset', 'Dataset name'),
	tableOutput('data')
)

server <- function(input, output, session) {
	data <- reactive({
		req(input$dataset)
		exists <- exists(input$dataset, 'package:datasets')
		shinyFeedback::feedbackDanger('dataset', !exists, 'Unknow dataset')
		req(exists, cancelOutput = T)
		get(input$dataset, 'package:datasets')
	})
	output$data <- renderTable({
		head(data())
	})
}

shinyApp(ui, server)

ui <- fluidPage(
	numericInput('x', 'x', value = 0),
	selectInput('trans', 'transformation',
							choices = c('square', 'log', 'square-root')),
	textOutput('out')
)

server <- function(input, output, server) {
	output$out <- renderText({
		if (input$x < 0 && input$trans %in% c('log', 'square-root')){
			validate('x can not be negative for this transformation')
		}
		
		switch(input$trans,
					 square = input$x ^ 2,
					 'square-root' = sqrt(input$x),
					 log = log(input$x))
	})
}

shinyApp(ui, server)

ui <- fluidPage(
	actionButton('goodnight', 'Good night')
)

server <- function(input, output, session) {
	observeEvent(input$goodnight, {
		showNotification('So long')
		Sys.sleep(1)
		showNotification('Farewell', type = 'message')
		Sys.sleep(1)
		showNotification('Auf Wiedersehen', type = 'warning')
		Sys.sleep(1)
		showNotification('Adieu', type = 'error')
	})
}

shinyApp(ui, server)

ui <- fluidPage(
	tableOutput('data')
)

server <- function(input, output, session) {
	notify <- function(msg, id = NULL) {
		showNotification(msg, id = id, duration = NULL, closeButton = F)
	}
	data <- reactive({
		id <- notify('Reading data...')
		on.exit(removeNotification(id), add = T)
		Sys.sleep(1)
		notify('Reticulating splines...', id = id)
		Sys.sleep(1)
		notify('Herding llamas...', id = id)
		Sys.sleep(1)
		notify('orthogonalizing matrices...', id = id)
		Sys.sleep(1)
		mtcars
	})
	output$data <- renderTable(head(data()))
}

ui <- fluidPage(
	numericInput('steps', 'How many steps?', 10),
	actionButton('go', 'go'),
	textOutput('result')
)

server <- function(input, output, session) {
	data <- eventReactive(input$go, {
		progress <- Progress$new(max = input$steps)
		on.exit(progress$close())
		progress$set(message = 'computing random number')
		for (i in seq_len(input$steps)) {
			Sys.sleep(0.5)
			progress$inc(1)
		}
		runif(1)
	})
	output$result <- renderText(round(data(), 2))
}

ui <- fluidPage(
	waiter::use_waiter(),
	numericInput('steps', 'How many steps?', 10),
	actionButton('go', 'go'),
	textOutput('result')
)

server <- function(input, output, session){
	data <- eventReactive(input$go, {
		waitress <- waiter::Waitress$new(max = input$steps)
		on.exit(waitress$close())
		
		for (i in  seq_len(input$steps)) {
			Sys.sleep(0.5)
			waitress$inc(1)
		}
		runif(1)
	})
	output$result <- renderText(round(data(), 2))
}

shinyApp(ui, server)

		ui <- fluidPage(
	waiter::use_waiter(),
	actionButton("go", "go"),
	textOutput("result")
)

server <- function(input, output, session) {
	data <- eventReactive(input$go, {
		waiter <- waiter::Waiter$new()
		waiter$show()
		on.exit(waiter$hide())
		
		Sys.sleep(sample(5, 1))
		runif(1)
	})
	output$result <- renderText(round(data(), 2))
}
