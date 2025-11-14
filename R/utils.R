`%||%` <- function(x, y) if (is.null(x)) y else x

safe_require <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(sprintf("Package '%s' required. Install with install.packages('%s')", pkg, pkg))
  }
  invisible(TRUE)
}