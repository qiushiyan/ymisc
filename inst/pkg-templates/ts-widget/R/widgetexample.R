#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
widgetexample <- function(message, width = NULL, height = NULL, elementId = NULL) {

    # forward options using x
    payload <- list()

    # create widget
    htmlwidgets::createWidget(
        name = "widgetexample",
        payload,
        width = width,
        height = height,
        package = "widgetexample",
        elementId = elementId
    )
}

#' Shiny bindings for widgetexample
#'
#' Output and render functions for using widgetexample within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a widgetexample
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name widgetexample-shiny
#'
#' @export
widgetexampleOutput <- function(outputId, width = "100%", height = "400px") {
    htmlwidgets::shinyWidgetOutput(outputId, "widgetexample", width, height, package = "widgetexample")
}

#' @rdname widgetexample-shiny
#' @export
renderwidgetexample <- function(expr, env = parent.frame(), quoted = FALSE) {
    if (!quoted) {
        expr <- substitute(expr)
    } # force quoted
    htmlwidgets::shinyRenderWidget(expr, widgetexampleOutput, env, quoted = TRUE)
}