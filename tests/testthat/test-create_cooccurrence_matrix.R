test_that("tabulation works with multiple transcripts", {
  tokens <- list(
    c("a", "g", "f", "b", "a", "e", "c", "d", "b", "a"),
    c("a", "h", "i", "b", "a", "j", "c", "k", "b", "a")
  )
  types <- c("a", "b", "c")
  window_size <- 3
  expect_equal(
    create_cooccurrence_matrix(tokens, window_size, types),
    rbind(c(0, 0, 2), c(4, 0, 0), c(0, 2, 0)),
    ignore_attr = TRUE)
})

test_that("tabulation works when types are not specified", {
  tokens <- list(
    c(1, 0, 0, 2),
    c(0, 3, 1, 2)
  )
  window_size <- 3
  expect_equal(
    create_cooccurrence_matrix(tokens, window_size),
    rbind(c(1, 1, 2, 1), c(2, 0, 1, 0), c(0, 0, 0, 0), c(0, 1, 1, 0)),
    ignore_attr = TRUE)
})

test_that("tabulation works when types are specified", {
  tokens <- list(
    c(1, 0, 0, 2),
    c(0, 3, 1, 2)
  )
  types = 1:3
  window_size <- 3
  expect_equal(
    create_cooccurrence_matrix(tokens, window_size, types),
    rbind(c(0, 1, 0), c(0, 0, 0), c(1, 1, 0)),
    ignore_attr = TRUE)
})
