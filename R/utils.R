
is_subset <- function(x, y) {
  all(x %in% y)
}

file_sys <- function(...) {
  system.file(..., package = "ymisc")
}

replace_word <- function(file, pattern, replace) {
  suppressWarnings(tx <- readLines(file))
  tx2 <- gsub(pattern = pattern, replacement = replace, x = tx)
  writeLines(tx2, con = file)
}

replace_name <- function(file, pattern, replace) {
  newfile <- gsub(pattern = pattern, replacement = replace, x = file)
  file.rename(file, newfile)
}


clean_files <- function(path, exclude_patterns = c(".DS_Store")) {
  files <- normalizePath(list.files(path, all.files = TRUE))
  p <- paste0(exclude_patterns, collapse = "|")
  files2 <- grep(p, files, ignore.case = TRUE, value = TRUE)
  fs::file_delete(files2)
}

# from usethis:::create_directory
create_directory <- function(path) {
  if (fs::dir_exists(path)) {
    return(invisible(FALSE))
  } else if (fs::file_exists(path)) {
    usethis::ui_stop("{usethis::ui_path(path)} exists but is not a directory.")
  }
  fs::dir_create(path, recurse = TRUE)
  usethis::ui_done("Creating {usethis::ui_path(path)}")
  invisible(TRUE)
}

# from golem
cat_green_tick <- function(...) {
  cat_bullet(
    ...,
    bullet = "tick",
    bullet_col = "green"
  )
}
