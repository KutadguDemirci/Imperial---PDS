import matplotlib.pyplot as plt
import numpy as np

def plot_trace(samples):
    """
    Plot the trace of MCMC samples.
    
    samples: array of samples
    """
    plt.figure(figsize=(10, 4))
    plt.plot(samples)
    plt.xlabel('Iteration')
    plt.ylabel('Sample value')
    plt.title('Trace plot')
    plt.grid(True, alpha=0.3)
    plt.show()

def plot_histogram(samples, bins=50):
    """
    Plot histogram of samples.
    
    samples: array of samples
    bins: number of histogram bins
    """
    plt.figure(figsize=(8, 5))
    plt.hist(samples, bins=bins, density=True, alpha=0.7, edgecolor='black')
    plt.xlabel('Value')
    plt.ylabel('Density')
    plt.title('Histogram of samples')
    plt.grid(True, alpha=0.3)
    plt.show()