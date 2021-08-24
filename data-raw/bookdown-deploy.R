bookdown_deploy <- readr::read_lines("https://raw.githubusercontent.com/qiushiyan/docker-notes/main/.github/workflows/deploy.yml?token=ALPE762UU2OSQ2NRU4IIIHLBFZE5A")
use_data(bookdown_deploy, internal = TRUE)
