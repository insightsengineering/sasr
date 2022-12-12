# validate_data_names ----

test_that("validate_data_names will give errors if . exist", {
  df <- data.frame(
    a.1 = 1
  )
  df2 <- data.frame(
    a = 1,
    b = 2
  )
  expect_error(validate_data_names(df), "a\\.1 contains illegal characters that is not allowed\\.")
  expect_silent(validate_data_names(df2))
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
