import numpy as np

class MetropolisHastings:
    """
    Simple Metropolis-Hastings sampler for generating samples from a target distribution.
    """
    
    def __init__(self, log_target, proposal_std, initial_state, seed=None):
        """
        Initialize the sampler.
        
        log_target: function that returns log of target density
        proposal_std: standard deviation of Gaussian proposal
        initial_state: starting point for the chain
        seed: random seed for reproducibility, None by default
        """
        # Raising errors for wrong inputs
        if not callable(log_target):
            raise TypeError("log_target must be a callable function")
        
        try:
            proposal_std = float(proposal_std)
        except (ValueError, TypeError):
            raise TypeError("proposal_std must be convertible to float")
        
        if proposal_std <= 0:
            raise ValueError("proposal_std must be positive")
        
        self.log_target = log_target
        self.proposal_std = proposal_std
        self.current_state = initial_state
        
        # Set up random number generator
        if seed is not None:
            np.random.seed(seed)
        
        # Track acceptance for acceptance rate
        self.accepted = 0
        self.total_steps = 0
    
    def acceptance_rate(self):
        """
        Return the current acceptance rate.
        """
        if self.total_steps == 0:
            return 0
        return self.accepted / self.total_steps
    
    def step(self):
        """
        Perform one Metropolis-Hastings step.
        """
        # Draw proposal
        proposal = self.current_state + np.random.normal(0, self.proposal_std)
        
        # Compute acceptance probability min(1,pi(y)/pi(x)), log(y/x)=log(y)-log(x)
        acceptence_prob = min(1, np.exp((self.log_target(proposal) - self.log_target(self.current_state))))

        z = np.random.uniform(low=0,high=1)

        
        # Accept or reject, depending on the given condition
        if z<acceptence_prob:
            self.current_state = proposal
            self.accepted += 1
        
        self.total_steps += 1
        return self.current_state
    
    def sample(self, n_samples, burn_in=0):
        """
        Generate samples from the target distribution.
        
        n_samples: number of samples to return after burn-in
        burn_in: number of initial samples to discard, zero by default
        """
        samples = []
        
        # Run the chain for n_samples
        for i in range(burn_in + n_samples):
            current = self.step()
            
            # Only keep samples after burn-in
            if i >= burn_in:
                samples.append(current)
        
        return np.array(samples)