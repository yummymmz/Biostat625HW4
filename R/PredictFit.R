#' Predict method for OLS models
#'
#' @description
#' Generate fitted or predicted values from a fitted `"OLS"` model.
#'
#' @param object An `"OLS"` object returned by `lm_fit()`.
#' @param newdata An optional `data.frame` containing predictor variables.
#'   If omitted, the original fitted values are returned.
#' @param ... Ignored.
#' @return Numeric vector of predicted values.
#' @examples
#' set.seed(42)
#' df <- data.frame(x1 = rnorm(100), x2 = rnorm(100))
#' df$y <- 2 + 1.5*df$x1 - 3*df$x2 + rnorm(100, sd = 0.5)
#' fit <- lm_fit(y ~ x1 + x2, df)
#' predict(fit)
#'
#' @importFrom stats delete.response terms
#'
#' @export
#'
predict.OLS <- function(object, newdata = NULL, ...) {
  if (is.null(newdata)) {
    return(object$fitted.values)
  } else {
    terms_tmp <- delete.response(object$terms)
    attr(terms_tmp, ".Environment") <- NULL
    X_new <- model.matrix(terms_tmp, newdata)
    as.vector(X_new %*% object$coefficients)
  }
}
