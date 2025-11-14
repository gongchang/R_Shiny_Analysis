# App entry point: sources modules and returns shinyApp object

source(file.path("R", "global.R"))
source(file.path("R", "utils.R"))
source(file.path("R", "gemini.R"))
source(file.path("R", "modules", "chat_module.R"))
source(file.path("R", "modules", "data_module.R"))

ui <- shiny::fluidPage(
  shiny::tags$head(shiny::tags$style(HTML("
    .chat-wrap { max-width: 820px; margin: 0 auto; }
    .chat-history { border: 1px solid #ddd; padding: 8px; height: 260px; overflow-y: auto; margin-bottom: 8px; background: #fff; }
    .chat-msg { margin-bottom: 6px; }
    .msg-user { background: #eef; padding: 6px; border-radius: 4px; }
    .msg-assistant { background: #efe; padding: 6px; border-radius: 4px; }
  "))),
  shiny::titlePanel("Data Explorer + Gemini Chat"),
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::h4("Chat with Gemini"),
      chat_ui("chat1")
    ),
    shiny::mainPanel(
      shiny::h4("Map"),
      data_ui("data1")
    )
  )
)

server <- function(input, output, session) {
  chat_hist <- chat_server("chat1")
  data_server("data1")
  invisible(NULL)
}

app <- shiny::shinyApp(ui = ui, server = server)
app
