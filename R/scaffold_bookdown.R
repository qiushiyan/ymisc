#' Scaffold bookdown project with bs4 theme
#'
#' @description
#' `scaffold_bookdown()` generates a `bs4_book` format bookdown project.
#'  Need to run `renv::init()` in the new project to use the action.
#' @param path project path
#' @param rstudio if rstudio is available
#' @param open if rstudio is open
#' @param gh_action whether to use a github action to deploy the book
#'
#'
#' @import cli
#' @import fs
#' @return the new project path
#' @export
#'
#' @examples
#' \dontrun{scaffold_bookdown("~/mypkg")}
scaffold_bookdown <- function(path,
                         rstudio = rstudioapi::isAvailable(),
                         open = rlang::is_interactive(),
                         gh_action = TRUE) {

  path <- suppressWarnings(normalizePath(path, mustWork = FALSE))
  proj_name <- path_file(path)

  if (fs::dir_exists(path)) {
    delete_dir <- usethis::ui_yeah("path already exists, overwrite it?", yes = "yes", no = "no")
    if (delete_dir) {
      unlink(path, recursive = TRUE)
    } else {
      return(NULL)
    }
  }
  cat_rule("Creating project ...")
  usethis::create_project(
    path = path,
    open = FALSE,
  )
  cat_green_tick("Created project directory")

  usethis::local_project(path, force = TRUE)

  cat_rule("Copying package skeleton")
  from <- file_sys("bookdown-templates/bs4")
  # Copy over whole directory
  dir_copy(path = from, new_path = path, overwrite = TRUE)

  # replace with book name
  copied_files <- list.files(
    path = from,
    full.names = FALSE,
    all.files = TRUE,
    recursive = TRUE
  )


  for (f in copied_files) {
    copied_file <- file.path(path, f)
    replace_word(
      file = copied_file,
      pattern = "bookexample",
      replace = proj_name
    )
  }


  if (!gh_action) {
    unlink(paste0(path, ".github"), recursive = TRUE)
  }

  cat_green_tick("Copied book skeleton")

  clean_files(path)

  if (open) {
    if (usethis::proj_activate(usethis::proj_get())) {
      # working path/active project already set; clear the scheduled
      # restoration of the original project
      withr::deferred_clear()
    }
  }

  invisible(usethis::proj_get())
}


