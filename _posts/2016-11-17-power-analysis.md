---
title: Power Analysis
author: Andrew Marder
---

# Introduction

Given a data generation process, how likely is one to find a
statistically significant effect?

- How much data should be collected?
- How much will it cost?
- Is this experiment feasible?

# Setup

1.  Choose a model (data generating process). $$ F(y | x; \beta) $$
2.  Let $\hat{\beta}$ be an estimator for $\beta$.
3.  Under the alternative hypothesis that $\beta$ equals $\beta_a$, if we collect
    $n$ observations, what is the probability of rejecting the null
    hypothesis that $\beta$ equals $0$?
    
\begin{equation}
\label{eq:1}
\text{Power} = P\left( \left\| \frac{\hat{\beta}}{\hat{\sigma}} \right\| > z_{1 - \alpha/2} \; ; \beta = \beta_a \right)
\end{equation}
    
# Approaches to Calculate Power

1.  The analytic solution. Given a data generating process and
    hypotheses of interest, it is possible to find a formula for
    power.
    
    - Moerbeek and Teerenstra (2015) have a bunch of formulas (focused
      on mixed models).
    - This requires hard math (opportunity for Mathematica or sympy).

2.  The numerical solution. Given a data generating
    process and specific values for $\beta_a$ we can simulate data using
    a random number generator to get a numerical approximation of
    power.
    
    - This requires hard programming (opportunity for a BUGS-like
      language / Stan)
    
# Comparison of Approaches

           \phantom{a}  Analytic       Numerical
----------------------  ------------   -----------
           Computation  Fast           Slow
          Problem type  Math           Programming
Always gives an answer  Probably not   Yes

Tip: Parallel computing can speed up numerical approach dramatically.
But, need to be careful in choice of random number generator.

# Project: Leslie John

Reviews nested within papers, experiment at the review-level.

-   Baseline model
    $$ y_{ij} = \alpha + \beta_1 T_{ij} + \epsilon_{ij} $$

-   Interaction effect
    $$ y_{ij} = \alpha + \beta_1 T_{ij} + \beta_2x_i + \beta_3 T_{ij} x_i + \epsilon_{ij} $$

-   Don't give extra weight to papers with many reviews
    $$ w_{ij} = \frac{1}{\sum_k \mathbf{1}(T_{ik} = T_{ij})} $$
    
-   Paper and reviewer effects seemed reasonable.

# Project: Tatiana Sandino

Store-level experiment with nested brands / workers.

-   Baseline model
    $$ y_{ijt} = \alpha_i + \gamma_j + (\beta_1 + \beta_2 T_i) \text{post}_t + \epsilon_{ijt} $$
    
-   Two different treatments
    $$ y_{ijt} = \alpha_i + \gamma_j + (\beta_1 + \beta_2 T_i + \beta_3 T_i') \text{post}_t + \epsilon_{ijt} $$
    
Modifications to DGP included:

-   $j$ could be brand or worker.
-   Different numbers of observations at each store $n_j$.
-   Different numbers of time periods $n_t$.

# Conclusion

- Although the speed of analytic solutions allows for interactive tools
like [this](http://127.0.0.1:1313/power-analysis/).

- I would use a general solution. Given a data generation process and
estimation procedure, how likely am I to reject the null?

- I am thinking about writing a general R library for this purpose.
