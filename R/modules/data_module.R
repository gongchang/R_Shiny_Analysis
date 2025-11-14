# Data module: offense filter + leaflet map

data_ui <- function(id) {
  ns <- shiny::NS(id)
  choices <- c("All")
  if (exists("crime") && nrow(crime) > 0 && "offense" %in% names(crime)) {
    choices <- c(choices, sort(unique(na.omit(crime$offense))))
  }
  shiny::tagList(
    shiny::selectInput(ns("offense"), "Offense (filter)", choices = choices, selected = "All"),
    leaflet::leafletOutput(ns("map"), height = 520)
  )
}

data_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    filtered <- shiny::reactive({
      if (!exists("crime") || nrow(crime) == 0) return(crime)
      df <- crime
      if (!is.null(input$offense) && input$offense != "All" && "offense" %in% names(df)) {
        df <- df |> dplyr::filter(.data$offense == input$offense)
      }
      df
    })

    output$map <- leaflet::renderLeaflet({
      df <- filtered()
      m <- leaflet::leaflet() |> leaflet::addTiles()
      if (nrow(df) > 0 && all(c("longitude", "latitude") %in% names(df))) {
        m <- m |> leaflet::addCircleMarkers(
          lng = df$longitude,
          lat = df$latitude,
          popup = paste0("<b>", ifelse("offense" %in% names(df), df$offense, ""), "</b><br/>",
                         ifelse("address" %in% names(df), df$address, "")),
          radius = 4, fillOpacity = 0.8
        )
      }
      m
    })

    invisible(list(filtered = filtered))
  })
}
