#' Generate project structures
#'
#' @description
#' `use_bookdown()` generates a `bs4_book` format bookdown project. `use_bookdown_action` creates a github action for deploying bookdown projects.
#'  Need to run `renv::init()` in the new project to use the action.
#' @param proj_name project name
#' @param dir parent directory of the project
#' @param rstudio if rstudio is available
#' @param open if rstudio is open
#' @param gh_action whether to use a github action to deploy the book
#'
#'
#' @return the new project path
#' @export
#'
#' @examples
#' \dontrun{use_bookdown("my-awesome-book", "~/documents")}
#' \dontrun{use_bookdown_action(".")}
use_bookdown <- function(proj_name,
                        dir = ".",
                        rstudio = rstudioapi::isAvailable(),
                        open = rlang::is_interactive(),
                        gh_action = TRUE) {
  path <- fs::path_join(c(fs::path_abs(dir), proj_name))
  if (fs::dir_exists(path)) {
    delete_dir <- usethis::ui_yeah("Directory already exists, delete it?", yes = "yes", no = "no")
    if (delete_dir) {
      unlink("d:/test-bookdown", recursive = TRUE)
    } else {
      return(NULL)
    }
  }
  create_directory(path)
  usethis::local_project(path, force = TRUE)

  # file creation
  usethis::use_directory("images")
  usethis::use_directory(".github/workflows")
  file.create("style.css")
  file.create("_bookdown.yml")
  file.create("_output.yml")
  file.create("_common.R")
  file.create("index.Rmd")
  file.create(".gitignore")

  # file contents
  css <- list(path = "./style.css",
              contents = "p.caption {\n  color: #777;\n  margin-top: 10px;\n}\np code {\n  white-space: inherit;\n}\npre {\n  word-break: normal;\n  word-wrap: normal;\n}\npre code {\n  white-space: inherit;\n}\n\nli.book-part {\n  color:#4d8d8b;\n}")
  bookdown <- list(path = "./_bookdown.yml",
                   contents =  glue::glue("book_filename: \"{proj_name}\"\nnew_session: yes\ndelete_merged_file: true\n\n\nbefore_chapter_script: \"_common.R\"\n\nrmd_files: [\n  \"index.Rmd\", \n]"))
  output <- list(path = "./_output.yml",
                 contents = paste0(
                     "bookdown::bs4_book:\n  theme:\n    primary: \"#4D6F8D\"\n  repo: https://github.com/qiushiyan/",
                     proj_name,
                     "\n  css: style.css"))
  common <- list(path = "./_common.R",
                 contents = "set.seed(1112)\noptions(digits = 3)\n\nknitr::opts_chunk$set(\n  comment = \"\",\n  collapse = FALSE,\n  fig.width = 8,\n  fig.asp = 0.618,  # 1 / phi\n  fig.align = \"center\",\n  message = FALSE,\n  warning = FALSE\n)")
  index <- list(path = "./index.Rmd",
                contents = glue::glue("---\ntitle: \"<proj_name>\"\nauthor: \"Qiushi\"\ndate: \"`r Sys.Date()`\"\nsite: bookdown::bookdown_site\n---\n\n```{r, include = FALSE}\nlibrary(bslib)\nlibrary(downlit)\nlibrary(xml2)\n```\n\n# Preface",
                                      .open = "<", .close = ">"))
  gitignore <- list(path = fs::path_join(c(path, ".gitignore")),
                    contents = ".Rproj.user\n*.md\n*.rds\n*.html\nrenv/*\n!renv/activate.R\n_book")

  xfun::write_utf8(css$contents, css$path)
  xfun::write_utf8(bookdown$contents, bookdown$path)
  xfun::write_utf8(output$contents, output$path)
  xfun::write_utf8(common$contents, common$path)
  xfun::write_utf8(index$contents, index$path)

  if (rstudio) {
    usethis::use_rstudio()
  } else {
    usethis::ui_done("Writing a sentinel file {usethis::ui_path('.here')}")
    usethis::ui_todo("Build robust paths within your project via {ui_code('here::here()')}")
    usethis::ui_todo("Learn more at <https://here.r-lib.org>")
    fs::file_create(proj_path(".here"))
  }

  xfun::write_utf8(gitignore$contents, gitignore$path)

  if (gh_action) {
    use_bookdown_action(path)
  } else {
    use_gh_action <- ui_yeah("Use github action to deploy the book?", yes = "yes", no = "no")
    if (use_gh_action) {
      use_bookdown_action(path)
    }
  }

  if (open) {
    if (usethis::proj_activate(usethis::proj_get())) {
      # working directory/active project already set; clear the scheduled
      # restoration of the original project
      withr::deferred_clear()
    }
  }

  invisible(usethis::proj_get())
}

#' @rdname use_bookdown
#' @export
#' @param path project path
#' @param action action name to be added in
use_bookdown_action <- function(path, action = "deploy") {
  gh_path <- fs::path_join(c(fs::path_abs(path), ".github", "workflows"))
  if (!fs::dir_exists(gh_path)) {
    usethis::ui_done(("Creating {usethis::ui_path(gh_path)}"))
    fs::dir_create(gh_path)
  }

  if (!(fs::path_ext(action) %in% c("yml", "yaml"))) {
    fs::path_ext(action) = "yml"
  }

  action_path <- fs::path_join(c(gh_path, action))
  file.create(action_path)
  xfun::write_utf8(bookdown_deploy, action_path)
  usethis::ui_done(("writing {usethis::ui_path(action_path)}"))
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
