path <- tempdir()
group_write(iris, Species, dir = path)

test_that("multiplication works", {
  expect_identical(list.files(path, pattern = "iris-.+\\.csv$"),
                   c("iris-setosa.csv", "iris-versicolor.csv", "iris-virginica.csv"))
})
