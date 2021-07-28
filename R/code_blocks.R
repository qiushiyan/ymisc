#' Convert scripts into R Markdown code blocks
#'
#' intended to use with chunk option results='asis'
#' @param dirs the directory containing scripts
#'
#' @return
#' @export
#'
#' @examples
#' # convert multiple scripts inside directories
#' # code_blocks(c(dir1, dir2, ...))
#' # convert single script
#' # code_block(file)
code_blocks <- function(dirs, exclude = NULL) {
  for (dir in dirs) {
    files <- fs::dir_ls(dir)
    for (file in files) {
      if (file %in% exclude) {
        next
      }
      code_block(file)
    }
    cat("\n")
  }
}

#' @export
#' @rdname code_blacks
#' @usage NULL
code_block <- function(file) {
  block_type <- function(file) {
    ext = tools::file_ext(file)
    switch(ext,
           "r" =".r",
           "R" = ".r",
           "py" = ".python",
           "js" = ".javascript",
           "ts" = ".javascript",
           "jsx" = ".javascriptreact",
           "tsx" = "javascriptreact",
           ""
    )
  }

  type = block_type(file)
  contents = readLines(file)
  cat(glue("```{<type>}", .open = "<", .close = ">"), sep = "\n")
  cat(glue("# {file}"), sep = "\n")
  for (line in contents) {
    cat(line, sep = "\n")
  }
  cat("\n```")
}

