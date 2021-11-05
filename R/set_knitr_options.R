#' set common knitr options
#'
#' @param ...
#'
#' @return
#' @export
set_knitr_optons <- function(...) {
  knitr::opts_chunk$set(
    message = FALSE,
    warning = FALSE,
    fig.align = "center",
    comment = "#>",
    collapse = TRUE,
    ...
  )
}
