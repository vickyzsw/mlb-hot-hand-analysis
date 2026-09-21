validate_binary_hits <- function(hits) {
  if (length(hits) < 2L || anyNA(hits) || !all(hits %in% c(0, 1))) {
    stop("hits must contain at least two non-missing binary outcomes")
  }
  as.integer(hits)
}

rolling_batting_average <- function(hits, window = 25L) {
  hits <- validate_binary_hits(hits)
  window <- as.integer(window)
  if (length(window) != 1L || is.na(window) || window < 2L || window > length(hits)) {
    stop("window must be between 2 and the number of outcomes")
  }
  as.numeric(stats::filter(hits, rep(1 / window, window), sides = 1))
}

rolling_variance <- function(hits, window = 25L) {
  values <- rolling_batting_average(hits, window)
  stats::var(values[!is.na(values)])
}

lag1_correlation <- function(hits) {
  hits <- validate_binary_hits(hits)
  if (stats::sd(hits[-length(hits)]) == 0 || stats::sd(hits[-1L]) == 0) {
    return(NA_real_)
  }
  stats::cor(hits[-length(hits)], hits[-1L])
}

longest_hit_run <- function(hits) {
  hits <- validate_binary_hits(hits)
  runs <- rle(hits)
  hit_lengths <- runs$lengths[runs$values == 1L]
  if (length(hit_lengths) == 0L) 0L else max(hit_lengths)
}

monte_carlo_p <- function(simulated, observed, tail = c("upper", "lower", "two-sided")) {
  tail <- match.arg(tail)
  simulated <- simulated[is.finite(simulated)]
  if (!is.finite(observed) || length(simulated) == 0L) stop("statistics must be finite")
  exceedances <- switch(
    tail,
    upper = sum(simulated >= observed),
    lower = sum(simulated <= observed),
    `two-sided` = sum(abs(simulated) >= abs(observed))
  )
  (exceedances + 1) / (length(simulated) + 1)
}

simulate_bernoulli_null <- function(n, probability, statistic, simulations = 5000L,
                                    seed = 123L, ...) {
  if (n < 2L || probability < 0 || probability > 1 || simulations < 1L) {
    stop("invalid simulation parameters")
  }
  set.seed(seed)
  replicate(simulations, statistic(stats::rbinom(n, 1, probability), ...))
}

simulate_permutation_null <- function(hits, statistic, simulations = 5000L,
                                      seed = 123L, ...) {
  hits <- validate_binary_hits(hits)
  set.seed(seed)
  replicate(simulations, statistic(sample(hits, replace = FALSE), ...))
}
