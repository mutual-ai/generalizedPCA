context("Multinomial")

# construct a low rank matrix in the natural parameter scale
rows = 100
cols = 10
k = 1
set.seed(1)

mat = model.matrix(~ factor(sample(1:(cols + 1), rows, replace = TRUE)) - 1)[, 1:cols]
colnames(mat) <- NULL

gpca = generalizedPCA(mat, k = k, M = 4, family = "multinomial", main_effects = TRUE)

pred1 = predict(gpca, mat)
pred1l = predict(gpca, mat, type = "link")
pred1r = predict(gpca, mat, type = "response")
fit1l = fitted(gpca, type = "link")
fit1r = fitted(gpca, type = "response")

test_that("correct classes", {
  expect_is(gpca, "gpca")

  expect_is(pred1, "matrix")
  expect_is(pred1l, "matrix")
  expect_is(pred1r, "matrix")
  expect_is(fit1l, "matrix")
  expect_is(fit1r, "matrix")

})

test_that("k = 1 dimensions", {
  expect_equal(dim(gpca$U), c(cols, 1))
  expect_equal(dim(gpca$PCs), c(rows, 1))
  expect_equal(length(gpca$mu), cols)

  expect_equal(dim(pred1), c(rows, 1))
  expect_equal(dim(pred1l), c(rows, cols))
  expect_equal(dim(pred1r), c(rows, cols))
  expect_equal(dim(fit1l), c(rows, cols))
  expect_equal(dim(fit1r), c(rows, cols))
})

rm(gpca, pred1, pred1l, pred1r, fit1l, fit1r)

k = 2
gpca = generalizedPCA(mat, k = k, M = 4, family = "multinomial", main_effects = TRUE)

pred1 = predict(gpca, mat)
pred1l = predict(gpca, mat, type = "link")
pred1r = predict(gpca, mat, type = "response")
fit1l = fitted(gpca, type = "link")
fit1r = fitted(gpca, type = "response")

test_that("k = 2 dimensions", {
  expect_equal(dim(gpca$U), c(cols, 2))
  expect_equal(dim(gpca$PCs), c(rows, 2))
  expect_equal(length(gpca$mu), cols)

  expect_equal(dim(pred1), c(rows, 2))
  expect_equal(dim(pred1l), c(rows, cols))
  expect_equal(dim(pred1r), c(rows, cols))
  expect_equal(dim(fit1l), c(rows, cols))
  expect_equal(dim(fit1r), c(rows, cols))
})

test_that("response between 0 and 1", {
  expect_gte(min(pred1r), 0)
  expect_gte(min(fit1r), 0)

  expect_lte(max(pred1r), 1)
  expect_lte(max(fit1r), 1)
})

test_that("fitted row sums = 1", {
  expect_gte(min(rowSums(pred1r)), 0)
  expect_gte(min(rowSums(fit1r)), 0)

  expect_lte(max(rowSums(pred1r)), 1)
  expect_lte(max(rowSums(fit1r)), 1)
})
