# validate_data_names ---

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