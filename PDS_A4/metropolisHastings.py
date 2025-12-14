# Import allowed libraries

import numpy as np
import pandas as pd
import unittest

# Create the class

class MetropolisHastings:

    #Create the asked fields
    def __init__(self, log_target, proposel_std, current_state):
        
        # log_target returns the log of the unnormalised target density pi
        self.log_target = log_target

        # proposel_std returns the standard deviation of the guassian proposel
        self.proposel_std = proposel_std

        # current_state is is the current state of the sampler
        self.current_state = current_state

    def acceptence_rate(self):
        #return the acceptance rate of the sampler
        pass

    def step(self):
        # perform a single step in the algo,
        # update the current state or keep it unchanged.
        pass

    def sample(self):
        # takes the wanted number of wanted samples,
        #  n_sample and the length of the burn_in period 
        # runs the also for n_samples + burn_in steps and
        # returns n_samples samples after the burn_in phase
        pass