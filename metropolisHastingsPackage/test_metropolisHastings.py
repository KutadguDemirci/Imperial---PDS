import unittest
import numpy as np

from mcmcsampling.metropolisHastings import MetropolisHastings


# Simple log_target function for testing
def log_target_t(x):
    return -0.5 * x**2


class TestMetropolisHastings(unittest.TestCase):

    def setUp(self):
        """Set up a basic Metropolis-Hastings sampler"""
        self.sampler = MetropolisHastings(
            log_target=log_target_t,
            proposal_std=1.0,
            initial_state=0.0,
            seed=42
        )

    def test_initial_state(self):
        """Check that the sampler initializes correctly"""
        self.assertEqual(self.sampler.current_state, 0.0)
        self.assertEqual(self.sampler.accepted, 0)
        self.assertEqual(self.sampler.total_steps, 0)
        self.assertEqual(self.sampler.acceptance_rate(), 0)

    def test_invalid_log_target(self):
        """Check that invalid log_target raises TypeError"""
        with self.assertRaises(TypeError):
            MetropolisHastings(
                log_target=123,
                proposal_std=1.0,
                initial_state=0.0
            )

    def test_invalid_proposal_std(self):
        """Check invalid proposal_std values"""
        with self.assertRaises(TypeError):
            MetropolisHastings(
                log_target=log_target_t,
                proposal_std="abc",
                initial_state=0.0
            )

        with self.assertRaises(ValueError):
            MetropolisHastings(
                log_target=log_target_t,
                proposal_std=-1.0,
                initial_state=0.0
            )

    def test_step(self):
        """Check that one step updates counters and returns a state"""
        state_before = self.sampler.current_state
        state_after = self.sampler.step()

        self.assertEqual(self.sampler.total_steps, 1)
        self.assertIn(self.sampler.accepted, [0, 1])
        self.assertIsInstance(state_after, float)
        self.assertEqual(self.sampler.current_state, state_after)

    def test_acceptance_rate(self):
        """Check acceptance rate after several steps"""
        for _ in range(10):
            self.sampler.step()

        rate = self.sampler.acceptance_rate()
        self.assertGreaterEqual(rate, 0)
        self.assertLessEqual(rate, 1)

    def test_sample_output(self):
        """Check that sample returns correct number of samples"""
        samples = self.sampler.sample(n_samples=5, burn_in=3)

        self.assertIsInstance(samples, np.ndarray)
        self.assertEqual(len(samples), 5)

    def test_reproducibility(self):
        """Check reproducibility when using the same seed"""
        sampler1 = MetropolisHastings(
            log_target=log_target_t,
            proposal_std=1.0,
            initial_state=0.0,
            seed=123
        )

        sampler2 = MetropolisHastings(
            log_target=log_target_t,
            proposal_std=1.0,
            initial_state=0.0,
            seed=123
        )
        np.random.seed(123)
        samples1 = sampler1.sample(10)
        np.random.seed(123)
        samples2 = sampler2.sample(10)

        np.testing.assert_allclose(samples1, samples2)


unittest.TextTestRunner().run(
    unittest.defaultTestLoader.loadTestsFromTestCase(TestMetropolisHastings)
)
