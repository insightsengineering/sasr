#' saspy package
#'
#' @keywords internal
saspy <- NULL

#' sasr Environment
#'
#' @keywords internal
.sasr_env <- new.env()

#' onLoad Function
#'
#' @keywords internal
.onLoad <- function(libname, pkgname) {
  saspy <<- import("saspy", delay_load = TRUE)
}
