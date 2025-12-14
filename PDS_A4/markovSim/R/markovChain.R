library(R6)
library(igraph)

# MarkovChain class ---------------------------------------------

MarkovChain <- R6Class(
  "MarkovChain",
  
  public = list(
    
    # -------- Fields --------
    initial_state = NULL,
    P = NULL,
    K = NULL,
    
    # -------- Initialize --------
    #' Create a Markov chain object
    #' @param P Transition matrix
    #' @param initial_state Initial state index
    initialize = function(P, initial_state) {
      
      # Defensive checks
      if (!is.matrix(P)) {
        stop("P must be a matrix")
      }
      
      if (nrow(P) != ncol(P)) {
        stop("P must be a square matrix")
      }
      
      if (any(P < 0) || any(P > 1)) {
        stop("Entries of P must be between 0 and 1")
      }
      
      if (any(abs(rowSums(P) - 1) > 1e-8)) {
        stop("Rows of P must sum to 1")
      }
      
      K <- nrow(P)
      
      if (!is.numeric(initial_state) ||
          length(initial_state) != 1 ||
          initial_state < 1 ||
          initial_state > K) {
        stop("initial_state must be an integer between 1 and K")
      }
      
      self$P <- P
      self$initial_state <- initial_state
      self$K <- K
    },
    
    # -------- Simulate paths --------
    #' Simulate Markov chain paths
    #' @param n_steps Number of steps
    #' @param n_paths Number of independent paths
    simulate = function(n_steps, n_paths) {
      
      if (n_steps <= 0 || n_paths <= 0) {
        stop("n_steps and n_paths must be positive")
      }
      
      paths <- matrix(NA, nrow = n_paths, ncol = n_steps + 1)
      paths[, 1] <- self$initial_state
      
      for (p in 1:n_paths) {
        for (t in 1:n_steps) {
          current <- paths[p, t]
          paths[p, t + 1] <- sample(
            1:self$K,
            size = 1,
            prob = self$P[current, ]
          )
        }
      }
      
      return(paths)
    },
    
    # -------- Marginal distribution --------
    #' Marginal distribution at time t
    #' @param t Time step
    marginal_distribution = function(t) {
      
      if (t < 0) {
        stop("t must be non-negative")
      }
      
      pi0 <- rep(0, self$K)
      pi0[self$initial_state] <- 1
      
      Pt <- self$P
      if (t == 0) {
        return(pi0)
      }
      
      for (i in 2:t) {
        Pt <- Pt %*% self$P
      }
      
      as.numeric(pi0 %*% Pt)
    },
    
    # -------- Empirical marginal distribution --------
    #' Empirical distribution from simulated paths
    #' @param paths Simulation output from simulate()
    empirical_marginal_distribution = function(paths) {
      
      if (!is.matrix(paths)) {
        stop("paths must be a matrix")
      }
      
      n_steps <- ncol(paths)
      emp <- matrix(0, nrow = n_steps, ncol = self$K)
      
      for (t in 1:n_steps) {
        tab <- table(factor(paths[, t], levels = 1:self$K))
        emp[t, ] <- tab / nrow(paths)
      }
      
      return(emp)
    },
    
    # -------- Stationary distribution --------
    #' Estimate stationary distribution using power method
    #' @param tol Convergence tolerance
    #' @param max_iter Maximum iterations
    stationary_distribution = function(tol = 1e-8, max_iter = 1000) {
      
      pi <- rep(0, self$K)
      pi[self$initial_state] <- 1
      
      for (i in 1:max_iter) {
        pi_new <- as.numeric(pi %*% self$P)
        
        if (max(abs(pi_new - pi)) < tol) {
          return(pi_new)
        }
        
        pi <- pi_new
      }
      
      warning("Power method did not converge")
      return(pi)
    },
    
    # -------- Visualisation --------
    #' Visualise transition graph
    visualise = function() {
      
      g <- graph_from_adjacency_matrix(
        self$P,
        mode = "directed",
        weighted = TRUE
      )
      
      plot(
        g,
        edge.label = round(E(g)$weight, 2),
        vertex.label = 1:self$K
      )
    }
  )
)

