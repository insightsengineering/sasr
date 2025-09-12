# knitr engin ----
test_that("rmarkdown engine works", {
  .sasr_env$.sas_session <- dummy_session
  skip_on_cran()
  expect_snapshot(
    rmarkdown::render(system.file("example.Rmd", package = "sasr"), quiet = TRUE, output_dir = tempdir()),
  )
})
