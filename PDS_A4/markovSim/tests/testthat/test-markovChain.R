library(testthat)
library(markovSim)



# ---------------------------------------------------------------
# Unit tests for the MarkovChain R6 class
# ---------------------------------------------------------------

test_that("MarkovChain object is created correctly", {
  
  P <- matrix(c(
    0.7, 0.3,
    0.4, 0.6
  ), nrow = 2, byrow = TRUE)
  
  mc <- MarkovChain$new(P = P, initial_state = 1)
  
  expect_true(inherits(mc, "MarkovChain"))
  expect_equal(mc$initial_state, 1)
  expect_equal(mc$P, P)
  expect_equal(mc$K, 2)
})


test_that("simulate returns correct dimensions", {
  
  P <- matrix(c(
    0.5, 0.5,
    0.2, 0.8
  ), nrow = 2, byrow = TRUE)
  
  mc <- MarkovChain$new(P, 1)
  
  paths <- mc$simulate(n_steps = 10, n_paths = 5)
  
  # 5 paths, 11 time points (including initial state)
  expect_equal(dim(paths), c(5, 11))
  expect_true(all(paths %in% c(1, 2)))
})


test_that("marginal_distribution at time 0 is a point mass", {
  
  P <- matrix(c(
    0.6, 0.4,
    0.3, 0.7
  ), nrow = 2, byrow = TRUE)
  
  mc <- MarkovChain$new(P, initial_state = 2)
  
  pi0 <- mc$marginal_distribution(t = 0)
  
  expect_equal(pi0, c(0, 1))
})


test_that("marginal_distribution sums to one", {
  
  P <- matrix(c(
    0.8, 0.2,
    0.1, 0.9
  ), nrow = 2, byrow = TRUE)
  
  mc <- MarkovChain$new(P, 1)
  
  pi5 <- mc$marginal_distribution(t = 5)
  
  expect_equal(sum(pi5), 1, tolerance = 1e-8)
})


test_that("empirical_marginal_distribution returns valid probabilities", {
  
  P <- matrix(c(
    0.5, 0.5,
    0.5, 0.5
  ), nrow = 2, byrow = TRUE)
  
  mc <- MarkovChain$new(P, 1)
  
  paths <- mc$simulate(n_steps = 5, n_paths = 100)
  emp <- mc$empirical_marginal_distribution(paths)
  
  # One row per time point, one column per state
  expect_equal(dim(emp), c(6, 2))
  
  # Each empirical distribution should sum to 1
  for (t in 1:nrow(emp)) {
    expect_equal(sum(emp[t, ]), 1, tolerance = 1e-8)
  }
})


test_that("simulate uses correct initial state", {
  
  P <- matrix(c(
    1, 0,
    0, 1
  ), nrow = 2, byrow = TRUE)
  
  mc <- MarkovChain$new(P, initial_state = 2)
  
  paths <- mc$simulate(n_steps = 3, n_paths = 4)
  
  # All paths must start at state 2
  expect_true(all(paths[, 1] == 2))
})

