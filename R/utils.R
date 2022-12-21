#' Install `saspy` Module
#'
#' @description `r lifecycle::badge("experimental")`
#' Install `saspy` module in `reticulate`.
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
    "I have read the license and confirm that I will comply to the license:"
  )
  accept <- askYesNo(msg)
  if (!identical(accept, TRUE)) {
    stop("Installation of saspy cancelled.")
  }
  reticulate::py_install("saspy", method = method, conda = conda)
}

#' Validate the SAS ssh Session Has Tunnels
#'
#' @description `r lifecycle::badge("experimental")`
#' Validate if the SAS session has tunnels enabled.
#'
#' @param session (`saspy.sasbase.SASsession`) SAS session.
#' @param msg (`character`)\cr message to display.
#'
#' @description SAS session must enable tunnels to transfer datasets. If not used, a error will pop up.
#'
#' @keywords internal
validate_ssh_with_tunnel <- function(session, msg = "SAS session through ssh must use tunnels to transfer datasets!") {
  cfgname <- session$sascfg$SAScfg$SAS_config_names[1]
  cfg <- session$sascfg$SAScfg[[cfgname]]
  if (is.null(cfg$tunnel) || is.null(cfg$rtunnel)) {
    stop(msg)
  }
}

#' Validate and Process `data.frame` for SAS
#'
#' @description `r lifecycle::badge("experimental")`
#' Validate if data contains validate variable names in SAS, and
#' remove possible row names.
#'
#' @param data (`data.frame`)\cr data.frame to be checked.
#'
#' @keywords internal
#'
#' @details
#' In SAS, the variable names should be consist of letters, numbers and underscore.
#' Other characters are not allowed.
#' In addition, in SAS, row names(index) are not allowed.
#'
#' @return `data.frame`\cr
validate_data <- function(data) {
  nms <- colnames(data)
  nms_check <- grepl("^[a-zA-Z_]+(\\w+)?$", nms)
  if (!all(nms_check)) {
    stop(
      "SAS data frame must only contain letters, numbers and underscore, and must not start with numbers!\n",
      toString(nms[!nms_check]),
      " contains illegal characters that is not allowed.\n"
    )
  }
  if (!identical(row.names(data), as.character(seq_len(nrow(data))))) {
    warning(
      "row.names is not supported in SAS and will be dropped, ",
      "Please consider create a column to hold the row names.",
      call. = FALSE)
    row.names(data) <- NULL
  }
  return(data)
}

#' Validate SAS Configuration File Exist
#'
#' @description `r lifecycle::badge("experimental")`
#' Validate if SAS configuration file exist.
#'
#' @param sascfg (`character`)\cr file path of configuration.
#'
#' @keywords internal
#'
#' @details
#' Currently, only the file existence check is conducted and the rest
#' is checked at python side.
validate_sascfg <- function(sascfg) {
  if (is.null(sascfg)) {
    warning(
      "No SAS configuration file specified. By default the configuration file under ",
      " saspy installation path will be used. This is usually not a real accessible SAS configuration."
    )
    return()
  }
  if (!file.exists(sascfg)) {
    stop(
      sascfg,
      " must exist to establish a connection.\n",
      "Use `sascfg()` to create this file and modify its content accordingly!"
    )
  }
}

#' Get the Last or Default SAS Session
#'
#' @description `r lifecycle::badge("experimental")`
#' Obtain the last session or default session.
#'
#' @details this function is designed to facilitate the R users programming practice
#' of function oriented programming instead of object oriented programmings.
#'
#' @export
get_sas_session <- function() {
  if (is.null(.sasr_env$.sas_session)) {
    .sasr_env$.sas_session <- sas_session_ssh(sascfg = get_sas_cfg())
  }
  if (is.null(.sasr_env$.sas_session)) {
    stop(
      "SAS session not established! Please review the python part and update ",
      getOption("sascfg"),
      " accordingly.\n",
      "You can also set the default sas cofiguration file using `options(sascfg = )` ",
      "to allow other files to be used, ",
      "or use `sas_session_ssh(sascfg =)` to choose the configuration file manually.\n"
    )
  }
  return(.sasr_env$.sas_session)
}

#' Create SAS ssh Session Based on Configuration File
#'
#' @description `r lifecycle::badge("experimental")`
#' Create a SAS ssh session.
#'
#' @param sascfg (`character`)\cr SAS session configuration.
#'
#' @export
sas_session_ssh <- function(sascfg = get_sas_cfg()) {
  validate_sascfg(sascfg)
  sas <- saspy$SASsession(cfgfile = sascfg)
  .sasr_env$.sas_session <- sas
  return(sas)
}

#' Obtain the SAS Configuration File
#'
#' @description `r lifecycle::badge("experimental")`
#' Obtain the file path of the SAS configuration file.
#'
#' @details Obtain the default sas configuration file. By default, it will search
#' the `sascfg_personal.py` file under current directory. If it does not exist, it will
#' search this file under home directory. If this file does not exist, NULL will be returned.
#'
#' @export
get_sas_cfg <- function() {
  default_cfg <- getOption("sascfg", "sascfg_personal.py")
  if (file.exists(default_cfg)) {
    return(default_cfg)
  }
  if (file.exists(file.path("~", default_cfg))) {
    return(file.path("~", default_cfg))
  }
  return(NULL)
}
