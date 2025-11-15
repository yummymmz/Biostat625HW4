test_that("predict.OLS generates expected predictions", {
  data(mtcars)
  fit <- lm_fit(mpg ~ wt + hp, mtcars)

  preds <- predict(fit, newdata = mtcars)
  expect_length(preds, nrow(mtcars))
  expect_true(all(is.finite(preds)))
})
