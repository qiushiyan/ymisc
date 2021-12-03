#' Generate project structures
#'
#' @description
#' `use_bookdown()` generates a `bs4_book` format bookdown project.
#'  Need to run `renv::init()` in the new project to use the action. `create_bookdown` is an alias.
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
#' \dontrun{create_bookdown("my-awesome-book", "~/documents")}
use_bookdown <- function(path,
                         rstudio = rstudioapi::isAvailable(),
                         open = rlang::is_interactive(),
                         gh_action = TRUE) {
  proj_name <- path_file(path)

  if (fs::dir_exists(path)) {
    delete_dir <- usethis::ui_yeah("pathectory already exists, overwrite it?", yes = "yes", no = "no")
    if (delete_dir) {
      unlink(path, recursive = TRUE)
    } else {
      return(NULL)
    }
  }
  cat_rule("Creating pathectory ...")
  usethis::create_project(
    path = path,
    open = FALSE,
  )
  cat_green_tick("Created project pathectory")

  usethis::local_project(path, force = TRUE)

  cat_rule("Copying package skeleton")
  from <- file_sys("bookdown-templates/bs4")
  # Copy over whole pathectory
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

  if (open) {
    if (usethis::proj_activate(usethis::proj_get())) {
      # working pathectory/active project already set; clear the scheduled
      # restoration of the original project
      withr::deferred_clear()
    }
  }

  invisible(usethis::proj_get())
}



#' @rdname use_bookdown
#' @export
create_bookdown <- use_bookdown
