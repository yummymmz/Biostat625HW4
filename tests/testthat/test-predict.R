test_that("predict.OLS generates expected predictions", {
  data(mtcars)
  fit <- lm_fit(mpg ~ wt + hp, mtcars)
  preds <- predict(fit, newdata = mtcars)

  preds_nonewdata <- predict(fit)
  expect_equal(preds_nonewdata, fit$fitted.values, tolerance = 1e-6)
  expect_length(preds, nrow(mtcars))
  expect_true(all(is.finite(preds)))
})
