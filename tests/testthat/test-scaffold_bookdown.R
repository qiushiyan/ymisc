# library(withr)
# library(fs)
# library(usethis)
#
#
# test_that("scaffold_bookdown generates the specified file structure", {
#   with_tempdir({
#     scaffold_bookdown_book("test/book")
#     files <- list.files("test/book")
#     print(files)
#     expect_true(is_subset(
#       c("_output.yml", "_bookdown.yml", "_common.R", "index.Rmd", "style.css", "_dependencies.R"),
#       files
#     ))
#   })
# })
