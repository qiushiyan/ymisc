#' Fitting linear model with equality constraints
#'
#' `clm` can either be used for estimating the linear model with equality constraints C * beta = d, or for
#' general hypothesis testing in multiple linear regression, where H0: C * beta = d and H1: otherwise
#' @param formula formula passed to `lm`
#' @param coef_mat the coefficient matrix C as in C * beta = d
#' @param d the constant vector on the right hand side
#' @param data data frame containing variables in the model
#' @param t_test whether use the t test for hypothesis testing, only applicable when the coefficient matrix only has one row
#' @param ... additional arguments passed to `lm`
#'
#' @return
#' `clm` returns a list containing the following components
#' - `coefficients`: estimate of beta under constraints
#' - `residuals`: the residuals
#' - `fitted_values`: the fitted values
#' - `df_residual`: the residual degree of freedom
#' - `sigma2`: estimate of sigma^2, i.e. the variance of residuals
#' - `F_stat` when `t_test = FALSE`, F-statistic testing H0: C * beta = d
#' - `t_stat`: when `t_test = TRUE`, t-statistic testing: C * beta = d
#' - `p_value`: p value of the test
#' - `y`: the response
#' - `x`: the model matrix
#' - `model`: the model frame
#' @export
#'
#' @examples
#' df <- read.table("http://www.stat.ucla.edu/~nchristo/statistics_c173_c273/jura.txt", header = TRUE)
#' df <- df[, c(-1, -2, -3, -4)]
#' C <- matrix(
#'   c(
#'     0, 1, 1, 0, 0, -3, 0,
#'     0, 0, 0, 1, 0, 1, 1
#'   ),
#'   nrow = 2, byrow = TRUE
#' )
#' d <- c(2, 3)
#' clm(Pb ~ ., data = df, coef_mat = C, d = d)
clm <- function(formula, coef_mat, d, data = NULL, t_test = FALSE, ...) {
  if (is.null(data)) {
    stop('Need argument "data" to fit the model.')
  } else {
    lm_obj <- lm(formula, data = data, ...)
  }
  X <- model.matrix(lm_obj)
  XT <- t(X)
  XTX <- t(X) %*% X
  XTX_inv <- solve(XTX)
  y <- lm_obj$model[, 1]
  e <- residuals(lm_obj)
  se2 <- sigma(lm_obj)^2
  beta_hat <- XTX_inv %*% XT %*% y
  C <- coef_mat

  n <- nrow(X)
  p <- ncol(X)
  m <- nrow(C)

  constraint <- C %*% beta_hat - d
  CT <- t(C)
  CXXC_inv <- solve(C %*% XTX_inv %*% CT)
  beta_hatc <- beta_hat - XTX_inv %*% CT %*% CXXC_inv %*% constraint
  fitted_values <- y - X %*% beta_hatc
  e_c <- e - X %*% XTX_inv %*% CT %*% CXXC_inv %*% constraint
  se2_c <- sum((e_c)^2) / (n - p + m)

  if (!t_test) {
    F_stat <- t(constraint) %*% CXXC_inv %*% constraint / (m * se2)
    p_value <- 1 - pf(as.numeric(F_stat), df1 = m, df2 = n - p)
    list(
      coefficients = beta_hatc, residuals = e_c, fitted_values = fitted_values,
      df_residual = n - p + m, sigma2 = se2_c,
      F_stat = as.numeric(F_stat), p_value = p_value,
      y = y, x = X, model = cbind(y, X)
    )
  } else {
    t_stat <- constraint %*% sqrt(CXXC_inv) / (sqrt(se2))
    p_value <- 2 * (1 - pt(as.numeric(t_stat), df = n - p))
    list(
      coefficients = beta_hatc, residuals = e_c, fitted_values = fitted_values,
      df_residual = n - p - 1, sigma2 = se2_c,
      t_stat = as.numeric(t_stat), p_value = p_value,
      y = y, x = X, model = cbind(y, X)
    )
  }
}