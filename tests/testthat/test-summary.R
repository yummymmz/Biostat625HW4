test_that("summary.OLS prints output and returns correct data", {
  data(mtcars)
  fit <- lm_fit(mpg ~ wt + hp, mtcars)
  summ <- summary(fit)

  expect_true(is.list(summ) || is.data.frame(summ))
  expect_true(any(grepl("Residual", capture.output(summary(fit)))))
})
