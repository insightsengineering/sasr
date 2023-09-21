#' Create SAS Session Configuration File
#'
#' @description `r lifecycle::badge("experimental")`
#' Create SAS session configuration file based on argument.
#'
#' @param name (`character`)\cr name of the configuration.
#' @param host (`character`)\cr host name of remote server.
#' @param saspath (`character`)\cr SAS executable path on remote server.
#' @param ssh (`character`)\cr executable path of ssh.
#' @param encoding (`character`)\cr encoding of the SAS session.
#' @param ... additional arguments.
#' @param sascfg (`character`)\cr target file of configuration.
#' @param options (`list`)\cr additional list of arguments to pass to `ssh` command.
#'
#' @return No return value.
#'
#' @export
#' @details
#' `host` and `saspath` are required to connect to remote SAS server. Other arguments can follow default.
#' If transferring datasets is needed and the client(running sasr) is not reachable from the server,
#' then tunnelling is required.
#' Use `tunnel = `, `rtunnel = ` to specify tunnels and reverse tunnels.
#' The values should be length 1 integer.
sascfg <- function(name = "default", host, saspath, ssh = system("which ssh", intern = TRUE),
                   encoding = "latin1", options = list("-fullstimer"), ..., sascfg = "sascfg_personal.py") {
  lst <- list(host = host, saspath = saspath, ssh = ssh, encoding = encoding, options = options)
  lst <- c(lst, list(...))
  check_list(lst, types = c("character", "integer"), names = "named")
  f <- file(sascfg, "w")
  writeLines(sprintf("SAS_config_names=['%s']", name), con = f)
  writeLines(sprintf("%s=%s", name, toString(r_to_py(lst))), f)
  close(f)
  invisible()
}
