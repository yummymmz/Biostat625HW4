
<!-- README.md is generated from README.Rmd. Please edit that file -->

# LinearRegression

<!-- badges: start -->

[![R-CMD-check](https://github.com/yummymmz/Biostat625HW4/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yummymmz/Biostat625HW4/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/yummymmz/Biostat625HW4/graph/badge.svg)](https://app.codecov.io/gh/yummymmz/Biostat625HW4)
<!-- badges: end -->

`LinearRegression` is an R package that implements Ordinary Least
Squares (OLS) regression using both R and C++ (via **Rcpp**) for
improved computational efficiency.  
It provides lightweight and flexible functions for **model fitting**,
**prediction**, and **model summarization**, mirroring the functionality
of R’s built‑in `lm()` function.

This package is developed as part of **Biostat 625 Homework \#4**, with
the goal of demonstrating how to build an R package from scratch and
compare the implementation against the original R base functions in
terms of **correctness** (via `all.equal()`) and **efficiency** (via
`microbenchmark()`).

Key features include:

### **Required components**

1.  **A complete R package**, including well‑documented R source code
    (`R/`), function help pages (`man/`), and working examples that run
    without errors or warnings.
2.  **Public GitHub repository** hosting the package, with a clearly
    written `README.md` file introducing its purpose, installation, and
    usage.
3.  **Comprehensive vignette(s)** written in R Markdown that demonstrate
    the usage of the core functions (e.g., model fitting, prediction,
    summary).
4.  **Comparison(s) against R’s base `lm()` function** on simulated
    datasets are included in the vignette
    [`vignettes/comparison.Rmd`](vignettes/comparison.Rmd),
    demonstrating both the  
    *numerical correctness* (checked with `all.equal()`) and the
    *computational efficiency* (evaluated using `microbenchmark()`).

### **Optional bonus components**

1.  **C++ integration via Rcpp**, providing a fast and efficient
    implementation of **QR decomposition** for solving the Ordinary
    Least Squares (OLS) problem. The C++ function `lm_qr_extended_cpp()`
    is called internally by `lm_fit()`.
2.  **Unit testing** implemented with the **testthat** framework to
    verify correctness of all major functions.
3.  **Continuous integration (CI)** configured on GitHub using **GitHub
    Actions**, ensuring that all tests are automatically executed for
    every commit and pull request.
4.  **Code coverage monitoring** integrated via **Codecov**, verifying
    that all R and C++ code paths are exercised during testing (100%
    coverage).

------------------------------------------------------------------------

## Installation

You can install the development version of **LinearRegression** directly
from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("yummymmz/Biostat625HW4")
```

After installation, load the package:

``` r
library(LinearRegression)
```

------------------------------------------------------------------------

## Example

Here is a short example that demonstrates how to fit and summarize a
model using `lm_fit()`, `summary.OLS()`, and `predict.OLS()`:

``` r
library(LinearRegression)
# Use built-in mtcars data
data(mtcars)

# Fit the model using lm_fit()
fit <- lm_fit(mpg ~ wt + hp, data = mtcars)

# Show coefficients and summary
summary(fit)
#> 
#> Call:
#> mpg ~ wt + hp
#> <environment: 0x1222f8d10>
#> 
#> Residuals:
#>     Min.0%     1Q.25% Median.50%     3Q.75%   Max.100% 
#>    -3.9410    -1.6002    -0.1820     1.0499     5.8538 
#> 
#> Coefficients:
#>             Estimate Std. Error t value Pr(>|t|)    
#> (Intercept) 37.22727    1.59879  23.285  < 2e-16 ***
#> wt          -3.87783    0.63273  -6.129 1.12e-06 ***
#> hp          -0.03177    0.00903  -3.519  0.00145 ** 
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 2.59341 on 29 degrees of freedom
#> Multiple R-squared: 0.82679 , Adjusted R-squared: 0.81484
#> F-statistic: 69.2112 on 2 and 29 DF,  p-value: 9.109e-12

# Predict fitted values (no newdata)
head(predict(fit))
#>         Mazda RX4     Mazda RX4 Wag        Datsun 710    Hornet 4 Drive 
#>          23.57233          22.58348          25.27582          21.26502 
#> Hornet Sportabout           Valiant 
#>          18.32727          20.47382

# Predict on new data
new_data <- data.frame(wt = c(2, 3), hp = c(120, 180))
predict(fit, newdata = new_data)
#> [1] 25.65885 19.87465
```

------------------------------------------------------------------------

## Learning more

A detailed tutorial and performance comparison with R’s `lm()` are
included in the vignette `vignettes/getting_started.Rmd` and
`vignettes/comparison.Rmd`.

``` r
browseVignettes("LinearRegression")
```

------------------------------------------------------------------------

## Citation

If you use **LinearRegression** in coursework or research, please cite
this repository: \> Jiamin (2025). *LinearRegression: Simple OLS
Regression Implementation in R.*  
\> GitHub repository: <https://github.com/yummymmz/Biostat625HW4>

------------------------------------------------------------------------

## License

This package is released under the MIT License.
