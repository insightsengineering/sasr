# validate_data ----

test_that("validate_data will give errors if . exist", {
  df <- data.frame(
    a.1 = 1
  )
  df2 <- data.frame(
    a = 1,
    b = 2
  )
  expect_error(validate_data(df), "a\\.1 contains illegal characters that is not allowed\\.")
  expect_silent(validate_data(df2))
})

test_that("validate_data drop row names and give warnings", {
  df <- data.frame(
    a = 1,
    b = 2
  )
  row.names(df) <- "test"
  expect_warning(
    {
      df2 <- validate_data(df)
    },
    "row\\.names is not supported in SAS and will be dropped"
  )
  expect_identical(row.names(df2), "1")
})

# validate_ssh_with_tunnel ----
test_that("validate_ssh_with_tunnel works as expected for a dummy session", {
  session <- list(sascfg = list(SAScfg = list(SAS_config_names = "a", a = list(tunnel = 123L, rtunnel = 321L))))
  expect_silent(validate_ssh_with_tunnel(session))
})

test_that("validate_ssh_with_tunnel fails when either tunnel or rtunnle is not there", {
  session <- list(sascfg = list(SAScfg = list(SAS_config_names = "a", a = list(tunnel = 123L))))
  expect_error(validate_ssh_with_tunnel(session, "wrong"), "wrong")
  session <- list(sascfg = list(SAScfg = list(SAS_config_names = "a", a = list(rtunnel = 123L))))
  expect_error(validate_ssh_with_tunnel(session, "wrong"), "wrong")
})

# validate_sascfg ----

test_that("validate_sascfg works if file exists", {
  tmp <- tempfile()
  s <- file.create(tmp)
  on.exit(file.remove(tmp))
  expect_silent(validate_sascfg(tmp))
})

test_that("validate_sascfg warns if given NULL", {
  expect_warning(validate_sascfg(NULL), "No SAS configuration file specified.")
})

test_that("validate_sascfg errors if given non-existing file", {
  tmp <- tempfile()
  expect_error(validate_sascfg(tmp), "must exist to establish a connection")
})

# get_sas_cfg ----

test_that("get_sas_cfg works as expected", {
  if (!file.exists("sascfg_personal.py")) {
    file.create("sascfg_personal.py")
    on.exit(file.remove("sascfg_personal.py"))
  }
  options(sascfg = NULL)
  expect_identical(get_sas_cfg(), "sascfg_personal.py")

  skip_on_cran()
  skip_on_ci()
  tmp <- tempfile(tmpdir = "~")
  tmp_name <- basename(tmp)
  if (!file.exists(tmp)) {
    file.create(tmp)
    on.exit(file.remove(tmp))
  }
  options(sascfg = tmp_name)
  s <- file.create(tmp)
  on.exit(file.remove(tmp))
  expect_identical(get_sas_cfg(), tmp)
})

# install_saspy ----

test_that("install_saspy works", {
  skip_if_not_installed("mockery")
  mockery::stub(install_saspy, "askYesNo", function(...) TRUE)
  mockery::stub(install_saspy, "reticulate::py_install", function(...) TRUE)
  expect_identical(
    install_saspy(),
    TRUE
  )

  mockery::stub(install_saspy, "askYesNo", function(...) FALSE)
  expect_error(
    install_saspy(),
    "Installation of saspy cancelled"
  )
})

# get_sas_session ----

test_that("get_sas_session works", {
  skip_if_not_installed("mockery")
  .sasr_env$.sas_session <- NULL
  mockery::stub(get_sas_session, "sas_session_ssh", function(...) TRUE)
  expect_true(
    get_sas_session()
  )
  .sasr_env$.sas_session <- NULL
  mockery::stub(get_sas_session, "sas_session_ssh", function(...) NULL)
  expect_error(
    get_sas_session(),
    "SAS session not established"
  )
  .sasr_env$.sas_session <- NULL
})

# sas_session_ssh ----

test_that("sas_session_ssh works", {
  skip_if_not_installed("mockery")
  mockery::stub(sas_session_ssh, "saspy$SASsession", function(...) TRUE)
  mockery::stub(sas_session_ssh, "validate_sascfg", function(...) TRUE)
  expect_true(sas_session_ssh("test"))
})

# get_sas_cfg ----

test_that("get_sas_cfg works", {
  options("sascfg" = "non_existing_file")
  on.exit({options(sascfg = NULL)})
  expect_null(get_sas_cfg())
})
