test_that("windows are defined as expected", {
  tokens <- numeric(10)
  type <- 1
  ix <- c(1,4,6)
  tokens[ix] <- 1
  window_size <- 3
  expect_equal(
    netbuildr:::get_forward_windows(tokens, type, window_size),
    cbind(ix, ix + 1, ix + 2),
    ignore_attr = TRUE
  )
  window_size <- 5
  expect_equal(
    netbuildr:::get_forward_windows(tokens, type, window_size),
    cbind(ix, ix + 1, ix + 2, ix + 3, ix + 4),
    ignore_attr = TRUE
  )
})

test_that("Indexing beyond the end of the transcript returns NA", {
  tokens <- numeric(10)
  type <- 1
  ix <- c(1,4,6,9)
  tokens[ix] <- 1
  window_size <- 3
  expect_equal(
    netbuildr:::get_forward_windows(tokens, type, window_size)[4, 3],
    NA_integer_,
    ignore_attr = TRUE
  )
})
