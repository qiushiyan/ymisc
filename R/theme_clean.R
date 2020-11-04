#' Custom ggplot2 theme
#'
#' @param base_size base font size
#' @param strip_text_size font size for strip text (facet text)
#' @param strip_text_margin strip text margin
#' @param subtitle_size font size for subtitle
#' @param subtitle_margin subtitle margin
#' @param plot_title_size font size for title
#' @param plot_title_margin title margin
#' @param ... additional arguments passed to theme()
#'
#' @description
#' A ggplot2 theme with opinionated defaults. Light background, no grid lines, legend at
#' the bottom, etc.
#' @export
#' @examples
#' library(ymisc)
#' library(ggplot2)
#' diamonds %>%
#'   ggplot() +
#'   geom_hex(aes(carat, price, fill = cut)) +
#'   theme_clean()
theme_clean <- function(base_size = 11,
                        strip_text_size = 12,
                        strip_text_margin = 5,
                        subtitle_size = 13,
                        subtitle_margin = 10,
                        plot_title_size = 16,
                        plot_title_margin = 10,
                        ...) {
  ret <- ggplot2::theme_minimal(base_size = base_size, ...)
  ret$strip.text <- ggplot2::element_text(
    hjust = 0, size = strip_text_size,
    margin = ggplot2::margin(b = strip_text_margin)
  )
  ret$plot.subtitle <- ggplot2::element_text(
    hjust = 0, size = subtitle_size,
    margin = ggplot2::margin(b = subtitle_margin)
  )
  ret$plot.title <- ggplot2::element_text(
    hjust = 0, size = plot_title_size,
    margin = ggplot2::margin(b = plot_title_margin)
  )
  ret$plot.title.position <- "plot"
  ret$legend.position <- "bottom "
  ret$panel.grid <- ggplot2::element_blank()
  ret
}
