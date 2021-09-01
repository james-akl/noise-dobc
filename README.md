# Noise Extraction in Disturbance Observer-Based Control

This project explores **Computational Inverse Problems** techniques and formulations as applied to Disturbance Observer-Based Control (DOBC).

The DOBC noise estimation problem is restructured into an Inverse Problems formulation, specifically a discretized Fredholm integral equation of the first kind. The system is thus transformed into an ill-posed linear system.

Three distinct methods will be used as solvers:

* **Tikhonov regularization** implemented via Singular-Value Decomposition (SVD)
* **Conjugate gradient least-squares**
* **Stochastic gradient descent**

The system is simulated and solved under four disturbance scenarios:

* No disturbance
* Constant disturbance
* Sinusoidal disturbance
* Gaussian random disturbance

