#' Install `saspy` module
#'
#' @param method (`character`)\cr method to install `saspy`.
#' @param conda (`character`)\cr path to `conda` executable.
#'
#' @export
install_saspy <- function(method = "auto", conda = "auto") {
  msg <- paste0(
    "Before installing saspy, please read and confirm that you will ",
    "comply to the lincense of saspy:\n",
    "https://github.com/sassoftware/saspy/blob/main/LICENSE.md\n",
    "I have read the license and confirm that I will comply to the lincense:"
  )
  accept <- askYesNo(msg)
  if (!identical(accept, TRUE)) {
    stop("Installation of saspy cancelled.")
  }
  reticulate::py_install("saspy", method = method, conda = conda)
}

#' Validate the SAS ssh session is using tunnels
#'
#' @param session (`saspy.sasbase.SASsession`) SAS session.
#' @param msg (`character`)\cr message to display.
#'
#' @description SAS session must enable tunnles to transfer datasets. If not used, a error will pop up.
#'
#' @keywords internal
validate_ssh_with_tunnel <- function(session, msg = "SAS session through ssh must use tunnels to transfer datasets!") {
  cfgname <- session$sascfg$SAScfg$SAS_config_names[1]
  cfg <- session$sascfg$SAScfg[[cfgname]]
  if (is.null(cfg$tunnel) || is.null(cfg$rtunnel)) {
    stop(msg)
  }
}

#' Validate data frame names are valid in SAS
#'
#' @param data (`data.frame`)\cr data.frame to be checked.
#'
#' @keywords internal
#'
#' @details
#' In SAS, the variable names should be consist of letters, numbers and underscore.
#' Other characters are not allowed.
validate_data_names <- function(data) {
  nms <- colnames(data)
  nms_check <- grepl("^[a-zA-Z_]+(\\w+)?$", nms)
  if (!all(nms_check)) {
    stop(
      "SAS data frame must only contain letters, numbers and underscore, and must not start with numbers!\n",
      toString(nms[!nms_check]),
      " contains illegal characters that is not allowed.\n"
    )
  }
}

#' Validate sas configuration file is valid
#'
#' @param sascfg (`character`)\cr file path of configuration.
#'
#' @keywords internal
#'
#' @details
#' Currently, only the file existence check is conducted and the rest
#' is checked at python side.
validate_sascfg <- function(sascfg) {
  if (!file.exists(sascfg)) {
    stop(
      sascfg,
      " must exist in current working directory to establish connections!\n",
      "use `sascfg()` to create this file and modify its content accordingly!"
    )
  }
}

#' Get the last/default SAS session
#'
#' @details this function is designed to facilitate the R users programming practice
#' of function oriented programming instead of object oriented programmings.
#'
#' @export
get_sas_session <- function() {
  if (is.null(.sasr_env$.sas_session)) {
    .sasr_env$.sas_session <- sas_session_ssh(sascfg = "sascfg_personal.py")
  }
  if (is.null(.sasr_env$.sas_session)) {
    stop(
      "SAS session not established! Please review the python part and update ",
      "sascfg_personal.py accordingly.\n",
      "You can also use other configuration files, and use `sas_session_ssh(sascfg =)` to do so.\n"
    )
  }
  return(.sasr_env$.sas_session)
}

#' Create sas_session based on configuration file
#'
#' @param sascfg (`character`)\cr SAS session configuration.
#'
#' @export
sas_session_ssh <- function(sascfg = "sascfg_personal.py") {
  validate_sascfg(sascfg)
  sas <- saspy$SASsession(cfgfile = sascfg)
  .sasr_env$.sas_session <- sas
  return(sas)
}
