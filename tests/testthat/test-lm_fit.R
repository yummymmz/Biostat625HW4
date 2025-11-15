test_that("lm_fit returns correct structure", {
  data(mtcars)
  fit <- lm_fit(mpg ~ wt + hp, mtcars)

  expect_s3_class(fit, "OLS")
  expect_true(all(c("coefficients", "fitted.values") %in% names(fit)))
  expect_equal(length(fit$fitted.values), nrow(mtcars))
})
