test_that("tabulation works with numbers", {
  tokens <- c(1, 0, 0, 2, 1, 0, 3, 0, 2, 1)
  types <- 1:3
  window_size <- 3
  expect_equal(
    netbuildr:::tabulate_cooccurrence_among_types(tokens, types, window_size),
    rbind(c(0, 0, 1), c(2, 0, 0), c(0, 1, 0)),
    ignore_attr = TRUE)
})
test_that("tabulation works with characters", {
  tokens <- c("a", "g", "f", "b", "a", "e", "c", "d", "b", "a")
  types <- c("a", "b", "c")
  window_size <- 3
  expect_equal(
    netbuildr:::tabulate_cooccurrence_among_types(tokens, types, window_size),
    rbind(c(0, 0, 1), c(2, 0, 0), c(0, 1, 0)),
    ignore_attr = TRUE)
})

test_that("tabulation works with factors", {
  tokens <- factor(c(1, 0, 0, 2, 1, 0, 3, 0, 2, 1), levels = 1:3, labels = c("a", "b", "c"))
  types <- c("a", "b", "c")
  window_size <- 3
  expect_equal(
    netbuildr:::tabulate_cooccurrence_among_types(tokens, types, window_size),
    rbind(c(0, 0, 1), c(2, 0, 0), c(0, 1, 0)),
    ignore_attr = TRUE)
})
