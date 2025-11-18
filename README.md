
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
    summary). The primary tutorial is provided in the vignette
    [`vignettes/getting_started.Rmd`](vignettes/getting_started.Rmd).
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
devtools::install_github("yummymmz/Biostat625HW4",build_vignettes = TRUE)
```

After installation, load the package:

``` r
library(LinearRegression)
```

Use ?lm_fit to get help page of the function. If it doesn’t show, you
can restart R and try it again.

------------------------------------------------------------------------

## Example

Here is a short example that demonstrates how to fit and summarize a
model using `lm_fit()`, `summary.OLS()`, and `predict.OLS()`:

``` r
## Example 1: using built-in dataset (mtcars)
library(LinearRegression)
data(mtcars)

# Fit OLS model
fit_mtcars <- lm_fit(mpg ~ wt + hp, data = mtcars)

# Inspect results
fit_mtcars$coefficients
#> (Intercept)          wt          hp 
#> 37.22727012 -3.87783074 -0.03177295

# Summarize
summary(fit_mtcars)
#> 
#> Call:
#> mpg ~ wt + hp
#> <environment: 0x10e07bd10>
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

# Prediction
head(predict(fit_mtcars))
#>         Mazda RX4     Mazda RX4 Wag        Datsun 710    Hornet 4 Drive 
#>          23.57233          22.58348          25.27582          21.26502 
#> Hornet Sportabout           Valiant 
#>          18.32727          20.47382

# Predict on new data
new_data <- data.frame(wt = c(2, 3), hp = c(120, 180))
predict(fit_mtcars, newdata = new_data)
#> [1] 25.65885 19.87465

## Example 2: using simulated data
set.seed(42)
df <- data.frame(
 x1 = rnorm(100),
 x2 = rnorm(100)
)
df$y <- 2 + 1.5*df$x1 - 3*df$x2 + rnorm(100, sd = 0.5)

# Fit OLS model
fit_sim <- lm_fit(y ~ x1 + x2, data = df)

# Inspect results
fit_sim$coefficients
#> (Intercept)          x1          x2 
#>    2.000883    1.428145   -2.957353

# Summarize
summary(fit_sim)
#> 
#> Call:
#> y ~ x1 + x2
#> <environment: 0x10e07bd10>
#> 
#> Residuals:
#>     Min.0%     1Q.25% Median.50%     3Q.75%   Max.100% 
#>    -1.2883    -0.3309    -0.0413     0.3185     1.2603 
#> 
#> Coefficients:
#>             Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)  2.00088    0.05095   39.27   <2e-16 ***
#> x1           1.42815    0.04894   29.18   <2e-16 ***
#> x2          -2.95735    0.05636  -52.47   <2e-16 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 0.50682 on 97 degrees of freedom
#> Multiple R-squared: 0.97313 , Adjusted R-squared: 0.97257
#> F-statistic: 1756.183 on 2 and 97 DF,  p-value: < 2.2e-16

# Prediction
predict(fit_sim)
#>           1           2           3           4           5           6 
#>  0.40713205 -1.89528614  5.48632581 -2.56191132  4.55012169  1.53728027 
#>           7           8           9          10          11          12 
#>  5.40831616  2.22752897  4.32693232  1.55891722  3.93863424  4.94693593 
#>          13          14          15          16          17          18 
#>  1.45299170  3.09388050  6.72293792  4.03980871  3.11101663 -9.78336796 
#>          19          20          21          22          23          24 
#>  2.54380066  3.48028176  5.98013583  3.80551389  1.38657113  6.68302934 
#>          25          26          27          28          29          30 
#>  4.71288503  2.65262350  3.44830887  5.47051786  6.27998157  0.55598385 
#>          31          32          33          34          35          36 
#>  0.97267742  4.46510584  3.47897547 -2.18953377 -1.53612983  2.79329827 
#>          37          38          39          40          41          42 
#>  1.22751703 -2.76759201 -0.05779998  2.20764228  2.54972880  4.11042140 
#>          43          44          45          46          47          48 
#>  4.39873821  1.05012191  1.27073534 -0.67366576  2.26456154  5.34430359 
#>          49          50          51          52          53          54 
#> -0.67615368  6.06129836  2.58099899  5.46991355  0.79951826  3.72830386 
#>          55          56          57          58          59          60 
#>  3.51265835  6.05778755  2.99396139  4.49589479 -0.69595927 -1.40037337 
#>          61          62          63          64          65          66 
#>  1.99551071  5.43505860  2.34915157  5.07265651 -0.78267424 -0.37507450 
#>          67          68          69          70          71          72 
#>  5.41626566  2.13945921  3.06474382  0.38189802  1.19069281 -0.60209439 
#>          73          74          75          76          77          78 
#>  8.05210462 -4.35721394 -1.33180943  3.27652848  7.38318023  0.76160670 
#>          79          80          81          82          83          84 
#> -0.69310921  0.44903196  3.71334006  4.09664910  1.03649679  0.95682829 
#>          85          86          87          88          89          90 
#>  1.12107651  6.82662771 -0.38158604  0.10092472  5.80709153  7.89025534 
#>          91          92          93          94          95          96 
#>  3.38289274  2.34138466  2.18261334  7.81441371  3.25112112 -2.43947378 
#>          97          98          99         100 
#> -0.80950932 -1.81753751 -3.25316219  2.55278340
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
this repository: \> Jiamin Zou (2025). *LinearRegression: Simple OLS
Regression Implementation in R.*  
\> GitHub repository: <https://github.com/yummymmz/Biostat625HW4>

------------------------------------------------------------------------

## License

This package is released under the MIT License.
