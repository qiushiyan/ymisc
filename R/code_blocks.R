#' Convert scripts into R Markdown code blocks
#'
#' @description
#' intended to be used with chunk option results='asis'
#' @param dirs directories containing scripts
#' @param exclude files or directories to exclude
#' @param print_tree whether file structure should be printed
#' @return file contents
#' @export
#'
#' @examples
#' # convert multiple scripts inside directories
#' \dontrun{code_blocks(c(dir1, dir2, ...))}
#' # convert single script
#' \dontrun{code_block(file)}
code_blocks <- function(dirs, exclude = NULL, print_tree = TRUE) {
  # print file structure for directories
  for (dir in dirs) {
    if (!(dir %in% exclude)) {
      is_dir <- !utils::file_test("-f", dir)
      if (print_tree && is_dir) {
       fs::dir_tree(dir)
      }
    }
  }

  # print file contents
  out <- ""
  for (dir in dirs) {
    is_dir <- !utils::file_test("-f", dir)
    if (is_dir) {
      files <- fs::dir_ls(dir)
      for (file in files) {
        if (!(file %in% exclude)) {
          if (!utils::file_test("-f", file)) {
            out <- paste0(out, code_blocks(file, print_tree = FALSE), "\n")
          } else {
            out <- paste0(out, code_block(file), "\n")
          }
        }
      }
    } else {
      out <- paste0(out, code_block(file = dir), "\n")
    }
  }
  structure(out, class = "script")
}

#' @export
#' @rdname code_blocks
#' @usage NULL
code_block <- function(file) {
  ext <- tools::file_ext(file)
  type <- switch(ext,
         "r" = list(language = ".r", comment = "#"),
         "R" = list(language = ".r", comment = "#"),
         "Rmd" = list(language = ".rmarkdown", comment = "#"),
         "py" = list(language = ".python", comment = "#"),
         "js" = list(language = ".javascript", comment = "//"),
         "ts" = list(language = ".javascript", comment = "//"),
         "jsx" = list(language = ".javascriptreact", comment = "//"),
         "tsx" = list(language = ".javascriptreact", comment = "//"),
         list(language = "", comment = "#")
  )
  contents <- readLines(file)

  out <- ""
  out <- paste0(out, glue::glue("```{<type$language>}", .open = "<", .close = ">"), "\n")
  out <- paste0(out, glue::glue("{type$comment} {file}"), "\n")
  for (line in contents) {
    out <- paste0(out, line, "\n")
  }
  out <- paste0(out, "```\n")
  structure(out, class = "script")
}
