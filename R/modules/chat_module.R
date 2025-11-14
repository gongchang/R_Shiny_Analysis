chat_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::uiOutput(ns("history_ui")),
    shiny::textAreaInput(ns("prompt"), "Message", rows = 4, width = "100%"),
    shiny::actionButton(ns("send"), "Send")
  )
}

chat_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    # Reactive value to store chat history
    history <- shiny::reactiveVal(list())

    # Render the chat history UI
    output$history_ui <- shiny::renderUI({
      msgs <- history()
      if (length(msgs) == 0) {
        shiny::div(class = "chat-history", "No messages yet.")
      } else {
        shiny::tagList(
          lapply(seq_along(msgs), function(i) {
            m <- msgs[[i]]
            cls <- if (m$role == "user") "msg-user" else "msg-assistant"
            shiny::div(class = paste("chat-msg", cls),
                       shiny::strong(sprintf("%s: ", m$role)),
                       shiny::div(style = "white-space: pre-wrap;", m$text)
            )
          })
        )
      }
    })

    # Observe the "Send" button and process user input
    shiny::observeEvent(input$send, {
      req(input$prompt)  # Ensure the input is not empty
      user_text <- input$prompt
      message("User input: ", user_text)  # Debugging log

      # Append the user's message to the chat history
      history(c(history(), list(list(role = "user", text = user_text))))

      # Clear the input field
      shiny::updateTextAreaInput(session, "prompt", value = "")

      # Call the Gemini API (or fallback) to get the assistant's response
      res <- tryCatch(
        safe_gemini_chat(user_text),
        error = function(e) {
          message("Error in safe_gemini_chat: ", conditionMessage(e))  # Debugging log
          list(text = paste("Error:", conditionMessage(e)))
        }
      )

      # Append the assistant's response to the chat history
      assistant_text <- as.character(res$text %||% "")
      message("Assistant response: ", assistant_text)  # Debugging log
      history(c(history(), list(list(role = "assistant", text = assistant_text))))
    })

    # Return the reactive history for external use
    shiny::reactive(history())
  })
}