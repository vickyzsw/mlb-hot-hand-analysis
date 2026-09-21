source(file.path("R", "streak_statistics.R"))

testthat::test_that("longest run handles no hits and boundary runs", {
  testthat::expect_equal(longest_hit_run(c(0, 0, 0)), 0L)
  testthat::expect_equal(longest_hit_run(c(1, 1, 0, 1)), 2L)
})

testthat::test_that("rolling statistic validates windows", {
  testthat::expect_error(rolling_variance(c(0, 1), 3), "window")
  testthat::expect_equal(
    rolling_batting_average(c(1, 0, 1, 0), 2),
    c(NA, 0.5, 0.5, 0.5)
  )
})

testthat::test_that("Monte Carlo correction never produces zero", {
  testthat::expect_equal(monte_carlo_p(rep(0, 9), 1), 0.1)
})

testthat::test_that("permutation null preserves hit count", {
  hits <- c(1, 1, 0, 0, 0)
  draws <- simulate_permutation_null(hits, sum, simulations = 10)
  testthat::expect_true(all(draws == 2))
})
