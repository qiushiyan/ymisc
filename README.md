
# ymisc

<!-- badges: start -->

[![R-CMD-check](https://github.com/enixam/ymisc/workflows/R-CMD-check/badge.svg)](https://github.com/enixam/ymisc/actions)
<!-- badges: end -->

This package contains my personal miscellaneous functions.

You can install the package from Github via

``` r
remotes::install_github("enixam/ymisc")
```

## Scaffold a `bs4_book` format bookdown project with automatic deployment

``` r
use_bookdown("my-awesome-book", tempdir(), gh_action = TRUE)
```

Note that the github action for deploying the book to github pages is
designed to use `renv` for installing dependencies. So you’ll need to
run `renv::init()` in the new project directory before it can work.

## General hypothesis testing in multiple linear regression

<!-- A general hypothesis in multiple linear regression can be expressed in the following matrix form  -->
<!-- $$ -->
<!-- C\boldsymbol{\beta} = \boldsymbol{d} -->
<!-- $$ -->
<!-- where $C$ is an $m \times n$ matrix, $\boldsymbol{\beta}$ is an $p$-dimensional (including the intercept) parameter to estimate, and $\boldsymbol{d}$ is an $m$-dimensional vector. $C$ and $\boldsymbol{d}$ are specified by the hypothesis to be tested. For example, if we want to test the following hypothesis with two constraints for a linear model with 3 predictors  -->
<!-- $$ -->
<!-- \begin{aligned} -->
<!-- H_0&: \beta_1 + \beta_3 = 0 \quad \text{and} \quad \beta_2 = 3   \\ -->
<!-- H_1&: \text{otherwise}  -->
<!-- \end{aligned} -->
<!-- $$ -->
<!-- Then this hypothesis can be expressed as  -->
<!-- $$ -->
<!-- \begin{bmatrix} -->
<!-- 0 & 1 & 0 & 1 \\ -->
<!-- 0 & 0 & 1 & 0 \\ -->
<!-- \end{bmatrix} -->
<!-- \begin{bmatrix} -->
<!-- \beta_0 \\ -->
<!-- \beta_1 \\ -->
<!-- \beta_2 \\ -->
<!-- \beta_3 \\ -->
<!-- \end{bmatrix} -->
<!-- =  -->
<!-- \begin{bmatrix} -->
<!-- 0 \\ -->
<!-- 3 \\ -->
<!-- \end{bmatrix} -->
<!-- $$ -->
<!-- `clm` returns the F-statistic and p value associated with such test. It also returns the estimated $\sigma^2$ and $\boldsymbol{\beta}$ under $H_0$, i.e. the equality constrained model.  -->

``` r
library(ymisc)
df <- df <- read.table("http://www.stat.ucla.edu/~nchristo/statistics_c173_c273/jura.txt", header=TRUE)
df <- df[, c(-1, -2, -3, -4)]
C <- matrix(
  c(0, 1, 0, 1,
    0, 0, 1, 0),
  nrow = 2, byrow = TRUE)
d <- c(0, 3)

clm_res <- clm(Pb ~ Cd + Co + Cr, data = df, coef_mat = C, d = d)

# F statistic and p-value of 
clm_res$F_stat
#> [1] 13.47309
clm_res$p_value
#> [1] 2.291637e-06

# estimate of beta under H_0
clm_res$coefficients
#>                   [,1]
#> (Intercept) 16.2167926
#> Cd          -0.2993491
#> Co           3.0000000
#> Cr           0.2993491
```

In cases of testing significance of individual parameters, t test can be
used by setting `t_test = TRUE`. Suppose we want to obtain the t
statistic for
![\\beta\_1](https://ibm.codecogs.com/png.latex?%5Cbeta_1 "\beta_1")

``` r
C <- matrix(c(0, 1, 0, 0), nrow = 1)
d <- 0
clm_t <- clm(Pb ~ Cd + Co + Cr, data = df, coef_mat = C, d = d, t_test = TRUE)

clm_t$t_stat
#> [1] 1.842206
clm_t$p_value
#> [1] 0.06627892
```

We can verify that the t statistic is the square root of the F
statistic, and the p-value is the same.

``` r
clm_f <- clm(Pb ~ Cd + Co + Cr, data = df, coef_mat = C, d = d)
sqrt(clm_f$F_stat) # same as t statistic
#> [1] 1.842206
clm_f$p_value
#> [1] 0.06627892
```

An alternative is using `anova` for nested models, which yields the same
result

``` r
anova(lm(Pb ~  Co + Cr, data = df),
      lm(Pb ~ Cd + Co + Cr, data = df))
#> Analysis of Variance Table
#> 
#> Model 1: Pb ~ Co + Cr
#> Model 2: Pb ~ Cd + Co + Cr
#>   Res.Df    RSS Df Sum of Sq      F  Pr(>F)  
#> 1    356 365976                              
#> 2    355 362510  1    3465.5 3.3937 0.06628 .
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

## Write a data frame groupwise

There are times when we may wish to write different groups of a data
frame to separate files. I used to turn to `puurrr::group_walk` for
this, but it is not that easy to control names of such files.
`group_write` is a wrapper of`group_walk` and utilizes grouping
functions from dplyr to automate this task as well as providing
informative files names.

Suppose we would like to divide passengers in the Titanic according to
their age and gender, this would result in 4 groups

``` r
path <- tempdir()
titanic <- as.data.frame(Titanic)
titanic <- titanic[rep(1:nrow(titanic), titanic$Freq), -5]
dplyr::count(titanic, Sex, Age)
#>      Sex   Age    n
#> 1   Male Child   64
#> 2   Male Adult 1667
#> 3 Female Child   45
#> 4 Female Adult  425
```

Now use `group_write` to output this 4 groups into different csv files:

``` r
group_write(titanic, Sex, Age, dir = path)
list.files(path, "\\.csv$")
#> [1] "titanic-Female-Adult.csv" "titanic-Female-Child.csv"
#> [3] "titanic-Male-Adult.csv"   "titanic-Male-Child.csv"
```

## Set multiple file encodings at once

`set_file_enc` uses `iconv` to convert files between encodings. The
input can either be a directory or a single file. It works well with
import functions from the readr package.

## A light ggplot2 theme

I plan to include more custom ggplot2 themes in this package. Currently
there is only one light theme, `theme_clean()`

``` r
library(ggplot2)
mtcars %>%
  ggplot(aes(wt, mpg, fill = factor(am))) + 
  geom_point() + 
  geom_smooth() + 
  theme_clean()
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" style="display: block; margin: auto;" />

# Convert scripts into markdown code blocks

intended to use with chunk option `results='asis'`

``` r
# convert multiple scripts
code_blocks(c(dir1, dir2, dir3))
# convert single script
code_block(file)
```
