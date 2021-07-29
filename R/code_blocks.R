#' Convert scripts into R Markdown code blocks
#'
#' intended to use with chunk option results='asis'
#' @param dirs directories containing scripts
#' @param exclude files or directories to exclude
#' @param print_tree whether file structure should be printed
#' @return
#' @export
#'
#' @examples
#' # convert multiple scripts inside directories
#' # code_blocks(c(dir1, dir2, ...))
#' # convert single script
#' # code_block(file)
code_blocks <- function(dirs, exclude = NULL, print_tree = TRUE) {
  # print file structure
  cat("```\n")
  for (dir in dirs) {
    if (dir %in% exclude) {
      next
    }
    is_dir <- !utils::file_test("-f", dir)
    if (print_tree && is_dir) {
      cat(fs::dir_tree(dir), sep = "\n")
    } else {
      cat(dir, sep = "\n")
    }

  }
  cat("```\n")

  # print file contents
  for (dir in dirs) {
    is_dir <- !utils::file_test("-f", dir)
    if (is_dir) {
      files <- fs::dir_ls(dir)
      for (file in files) {
        if (file %in% exclude) {
          next
        }
        if (!utils::file_test("-f", file)) {
          code_blocks(file, print_tree = FALSE)
        } else {
          code_block(file)
        }
      }
    } else {
      code_block(file = dir)
    }
    cat("\n")
  }
}

#' @export
#' @rdname code_blacks
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
  cat(glue::glue("```{<type$language>}", .open = "<", .close = ">"), sep = "\n")
  cat(glue::glue("{type$comment} {file}"), sep = "\n")
  for (line in contents) {
    cat(line, sep = "\n")
  }
  cat("```\n")
}

