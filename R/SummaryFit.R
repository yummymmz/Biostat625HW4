#' Summarize an OLS fitted model
#'
#' @description
#' Produces a summary of a fitted `"OLS"` object returned by `lm_fit()`,
#' including regression coefficients, standard errors, t values, p values,
#' R², adjusted R², residual standard error, and F‑statistic.
#'
#' @param object An object of class `"OLS"` (from `lm_fit()`).
#' @param digits Number of significant digits to print.
#' @param signif.stars Logical; if `TRUE`, include significance stars.
#' @param ... Additional arguments (ignored).
#'
#' @return
#' Invisibly returns `object`. The summary is printed to the console.
#'
#' @examples
#' set.seed(42)
#' df <- data.frame(x1 = rnorm(100), x2 = rnorm(100))
#' df$y <- 2 + 1.5 * df$x1 - 3 * df$x2 + rnorm(100, sd = 0.5)
#' fit <- lm_fit(y ~ x1 + x2, data = df)
#' summary(fit)
#'
#' @importFrom stats quantile printCoefmat
#'
#' @export
summary.OLS <- function(object,
                        digits = max(3L, getOption("digits") - 3L),
                        signif.stars = getOption("show.signif.stars", TRUE),
                        ...) {

  cat("\nCall:\n")
  print(object$formula)

  cat("\nResiduals:\n")
  res <- object$residuals
  rq <- quantile(res)
  rq_table <- c(Min = rq[1], `1Q` = rq[2], Median = rq[3], `3Q` = rq[4], Max = rq[5])
  print(round(rq_table, digits))

  cat("\nCoefficients:\n")
  coef_names <- names(object$coefficients)

  coef_table <- cbind(
    Estimate    = object$coefficients,
    "Std. Error" = object$se,
    "t value"    = object$t.value,
    "Pr(>|t|)"   = object$p.value
  )
  rownames(coef_table) <- coef_names

  printCoefmat(coef_table, digits = digits, signif.stars = signif.stars)

  cat("\nResidual standard error:", round(object$sigma, 5),
      "on", object$df.residual, "degrees of freedom")
  cat("\nMultiple R-squared:", round(object$r.squared, 5),
      ", Adjusted R-squared:", round(object$adj.r.squared, 5))
  cat("\nF-statistic:", round(object$F_test$statistic, 4), "on",
      object$F_test$numdf, "and", object$F_test$dendf,
      "DF,  p-value:", format.pval(object$F_test$p.value, digits = 4))
  cat("\n")

  invisible(object)
}
