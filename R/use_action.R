#' setup yaml file for github action
#'
#' @export
#' @param name action name
use_gh_action <- function(name) {
  gh_path <- path_join(c(path_abs("."), ".github", "workflows"))
  if (!dir_exists(gh_path)) {
    usethis::ui_done(("Creating {usethis::ui_path(gh_path)}"))
    dir_create(gh_path)
  }

  if (!(path_ext(name) %in% c("yml", "yaml"))) {
    path_ext(name) = "yml"
  }

  action_path <- path_join(c(gh_path, name))
  targets <- list.files(file_sys("actions"), full.names = TRUE)

  for (f in targets) {
    if (grepl(name, path_file(f))) {
       file_copy(f, new_path = action_path)
    }
    break
  }

  cat_green_tick(sprintf("Created github action %s", action_path))
}
