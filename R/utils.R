
is_subset <- function(x, y) {
  all(x %in% y)
}

knit_print.script <- function(output, ...) {
  knitr::asis_output(output, ...)
}

file_sys <- function(...) {
  system.file(..., package = "ymisc")
}

replace_word <- function(file,pattern, replace){
  suppressWarnings( tx  <- readLines(file) )
  tx2  <- gsub(pattern = pattern, replacement = replace, x = tx)
  writeLines(tx2, con=file)
}

# from usethis:::create_directory
create_directory <- function (path)
{
  if (fs::dir_exists(path)) {
    return(invisible(FALSE))
  }
  else if (fs::file_exists(path)) {
    usethis::ui_stop("{usethis::ui_path(path)} exists but is not a directory.")
  }
  fs::dir_create(path, recurse = TRUE)
  usethis::ui_done("Creating {usethis::ui_path(path)}")
  invisible(TRUE)
}

# from golem
cat_green_tick <- function(...){
  cat_bullet(
    ...,
    bullet = "tick",
    bullet_col = "green"
  )
}
