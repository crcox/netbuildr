test_that("an unweighted associative network can be generated", {
  cues    <- c(1,1,1,1,2,2,2,2,3,3,3,3)
  targets <- c(2,4,5,6,3,4,5,6,1,4,5,6)
  expect_equal(
    create_unweighted_network(cues, targets),
    rbind(c(F,T,F), c(F,F,T), c(T,F,F)),
    ignore_attr = TRUE)
})
