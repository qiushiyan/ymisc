% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clm.R
\name{clm}
\alias{clm}
\title{Fitting linear model with equality constraints}
\usage{
clm(formula, coef_mat, d, data = NULL, t_test = FALSE, ...)
}
\arguments{
\item{formula}{formula passed to \code{lm}}

\item{coef_mat}{the coefficient matrix C as in C * beta = d}

\item{d}{the constant vector on the right hand side}

\item{data}{data frame containing variables in the model}

\item{t_test}{whether use the t test for hypothesis testing, only applicable when the coefficient matrix only has one row}

\item{...}{additional arguments passed to \code{lm}}
}
\value{
\code{clm} returns a list containing the following components
\itemize{
\item \code{coefficients}: estimate of beta under constraints
\item \code{residuals}: the residuals
\item \code{fitted_values}: the fitted values
\item \code{df_residual}: the residual degree of freedom
\item \code{sigma2}: estimate of sigma^2, i.e. the variance of residuals
\item \code{F_stat} when \code{t_test = FALSE}, F-statistic testing H0: C * beta = d
\item \code{t_stat}: when \code{t_test = TRUE}, t-statistic testing: C * beta = d
\item \code{p_value}: p value of the test
\item \code{y}: the response
\item \code{x}: the model matrix
\item \code{model}: the model frame
}
}
\description{
\code{clm} can either be used for estimating the linear model with equality constraints C * beta = d, or for
general hypothesis testing in multiple linear regression, where H0: C * beta = d and H1: otherwise
}
\examples{
df <- read.table("http://www.stat.ucla.edu/~nchristo/statistics_c173_c273/jura.txt", header = TRUE)
df <- df[, c(-1, -2, -3, -4)]
C <- matrix(
  c(
    0, 1, 1, 0, 0, -3, 0,
    0, 0, 0, 1, 0, 1, 1
  ),
  nrow = 2, byrow = TRUE
)
d <- c(2, 3)
clm(Pb ~ ., data = df, coef_mat = C, d = d)
}
