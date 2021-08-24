
is_subset <- function(x, y) {
  all(x %in% y)
}

knit_print.script <- function(output, ...) {
  knitr::asis_output(output, ...)
}
