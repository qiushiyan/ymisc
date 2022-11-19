#' Retrieve personal data Github-like calendar plots
#'
#' Gather data from github contributions, repositories, posts and combine them
#' into an interactive calendar plot.
#' @param from Character of start date
#' @param to Character of enddate
#' @param github_user Github user name
#' @param github_repos A character vector of Github respositories (projects)
#' @param post_path Character of local path to search for posts
#' @param data tibble to draw the calendar
#' @param font font name
#' @import ggplot2
#' @import ggiraph
#' @export
calendar_plot <- function(data = calendar_data(), font = "Atkinson Hyperlegible") {
  plot_data <- dplyr::mutate(data,
    x = lubridate::floor_date(date, "week"),
    y = forcats::fct_rev(lubridate::wday(date, label = TRUE)),
    type = factor(type, levels = c("github", "pkg", "project", "post")),
    on_click = stringr::str_glue('window.location.assign("{link}")'),
    data_id = ifelse(!is.na(type), as.character(seq_along(x)), NA_character_),
    tip = stringr::str_glue("{tip}<br/>on {date}")
  )

  # counts for every label
  counts <- plot_data |>
    dplyr::filter(!is.na(type)) |>
    dplyr::count(type) |>
    na.omit() |>
    dplyr::mutate(
      n = dplyr::case_when(
        type == "github" ~ dplyr::count(plot_data |> dplyr::filter(!is.na(type)), type, wt = as.integer(count)) %>% dplyr::pull(),
        TRUE ~ n
      ),
      emoji = c("💻", "📦", "💡", "📋"),
      nice = c("GitHub", "CRAN", "projects", "posts"),
      label = stringr::str_glue("{scales::comma_format(accuracy = 1)(n)} {emoji}\n{nice}")
    )

  my_pal <- ggthemes::solarized_pal("blue")(4)

  p <- ggplot() +
    geom_tile(aes(x, y, fill = type),
      data = dplyr::filter(plot_data, is.na(type)),
      width = 6, height = .8, key_glyph = draw_key_point
    ) +
    geom_tile_interactive(
      aes(x, y,
        fill = type, alpha = log(as.numeric(count)),
        tooltip = tip, onclick = on_click, data_id = data_id
      ),
      data = dplyr::filter(plot_data, !is.na(type)),
      width = 6, height = .8
    ) +
    scale_fill_manual(
      values = c("github" = my_pal[[1]], "pkg" = my_pal[[2]], "project" = my_pal[[3]], "post" = my_pal[[4]]),
      breaks = c("github", "pkg", "project", "post"),
      labels = counts$label,
      na.translate = TRUE, na.value = "#eee8d5"
    ) +
    scale_y_discrete(breaks = c("Mon", "Wed", "Fri")) +
    ggthemes::theme_economist() +
    theme(
      rect = element_blank(),
      line = element_blank(),
      plot.background = element_rect(fill = "#0f182b", color = NA),
      text = element_text(family = font),
      legend.position = "top",
      legend.key = element_blank(),
      axis.text = element_text(color = "white", size = 9),
      legend.text = element_text(color = "white", size = 8),
      aspect.ratio = .8 / 6
    ) +
    guides(
      alpha = "none",
      fill = guide_legend(nrow = 1, keywidth = 1.5, keyheight = 1.5)
    ) +
    labs(x = NULL, y = NULL)

  x <- girafe(code = print(p), width_svg = 6, height_svg = 2)

  tooltip_css <- "
    background: #002b36;
    opacity: 1;
    color: #839496;
    border-radius: 5px;
    padding: 5px;
    box-shadow: 3px 3px 5px 0px #888888;
    font-size: 16px;
    border-width 2px;
    border-color: #002b36;
  "

  girafe_options(x, opts_tooltip(css = tooltip_css))
}

