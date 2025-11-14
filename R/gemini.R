safe_gemini_chat <- function(prompt, ...) {
  if (!exists("GEMINI_API_KEY") || !nzchar(GEMINI_API_KEY)) {
    return(list(text = "GOOGLE_API_KEY not set in .env — Gemini unavailable."))
  }
  if (requireNamespace("ellmer", quietly = TRUE)) {
    res <- tryCatch({
      # try common ellmer interface (may need adapting if ellmer API differs)
      if (isTRUE(requireNamespace("ellmer", quietly = TRUE))) {
        if (exists("chat", envir = asNamespace("ellmer"), inherits = FALSE)) {
          out <- ellmer::chat(prompt = prompt)
          return(list(text = as.character(out), raw = out))
        }
        if (exists("chat_completion", envir = asNamespace("ellmer"), inherits = FALSE)) {
          out <- ellmer::chat_completion(prompt = prompt)
          return(list(text = as.character(out), raw = out))
        }
      }
      list(text = "ellmer installed but API shape not recognized.")
    }, error = function(e) list(text = paste("Error calling ellmer:", conditionMessage(e))))
    return(res)
  }
  list(text = "ellmer not installed. Install 'ellmer' or configure direct HTTP fallback in R/gemini.R")
}