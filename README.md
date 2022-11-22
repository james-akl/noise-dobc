# Noise Extraction in Disturbance Observer-Based Control

This project explores **Computational Inverse Problems** techniques and formulations as applied to Disturbance Observer-Based Control (DOBC).

[**Project Page**](https://jamesakl.com/noise-dobc) | [**PDF Report**](https://jamesakl.com/noise-dobc.pdf)

The DOBC noise estimation problem is restructured into an Inverse Problems formulation, specifically a discretized Fredholm integral equation of the first kind. The system is thus transformed into an ill-posed linear system.

Three distinct methods are implemented and used as solvers:

* **Tikhonov regularization** implemented via Singular-Value Decomposition (SVD)
* **Conjugate gradient least-squares**
* **Stochastic gradient descent**

The system is simulated and solved under four disturbance scenarios:

* No disturbance
* Constant disturbance
* Sinusoidal disturbance
* Gaussian random disturbance

The PDF details the methodology, mathematical formulation, simulation, results, and discussion.

The project scripts have been implemented in MATLAB and are mostly compatible with open-source MATLAB cognates such as [GNU Octave](https://www.gnu.org/software/octave/).
