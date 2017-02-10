---
author: Xiang Ao
layout: post
title: Interaction term in a non-linear model
comments: true
tags:
  - statistics
  - R
---

In a non-linear model (for example, logit or poisson model), the
interpretation of the coefficient on the interaction term is tricky. [Ai
and Norton
(2003)](https://pdfs.semanticscholar.org/6285/8e64d9a337504d72cb862c4cc1e7fd27a7a0.pdf)
points out that the interaction term coefficient is not the same as
people can interpret as in a linear model; that is, how much effect of
*x*1 changes with the value of *x*2. They interpret this as a cross

If we have a linear model with interaction:

*E*(*y*)=*β*<sub>1</sub>*x*<sub>1</sub> + *β*<sub>2</sub>*x*<sub>2</sub> + *β*<sub>12</sub>*x*<sub>1</sub> \* *x*<sub>2</sub>

Then, the marginal effect

$$ \\frac{\\partial^2 E(y)}{\\partial x\_1 \\partial x\_2} = \\beta\_{12} $$

That is, *β*<sub>12</sub> is the second derivative of *E*(*y*) on
*x*<sub>1</sub> and *x*<sub>2</sub>. The marginal effect of
*x*<sub>1</sub>

In a non-linear model,

*F*(*E*(*y*)) = *β*<sub>1</sub>*x*<sub>1</sub> + *β*<sub>2</sub>*x*<sub>2</sub> + *β*<sub>12</sub>*x*<sub>1</sub> \* *x*<sub>2</sub>

$$ \\frac{\\partial^2 F(E(y))}{\\partial x\_1 \\partial x\_2} = \\beta\_{12} $$

Here, the partial derivative of *F*(*E*(*y*)) on *x*<sub>1</sub> and
*x*<sub>2</sub> is still *β*<sub>12</sub>. However, most people are
interested in $\\frac{\\partial^2 E(y)}{\\partial x\_1 \\partial x\_2}$.

$$ \\frac{\\partial^2 E(y)}{\\partial x\_1 \\partial x\_2} = \\beta\_{12} G'() + (\\beta\_{1} + \\beta\_{12} x\_2)(\\beta\_2 + \\beta\_{12} x\_1) G''()$$

where *G*() is the inverse function of *F*().

It is true that in a non-linear model with interaction, the marginal
effect of *x*<sub>1</sub> differs with different values of
*x*<sub>2</sub>. However, even if we have a non-linear model without
interaction, the marginal effect of *x*<sub>1</sub> is still different
with different values of *x*<sub>2</sub>. To see this,

*F*(*E*(*y*)) = *β*<sub>1</sub>*x*<sub>1</sub> + *β*<sub>2</sub>*x*<sub>2</sub>

$$ \\frac{\\partial^2 E(y)}{\\partial x\_1 \\partial x\_2} =  (\\beta\_{1} \\beta\_2 ) G''()$$

Therefore, when we set up our model,

*F*(*E*(*y*)) = *β*<sub>1</sub>*x*<sub>1</sub> + *β*<sub>2</sub>*x*<sub>2</sub> + *β*<sub>12</sub>*x*<sub>1</sub> \* *x*<sub>2</sub>

we have in mind that we allow interaction of *x*<sub>1</sub> and
*x*<sub>1</sub> to interact for the effect on *F*(*E*(*y*)); not on
*E*(*y*).

We agree with [Bill Greene,
2013](http://people.stern.nyu.edu/wgreene/Lugano2013/Greene-InteractionTerms.pdf).
In a nonlinear model, the partial effects (as Greene calls it) is
nonlinear, regardless of the model. For example, in a logit model, even
if you don't have an interaction term in your model, the effect of
*x*<sub>1</sub> will still be different for every value of
*x*<sub>2</sub>, simply because it's a nonlinear model.

As Greene put it at the summary section, "Build the model based on
appropriate statistical procedures and principles. Statistical testing
about the model specification is done at this step Hypothesis tests are
about model coefficients and about the structural aspects of the model
specifications. Partial effects are neither coefficients nor elements of
the specification of the model. They are implications of the specified
and estimated model."

We also agree with [Maarten Buis
2010](http://www.stata-journal.com/sjpdf.html?articlenum=st0194), that
we should use multiplicative effect in a non-linear model. That is, in a
non-linear model,

*F*(*E*(*y*)) = *β*<sub>1</sub>*x*<sub>1</sub> + *β*<sub>2</sub>*x*<sub>2</sub> + *β*<sub>12</sub>*x*<sub>1</sub> \* *x*<sub>2</sub>

We should pay more attention to

$$ \\frac{\\partial^2 F(E(y))}{\\partial x\_1 \\partial x\_2} = \\beta\_{12} $$

For example, in a logit model,

*l**o**g*(*P*(*y* = 1)/(1 − *P*(*y* = 1)))=*β*<sub>1</sub>*x*<sub>1</sub> + *β*<sub>2</sub>*x*<sub>2</sub> + *β*<sub>12</sub>*x*<sub>1</sub> \* *x*<sub>2</sub>

That is, the log of odds is a linear function of *x*<sub>1</sub> and
*x*<sub>2</sub> and interaction. The interaction effect has the same
interpretation as the linear model, in terms of log of odds.

Or, it becomes multiplicative effect when we talk about odds ratios.
Stata's "margins" command is a great tool to calculate marginal effects
in various situations, as shown in [Maarten Buis
2010](http://www.stata-journal.com/sjpdf.html?articlenum=st0194).
