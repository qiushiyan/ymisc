#' Utilities functions for working with github
#' @description
#'
#' @param repo user/repo
#' @param file file
#' @param branch branch
#' @param lfs if uses lfs storage
#'
#' @return raw file url for downloading
#' @export
#' @examples
#' url <- gh_raw_url("qiushiyan/blog-data", "codes.csv", lfs = TRUE)
#' @rdname gh_utils
gh_raw_url <- function(repo, file, branch = "main", lfs = FALSE) {
  if (!lfs) {
    glue::glue("https://raw.githubusercontent.com/{repo}/{branch}/{file}")
  } else {
    if (branch == "main") branch = "master"
    glue::glue("https://media.githubusercontent.com/media/{repo}/{branch}/{file}")
  }
}
