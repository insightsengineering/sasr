#' SAS engine function
#' @param options See knitr documentation on engines.
sas_engine <- function(options) {
  if (!requireNamespace("knitr", quietly = TRUE)) {
    stop("Please install knitr to use the SAS engine.")
  }
  if (options$eval) {
    ret <- sasr::run_sas(paste0(options$code, collapse = "\n"), results = "HTML")
    if (identical(ret$LST, "")) {
      stop(ret$LOG)
    } else {
      output <- ret$LST
      output <- gsub("<!DOCTYPE html>", "", output)
    }
  } else {
    output <- NULL
  }
  options$results <- "asis"
  knitr::engine_output(options, code = options$code, out = output)
}
