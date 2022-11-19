# library(withr)
#
# test_that("gh_raw_url works for normal repo", {
#   with_tempdir({
#     url <- gh_raw_url("qiushiyan/pins", "data.txt", branch = "master")
#     expect_equal(download.file(url, "codes.csv", mode = "w"), 0)
#   })
# })
#
#
# test_that("gh_raw_url works for lfs storage", {
#   with_tempdir({
#     url <- gh_raw_url("qiushiyan/blog-data", "codes.csv", lfs = TRUE)
#     expect_equal(download.file(url, "codes.csv", mode = "w"), 0)
#   })
# })
