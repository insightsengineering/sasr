#' Run SAS Code with SAS Session
#'
#' @param sas_code (`character`)\cr sas code to be executed.
#' @param results (`character`)\cr sas code execution results type.
#' @param sas_session (`saspy.sasbase.SASsession`) SAS session.
#'
#' @return a list with name `LST` and `LOG`.
#' @export
#' @details `run_sas` will run sas code through SAS session.
#' The results is a named list of `LST` and `LOG`.
#' The result part will be stored in `LST`, and log will be stored in `LOG`.
#' If `results` argument is "TEXT", then results are in text format;
#' if `results` argument is "HTML", then results are in html format.
#'
run_sas <- function(sas_code, results = c("TEXT", "HTML"), sas_session = get_sas_session()) {
  results <- match.arg(results)
  sas_session$submit(code = sas_code, results = results)
}
#' Transfer data.frame to SAS data
#'
#' @param df (`data.frame`)\cr data frame to be transferred.
#' @param table (`character`)\cr table name in SAS.
#' @param libref (`character`)\cr library name in SAS.
#' @param sas_session (`saspy.sasbase.SASsession`) SAS session.
#' @param ... additional arguments for `saspy.sasbase.SASsession.df2sd`
#'
#' @export
df2sd <- function(df, table = "_df", libref = "", ..., sas_session = get_sas_session()) {
  validate_ssh_with_tunnel(sas_session)
  validate_data_names(df)
  sas_session$df2sd(df, table = table, libref = libref, ...)
}

#' Transfer SAS data to R
#'
#' @param table (`character`)\cr table name in SAS.
#' @param libref (`character`)\cr library name in SAS.
#' @param sas_session (`saspy.sasbase.SASsession`) SAS session.
#' @param ... additional arguments for `saspy.sasbase.SASsession.sd2df`
#' @export
sd2df <- function(table, libref = "", ..., sas_session = get_sas_session()) {
  validate_ssh_with_tunnel(sas_session)
  sas_session$sd2df(table = table, libref = libref, ...)
}