#' @export
calendar_data <- function(from = NULL,
                          to = from + lubridate::years(1),
                          github_user = "qiushiyan",
                          github_repos = c(
                            "xkcd", "uuid", "potg", "qlang", "overwatcher",
                            "js-notebook", "nyclodging", "titanic-survival",
                            "clipstash", "real2d", "xetra", "pyspark-cdc", "quartolive", "ymisc"
                          ),
                          post_path = "~/workspace/qiushiyan.dev/posts") {
  github_data <- github_data(from, github_user)
  if (is.null(from)) {
    from <- lubridate::today() - lubridate::years(1)
  } else {
    from <- lubridate::as_date(from)
  }

  to <- lubridate::as_date(to)

  all_data <- dplyr::bind_rows(
    dplyr::select(dplyr::filter(github_data, count > 0), date, type, tip, link, count),
    dplyr::select(cran_pkg_data(github_user), date, type, tip, link),
    dplyr::select(post_data(post_path), date, type, tip, link),
    dplyr::select(repos_data(github_repos), date, type, tip, link)
  )

  empty_days <- dplyr::filter(github_data, count == 0, !(date %in% all_data$date)) |>
    dplyr::mutate(type = NA) |>
    dplyr::select(date, type)

  dplyr::bind_rows(
    all_data,
    empty_days
  ) |>
    dplyr::filter(date >= from, date <= to)
}


github_data <- function(from = NULL, user = "qiushiyan") {
  if (is.null(from)) {
    url <- stringr::str_glue("https://github.com/users/{user}/contributions")
  } else {
    url <- stringr::str_glue("https://github.com/users/{user}/contributions?from={from}")
  }

  html <- rvest::read_html(url)

  calendar <- rvest::html_node(html, ".js-calendar-graph-svg")
  calendar_days <- rvest::html_nodes(calendar, "rect")
  gh_data <- tibble::tibble(
    date = as.Date(rvest::html_attr(calendar_days, "data-date")),
    count = rvest::html_attr(calendar_days, "data-count"),
    type = "github",
    tip = stringr::str_glue("<b>Github<b>: {count} commits"),
    link = stringr::str_glue("https://github.com/{user}?from={date}&to={date}&tab=overview"),
  )
  gh_data
}

post_data <- function(path = "~/workspace/qiushiyan.dev/posts") {
  posts <- list.files(path, recursive = TRUE, full.names = FALSE, pattern = "^index[.]q?md")
  post_data <- purrr::map_dfr(purrr::set_names(posts, dirname(posts)), function(file) {
    data <- rmarkdown::yaml_front_matter(here::here(path, file))
    list(
      date = as.Date(data$date),
      title = data$title
    )
  }, .id = "dir") %>%
    dplyr::mutate(
      type = "post",
      link = file.path("posts", dir),
      tip = stringr::str_glue("<b>Post</b>: {title}")
    )
  post_data
}


cran_pkg_data <- function(author = "qiushiyan", pkgs = c("agua")) {
  pkgsearch::pkg_search("Qiushi Yan") |>
    tibble::as_tibble() |>
    dplyr::filter(package %in% pkgs) |>
    dplyr::mutate(
      type = "pkg",
      link = stringr::str_glue("https://CRAN.R-project.org/package={package}"),
      tip = stringr::str_glue("<b>R package</b>: {package} {version}"),
      date = as.Date(date),
    )
}

fetch_repo <- function(repo) {
  url <- stringr::str_glue("https://api.github.com/repos/qiushiyan/{repo}")
  data <- httr::GET(
    url,
    httr::authenticate(
      Sys.getenv("GITHUB_CALENDAR_USER"),
      Sys.getenv("GITHUB_CALENDAR_PASSWORD")
    )
  ) |> httr::content()
  tibble::tibble(
    type = "project",
    link = url,
    tip = stringr::str_glue("<b>Project</b>: {data$name}<br/>{data$description}"),
    date = as.Date(data$created_at),
  )
}


repos_data <- function(repos = c(
                         "xkcd", "uuid", "potg", "qlang", "overwatcher",
                         "js-notebook", "nyclodging", "titanic-survival",
                         "clipstash", "real2d", "xetra", "pyspark-cdc", "quartolive", "ymisc"
                       )) {
  purrr::map_dfr(repos, fetch_repo)
}
