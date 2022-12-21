# run_sas ----

test_that("run_sas call the correct method", {
  expect_snapshot(run_sas("this is test", sas_session = dummy_session))
})

# df2sd ----
test_that("df2sd call the correct method", {
  expect_snapshot(df2sd(iris2, "iris2", "work", sas_session = dummy_session))
})

# sd2df ----

test_that("sd2df call the correct method", {
  expect_snapshot(sd2df("iris2", "work", sas_session = dummy_session))
})
