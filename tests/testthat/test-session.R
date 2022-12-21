# get_sas_session ----

test_that("get_sas_session returns the .sas_session", {
  .sasr_env$.sas_session <- "test" # not a real session
  expect_identical(.sasr_env$.sas_session, get_sas_session())
})
