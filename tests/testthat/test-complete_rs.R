
context("Complete Random Sampling")


# Errors ------------------------------------------------------------------
test_that("expected errors",{
  expect_error(complete_rs(N = 100, n = 101))
  expect_error(complete_rs(N = 100, n = -2))
  expect_error(complete_rs(N = 0, n = 0))
  expect_error(complete_rs(N = 1, n = 2))
})

test_that("N=100",{
  S <- complete_rs(N = 100)
  probs <- complete_rs_probabilities(N = 100)
  
  expect_equal(sum(S), 50)
  expect_true(all(probs == 0.5))
})

test_that("N=100 n=30",{
    
  S <- complete_rs(100, n = 30)
  probs <- complete_rs_probabilities(N = 100, n = 30)
  expect_equal(sum(S), 30)
  
  expect_true(all.equal(probs, rep(0.3, 100)))
})

test_that("N=101 prob=.34",{
  S <- complete_rs(N = 101, prob = .34)
  probs <- complete_rs_probabilities(N = 101, prob = .34)
  expect_true(all.equal(probs, rep(0.34, 101)))
})

test_that("N=101 prob=.34 fixup",{
  S <- replicate(1e3, sum(complete_rs(N = 101, prob = .34)))
  expect_equal(sort(unique(S)), 34:35)
  expect_equal(round(mean(S)/101, 2), .34)
})


test_that("N=1 handling",{
  expect_error(S <- complete_rs(N = 1, n=.5))
  S <- complete_rs(N=1, prob=.2)
  
  #expect_equal( complete_rs_probabilities(N = 1, n=1), .5)
  expect_equal(complete_rs_probabilities(N = 1, n = 1), 1)
  expect_equal(complete_rs_probabilities(N = 1, n = 0), 0)
})


test_that("Special Cases",{
  
  expect_lt(sum(replicate(1000, complete_rs(1))), 600)
  expect_gt(sum(replicate(1000, complete_rs(1))), 400)
  # correct!
  replicate(100, complete_rs(N = 1, n = 1))
  
  expect_equal(sum(replicate(100, complete_rs(
    N = 1, n = 0
  ))), 0)
  
  expect_equal(sum(replicate(100, complete_rs(
    N = 2, n = 0
  ))), 0)
  
  expect_equal(sum(replicate(100, complete_rs(
    N = 3, n = 0
  ))), 0)
  
  expect_equal(complete_rs(N = 2, n = 2), c(1, 1))

})


test_that("_unit",{
  table(complete_rs(100, prob_unit = rep(0.4, 100)))
  expect_error(table(complete_rs(100, prob = rep(0.4, 100))))
  expect_error(complete_rs(100, prob_unit = rep(c(0.4, 0.5), c(50, 50))))
  
  table(complete_rs(100, n_unit = rep(40, 100)))
  expect_error(table(complete_rs(100, n = rep(40, 100))))
  expect_error(complete_rs(100, n_unit = rep(c(40, 50), c(50, 50))))
  
})
