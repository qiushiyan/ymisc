
# ymisc

This package contains miscellaneous functions I collected to make simple
yet common tasks easier.

You can install the package from Github via

``` r
remotes::install_github("enixam/ymisc")
```

## General hypothesis testing in multiple linear regression

A general hypothesis in multiple linear regression can be expressed in
the following matrix form

  
![&#10;C\\boldsymbol{\\beta} =
\\boldsymbol{d}&#10;](https://ibm.codecogs.com/png.latex?%0AC%5Cboldsymbol%7B%5Cbeta%7D%20%3D%20%5Cboldsymbol%7Bd%7D%0A
"
C\\boldsymbol{\\beta} = \\boldsymbol{d}
")  

where ![C](https://ibm.codecogs.com/png.latex?C "C") is an ![m \\times
n](https://ibm.codecogs.com/png.latex?m%20%5Ctimes%20n "m \\times n")
matrix,
![\\boldsymbol{\\beta}](https://ibm.codecogs.com/png.latex?%5Cboldsymbol%7B%5Cbeta%7D
"\\boldsymbol{\\beta}") is an ![p](https://ibm.codecogs.com/png.latex?p
"p")-dimensional (including the intercept) parameter to estimate, and
![\\boldsymbol{d}](https://ibm.codecogs.com/png.latex?%5Cboldsymbol%7Bd%7D
"\\boldsymbol{d}") is an ![m](https://ibm.codecogs.com/png.latex?m
"m")-dimensional vector. ![C](https://ibm.codecogs.com/png.latex?C "C")
and
![\\boldsymbol{d}](https://ibm.codecogs.com/png.latex?%5Cboldsymbol%7Bd%7D
"\\boldsymbol{d}") are specified by the hypothesis to be tested. For
example, if we want to test the following hypothesis with two
constraints for a linear model with 3 predictors

  
![&#10;\\begin{aligned}&#10;H\_0&: \\beta\_1 + \\beta\_3 = 0 \\quad
\\text{and} \\quad \\beta\_2 = 3 \\\\&#10;H\_1&: \\text{otherwise}
&#10;\\end{aligned}&#10;](https://ibm.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0AH_0%26%3A%20%5Cbeta_1%20%2B%20%5Cbeta_3%20%3D%200%20%5Cquad%20%5Ctext%7Band%7D%20%5Cquad%20%5Cbeta_2%20%3D%203%20%20%20%5C%5C%0AH_1%26%3A%20%5Ctext%7Botherwise%7D%20%0A%5Cend%7Baligned%7D%0A
"
\\begin{aligned}
H_0&: \\beta_1 + \\beta_3 = 0 \\quad \\text{and} \\quad \\beta_2 = 3   \\\\
H_1&: \\text{otherwise} 
\\end{aligned}
")  
Then this hypothesis can be expressed as

  
![&#10;\\begin{bmatrix}&#10;0 & 1 & 0 & 1 \\\\&#10;0 & 0 & 1 & 0
\\\\&#10;\\end{bmatrix}&#10;\\begin{bmatrix}&#10;\\beta\_0
\\\\&#10;\\beta\_1 \\\\&#10;\\beta\_2 \\\\&#10;\\beta\_3
\\\\&#10;\\end{bmatrix}&#10;= &#10;\\begin{bmatrix}&#10;0 \\\\&#10;3
\\\\&#10;\\end{bmatrix}&#10;](https://ibm.codecogs.com/png.latex?%0A%5Cbegin%7Bbmatrix%7D%0A0%20%26%201%20%26%200%20%26%201%20%5C%5C%0A0%20%26%200%20%26%201%20%26%200%20%5C%5C%0A%5Cend%7Bbmatrix%7D%0A%5Cbegin%7Bbmatrix%7D%0A%5Cbeta_0%20%5C%5C%0A%5Cbeta_1%20%5C%5C%0A%5Cbeta_2%20%5C%5C%0A%5Cbeta_3%20%5C%5C%0A%5Cend%7Bbmatrix%7D%0A%3D%20%0A%5Cbegin%7Bbmatrix%7D%0A0%20%5C%5C%0A3%20%5C%5C%0A%5Cend%7Bbmatrix%7D%0A
"
\\begin{bmatrix}
0 & 1 & 0 & 1 \\\\
0 & 0 & 1 & 0 \\\\
\\end{bmatrix}
\\begin{bmatrix}
\\beta_0 \\\\
\\beta_1 \\\\
\\beta_2 \\\\
\\beta_3 \\\\
\\end{bmatrix}
= 
\\begin{bmatrix}
0 \\\\
3 \\\\
\\end{bmatrix}
")  
`clm` returns the F-statistic and p value associated with such test. It
also returns the estimated
![\\sigma^2](https://ibm.codecogs.com/png.latex?%5Csigma%5E2
"\\sigma^2") and
![\\boldsymbol{\\beta}](https://ibm.codecogs.com/png.latex?%5Cboldsymbol%7B%5Cbeta%7D
"\\boldsymbol{\\beta}") under
![H\_0](https://ibm.codecogs.com/png.latex?H_0 "H_0"), i.e. the equality
constrained model.

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
#> [1] 0.000002291637

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
statistic for ![\\beta\_1](https://ibm.codecogs.com/png.latex?%5Cbeta_1
"\\beta_1")

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
