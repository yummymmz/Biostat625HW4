#' Fit an Ordinary Least Squares (OLS) Regression Model
#'
#' @description
#' `lm_fit()` fits a linear model by **Ordinary Least Squares (OLS)**
#' using a numerically stable **QR decomposition** implemented in C++
#' via RcppArmadillo.
#' It estimates regression coefficients, fitted values, residuals,
#' and common summary statistics such as the residual variance,
#' R-squared, adjusted R-squared, t-tests and an overall F-test.
#'
#'
#' @usage
#' lm_fit(formula, data, na.action = na.omit)
#'
#'
#' @param formula
#' a model formula of the form `y ~ x1 + x2 + ...` specifying the
#' dependent and explanatory variables.
#'
#' @param data
#' a `data.frame` containing the variables in the model.
#' Variables not found in `data` are taken from the environment
#' of `formula`.
#'
#' @param na.action
#' a function defining how to handle missing values.
#' Defaults to `na.omit`, which removes observations with `NA`s
#' prior to model fitting.
#'
#' @details
#' The function constructs the model frame and design matrix internally
#' using `model.frame()` and `model.matrix()`.
#' Coefficients are obtained by solving the normal equations
#' \deqn{X'X β = X'y} through the QR decomposition
#' (computed in C++ for numerical stability).
#'
#' The residual variance is estimated as \eqn{σ² = SSE / (n − p)}.
#' Standard errors, t‑statistics (\eqn{t = β̂ / SE}),
#' two‑sided p‑values, R², adjusted R² and overall F‑statistics are reported.
#'
#' @return
#' An object of class `"OLS"` containing:
#' \itemize{
#'   \item \code{coefficients} – estimated regression coefficients;
#'   \item \code{se} – standard errors of the coefficients;
#'   \item \code{t.value}, \code{p.value} – t‑statistics and p‑values;
#'   \item \code{r.squared}, \code{adj.r.squared} – model fit statistics;
#'   \item \code{sigma2}, \code{sigma} – residual variance and standard error;
#'   \item \code{df.residual} – residual degrees of freedom;
#'   \item \code{F_test} – list with F‑statistic, p‑value, and degrees of freedom;
#'   \item \code{fitted.values} – fitted response values;
#'   \item \code{residuals} – residual vector;
#'   \item \code{formula} – model formula used for the fit.
#' }
#'
#' @author
#' Developed for Biostat 625 as a teaching example of implementing OLS in R with Rcpp.
#'
#' @references
#' Chambers J.M. (1992) *Linear Models*, in *Statistical Models in S*,
#' Wadsworth & Brooks/Cole.
#' Wilkinson G.N. & Rogers C.E. (1973). *Symbolic Descriptions of Factorial Models for Analysis of Variance*,
#' *Applied Statistics*, 22, 392–399.
#'
#' @seealso
#' \code{\link[stats]{lm}} for the full‑featured base R implementation.
#' \code{\link{summary.OLS}} for summarizing OLS results.
#' \code{\link{predict.OLS}} for prediction on new data.
#'
#' @examples
#' set.seed(42)
#' df <- data.frame(
#'   x1 = rnorm(100),
#'   x2 = rnorm(100)
#' )
#' df$y <- 2 + 1.5*df$x1 - 3*df$x2 + rnorm(100, sd = 0.5)
#'
#' # Fit OLS model
#' fit <- lm_fit(y ~ x1 + x2, data = df)
#'
#' # Inspect results
#' fit$coefficients
#'
#' # Summarize
#' summary(fit)
#'
#' # Prediction
#' predict(fit)
#'
#' @useDynLib LinearRegression, .registration = TRUE
#' @importFrom Rcpp sourceCpp
#' @importFrom stats model.frame model.response model.matrix pf pt na.omit delete.response terms
#'
#'
#' @export
lm_fit <- function(formula, data, na.action = na.omit) {
  ## your implementation (already written)
}


lm_fit <- function(formula, data, na.action = na.omit) {
  mf <- model.frame(formula, data, na.action = na.omit)
  y <- model.response(mf)
  X <- model.matrix(attr(mf, "terms"), mf)

  # beta_hat by QR
  res <- lm_qr_extended_cpp(X, y)
  beta_hat <- res$beta
  beta_hat <- as.vector(beta_hat)
  names(beta_hat) <- colnames(X)

  # y_hat & residuals
  y_hat <- as.vector(X %*% beta_hat)
  residuals <- as.vector(y - y_hat)

  # df
  df_residual <- nrow(X) - ncol(X)
  df_SST <- nrow(X) - 1
  df_SSR <- ncol(X) - 1

  # SSE & sigma
  SSE <- sum(residuals^2)
  sigma2 <- SSE / df_residual
  sigma <- sqrt(sigma2)

  # R^2 & adj R^2
  SST <- sum((y - mean(y))^2)
  r_squared <- 1 - SSE/SST
  adj_r_squared <- 1 - SSE / SST * df_SST /df_residual

  # t_value & p_value
  Rmat <- res$R
  Rinv <- solve(Rmat)
  XtX_inv <- Rinv %*% t(Rinv)
  se <- sqrt(diag(sigma2 * XtX_inv))
  t_val <- as.vector(beta_hat) / se
  p_val <- 2 * (1 - pt(abs(t_val), df_residual))

  # F_value & p_value
  p <- ncol(X)
  msr <- (SST - SSE) / (p - 1)
  mse <- SSE / df_residual
  F_stat <- msr / mse
  p_F <- 1 - pf(F_stat, p - 1, df_residual)

  terms_obj <- terms(formula, data = data)
  attr(terms_obj, ".Environment") <- environment(formula)

  # output class
  structure(
    list(
      coefficients = beta_hat,
      se = se,
      t.value = t_val,
      p.value = p_val,
      r.squared = r_squared,
      adj.r.squared = adj_r_squared,
      sigma2 = sigma2,
      sigma = sigma,
      df.residual = df_residual,
      F_test = list(statistic = F_stat, p.value = p_F,
               numdf = p - 1, dendf = df_residual),
      fitted.values = y_hat,
      residuals = residuals,
      na.action = class(na.action),
      formula = formula,
      terms = terms_obj
    ),
    class = "OLS"
  )
}

