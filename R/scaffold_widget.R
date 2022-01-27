#' Scaffold htmlwidgets package with typescript, esbuild and pnpm
#'
#' @description
#' similar to `packer::scaffold_widget()` but replace javascript with typescript, yarn with pnpm and webpack with esbuild
#' @param path project path
#' @param rstudio if rstudio is available
#' @param open if rstudio is open
#'
#'
#' @import cli
#' @import fs
#' @return the new project path
#' @export
#'
#' @examples
#' \dontrun{scaffold_widget("~/mywidget")}
scaffold_widget <- function(path,
                            rstudio = rstudioapi::isAvailable(),
                            open = rlang::is_interactive()) {

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
  cat_rule("Creating package ...")

  usethis::create_package(path)
  cat_green_tick("Created package directory")

  usethis::local_project(path, force = TRUE)

  cat_rule("Copying package skeleton")
  from <- file_sys("pkg-templates/ts-widget")
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
      pattern = "widgetexample",
      replace = proj_name
    )

    replace_name(
      file = copied_file,
      pattern = "widgetexample",
      replace = proj_name
    )
  }


  cat_green_tick("Copied package skeleton")

  clean_files(path)
#
  if (open) {
    if (usethis::proj_activate(usethis::proj_get())) {
      # working pathectory/active project already set; clear the scheduled
      # restoration of the original project
      withr::deferred_clear()
    }
  }

  invisible(usethis::proj_get())
}


