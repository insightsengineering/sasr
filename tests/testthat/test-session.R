# get_sas_session ----

test_that("get_sas_session returns the .sas_session", {
  sasr_env$.sas_session <- "test"
  expect_identical(.sas_session, get_sas_session())
})