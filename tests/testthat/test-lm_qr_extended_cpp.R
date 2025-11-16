test_that("lm_qr_extended_cpp throws error for size mismatch", {
  X <- matrix(rnorm(10 * 2), nrow = 10, ncol = 2)
  y <- rnorm(9)

  expect_error(lm_qr_extended_cpp(X, y),
               "Number of rows in X must match length of y.")
})
