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
  options("sascfg" = "sascfg_personal.py")
  saspy <<- import("saspy", delay_load = TRUE)
  if (requireNamespace("knitr", quietly = TRUE)) {
    knitr::knit_engines$set(sas = sas_engine)
  }
}
