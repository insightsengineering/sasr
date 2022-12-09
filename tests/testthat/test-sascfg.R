# sascfg ----

test_that("sascfg creates sas configuration file", {
  skip_if(py_available())
  tmpf <- tempfile()
  sascfg(ssh = "ssh", sas = "sas", host = "test.com", sascfg = tmpf)
  on.exit(unlink(tmpf))
  expect_file_exists(tmpf)
})
