#' Scaffold directories
#'
#' @param dir directory to copy, relative to to inst/
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
#' \dontrun{
#' scaffold_widget("~/mywidget")
#' }
scaffold <- function(dir,
                     path,
                     rstudio = rstudioapi::isAvailable(),
                     open = rlang::is_interactive(),
                     is_package = FALSE) {
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
    cli::cli_progress_step("Creating project directory")

    if (is_package) {
        usethis::create_package(path)
    } else {
        usethis::create_project(
            path = path,
            open = FALSE,
        )
    }

    usethis::local_project(path, force = TRUE)

    cli::cli_progress_step("Copying files")
    from <- file_sys(dir)
    # Copy over whole directory
    fs::dir_copy(path = from, new_path = path, overwrite = TRUE)

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
            pattern = "example",
            replace = proj_name
        )

        replace_name(
            file = copied_file,
            pattern = "example",
            replace = proj_name
        )
    }

    cli::cli_progress_step("Creating project directory")
    clean_files(path)

    if (open) {
        if (usethis::proj_activate(usethis::proj_get())) {
            # working pathectory/active project already set; clear the scheduled
            # restoration of the original project
            withr::deferred_clear()
        }
    }

    cli::cli_progress_done("Done")
    invisible(usethis::proj_get())
}

#' Scaffold a widget package
#'
#' Similar to `packer::scaffold_widget()` but replace javascript with typescript, yarn with pnpm and webpack with esbuild
#' @export
#' @rdname scaffold
scaffold_widget <- function(...) {
    scaffold(dir = "pkg-templates/ts-widget", ...)
}


scaffold_quarto_book <- function(...) {
    scaffold(dir = "quarto-templates/book", ...)
}

scaffold_bookdown_book <- function(...) {
    scaffold(dir = "bookdown-templates/bs4", ...)
}
