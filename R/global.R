# Load .env and data used by the app
if (!requireNamespace("dotenv", quietly = TRUE)) {
  stop("Please install the 'dotenv' package and restart the app.")
}
dotenv::load_dot_env(".env")

DATA_PATH <- file.path("Data")
crime_file <- list.files(DATA_PATH, pattern = "\\.csv$", full.names = TRUE)[1]

if (!is.null(crime_file) && nzchar(crime_file)) {
  if (!requireNamespace("readr", quietly = TRUE) || !requireNamespace("dplyr", quietly = TRUE) || !requireNamespace("tibble", quietly = TRUE)) {
    stop("Please install 'readr', 'dplyr', and 'tibble' packages.")
  }
  crime <- readr::read_csv(crime_file, guess_max = 10000, show_col_types = FALSE)
} else {
  crime <- tibble::tibble()
}

GEMINI_API_KEY <- Sys.getenv("GOOGLE_API_KEY", unset = "")
invisible(TRUE)