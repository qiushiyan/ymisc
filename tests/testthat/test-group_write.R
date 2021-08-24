library(withr)

test_that("group_write outputs correct file name", {
  with_tempdir({
    group_write(iris, Species, dir = ".")
    expect_identical(list.files(".", pattern = "iris-.+\\.csv$"),
                     c("iris-setosa.csv", "iris-versicolor.csv", "iris-virginica.csv"))
  })
})
