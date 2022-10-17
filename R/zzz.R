saspy <- NULL
#' onLoad function to execute on package loading
.onLoad <- function(libname, pkgname) {
  saspy <<- import("saspy", delay_load = TRUE)
  .sas_session <<- NULL
}
