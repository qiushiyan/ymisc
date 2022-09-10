#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
example <- function(message, width = NULL, height = NULL, elementId = NULL) {
    # forward options using x
    payload <- list()

    # create widget
    htmlwidgets::createWidget(
        name = "example",
        payload,
        width = width,
        height = height,
        package = "example",
        elementId = elementId
    )
}

#' Shiny bindings for example
#'
#' Output and render functions for using example within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a example
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name example-shiny
#'
#' @export
exampleOutput <- function(outputId, width = "100%", height = "400px") {
    htmlwidgets::shinyWidgetOutput(outputId, "example", width, height, package = "example")
}

#' @rdname example-shiny
#' @export
renderexample <- function(expr, env = parent.frame(), quoted = FALSE) {
    if (!quoted) {
        expr <- substitute(expr)
    } # force quoted
    htmlwidgets::shinyRenderWidget(expr, exampleOutput, env, quoted = TRUE)
}
