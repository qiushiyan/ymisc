#' Divide a data frame into groups and write multiple csv files
#'
#' `group_write` splits a data frame according to (multiple) grouping variables, write out each
#' part with file name indicating specific groups.
#'
#' @param df a data frame
#' @param ... grouping variables
#' @param dir output directory. By default, the output files are stored under the current working directory
#'
#' @return `group_write` returns the input data frame invisibly.
#' @export
#' @examples
#' library(ymisc)
#' group_write(iris, Species)
#' list.files(pattern = "\\.csv$")
#'
#' # Currently, you need to convert `df` into a data frame outside this function
#' # before passing the argument.
#' # For example, `group_write(as.data.frame(Titanic), Sex, Age)` does not work
group_write <- function(df, ..., dir = "") {
  df_name <- as.character(substitute(df))
  gf <- dplyr::group_by(df, ...)
  if (!dplyr::is.grouped_df(gf)) {
    stop("You need to specify at least one grouping variable to split the data frame with.")
  }

  else {
    keys <- dplyr::group_keys(gf)
    names <- vector("list", 0)
    for (i in 1:nrow(keys)) {
      name <- paste(unlist(keys[i, ], use.names = FALSE), collapse = "-")
      names[[i]] <- paste(df_name, name, sep = "-")
    }
    out <- dplyr::group_split(gf)
    names(out) <- names
    if (dir == "") {
      purrr::iwalk(out, ~ readr::write_csv(.x, paste0(.y, ".csv")))
    }
    else {
      if (dir.exists(dir)) {
        purrr::iwalk(out, ~ readr::write_csv(.x, paste0(dir, "/", .y, ".csv")))
      }
      else {
        dir.create(dir)
        purrr::iwalk(out, ~ readr::write_csv(.x, paste0(dir, "/", .y, ".csv")))
      }
    }
  }
  invisible(df)
}
