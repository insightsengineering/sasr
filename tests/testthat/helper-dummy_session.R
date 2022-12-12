dummy_session <- list(
  submit = function(code, results, ...) {
    cat("submit the following code: \n")
    cat(code)
    cat("\nformat of result is ", results, "\n")
  },
  df2sd = function(df, table, libref, ...) {
    df_call <- substitute(df, env = parent.frame())
    cat(sprintf("submit %s into SAS %s.%s\n", deparse(df_call), libref, table))
  },
  sd2df = function(table, libref, ...) {
    cat(sprintf("obtain SAS dataset %s.%s\n", libref, table))
  },
  sascfg = list(SAScfg = list(SAS_config_names = "a", a = list(tunnel = 123L, rtunnel = 321L)))
)

iris2 <- iris
colnames(iris2) <- gsub("\\.", "_", colnames(iris2))
