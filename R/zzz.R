#' saspy package
#' @keywords internal
saspy <- NULL
#' sasr environment to hold sas sessions
#' @keywords internal
sasr_env <- new.env()
#' onLoad function to execute on package loading
#' @keywords internal
.onLoad <- function(libname, pkgname) {
  saspy <<- import("saspy", delay_load = TRUE)
}
