---
author: Xiang Ao
layout: post
title: Interpreting interaction term in a regression model
comments: true
tags:
  - statistics
  - R
---


Interaction with two binary variables
=====================================

In a regression model with interaction term, people tend to pay
attention to only the coefficient of the interaction term.

Let's start with the simpliest situation: *x*<sub>1</sub> and
*x*<sub>2</sub> are binary and coded 0/1.

*E*(*y*)=*β*<sub>1</sub>*x*<sub>1</sub> + *β*<sub>2</sub>*x*<sub>2</sub> + *β*<sub>12</sub>*x*<sub>1</sub> \* *x*<sub>2</sub>

In this case, we have a saturated model; that is, we have three
coefficients representing additive effects from the baseline situation
(both *x*<sub>1</sub> and *x*<sub>2</sub> being 0). There are four
different situations, with four combinations of *x*<sub>1</sub> and
*x*<sub>2</sub>. Say we regress logged wage on union member and race
being black:

A lot of people just pay attention to the interaction term. In the case
of studying treatment effects between two groups, say female and male,
that makes sense, the interaction term representing the difference
between male and female in terms of treatment effect.

In this model:

*E*(*y*)=*β*<sub>1</sub>*f**e**m**a**l**e* + *β*<sub>2</sub>*t**r**e**a**t**m**e**n**t* + *β*<sub>12</sub>*f**e**m**a**l**e* \* *t**r**e**a**t**m**e**n**t*

The two dummy-coded binary variables, female and treatment, form four
combinations. The following 2x2 table represents the expected means of
the four cells(combinations).

<table>
<thead>
<tr class="header">
<th></th>
<th align="center">male</th>
<th align="center">female</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>control</td>
<td align="center">$_0 $</td>
<td align="center"><br /><span class="math display"><em>β</em><sub>0</sub> + <em>β</em><sub>1</sub></span><br /></td>
</tr>
<tr class="even">
<td>treatment</td>
<td align="center">$_0 + _2 $</td>
<td align="center"><br /><span class="math display"><em>β</em><sub>0</sub> + <em>β</em><sub>1</sub> + <em>β</em><sub>2</sub> + <em>β</em><sub>12</sub></span><br /></td>
</tr>
</tbody>
</table>

We can see from this table that, for example,

*β*<sub>0</sub> = *E*(*Y*|(0, 0))
;

that is, *β*<sub>0</sub> is the expected mean of the cell (0,0) (male
and control).

*β*<sub>0</sub> + *β*<sub>1</sub> = *E*(*Y*|(1, 0))
;

that is ,*β*<sub>0</sub> + *β*<sub>1</sub> is the expected mean of the
cell (1,0) (female and control). And so on.

Now,

*β*<sub>12</sub> = (*E*(*Y*|(1, 1)) − *E*(*Y*|(0, 1)))−(*E*(*Y*|(1, 0)) − *E*(*Y*|(0, 0)))

that is, the coefficient on the interaction term is actually the
difference in difference. That's why in many situations, people are only
interested in the interaction coefficient, since they are only
interested in the diff-in-diff estimates. The usually diff-in-diff
estimator in causal inference literature refer to something similar,
instead of female vs. male, people are interested in the treatment
effect difference in before and after treatment. If we simply replace
female/male dummy with before/after dummy, we can use the same logic. In
those situations, it's fine to mainly focus on the interaction term
coefficient.

In some other situations, the three coefficients are equally important.
It depends on your interest. For example, if we are interested in
studying differences between union member and non-union member and black
vs. non-black, we may not be only interested in the interaction effect.
Instead, we might be interested in all four cells, maybe all possible
pairwise comparisons. In that case, we should pay attention to all three
coefficients. Stata's "margins" command is of great help if we'd like to
compare the cell means.

Let's take a look from a sample example in Stata:

    webuse union3
    reg ln_wage i.union##i.black, r
    margins union#black
    margins union#black, pwcompare

    ## 
    ## . webuse union3
    ## (National Longitudinal Survey.  Young Women 14-26 years of age in 1968)
    ## 
    ## . reg ln_wage i.union##i.black, r
    ## 
    ## Linear regression                               Number of obs     =      1,244
    ##                                                 F(3, 1240)        =      34.76
    ##                                                 Prob > F          =     0.0000
    ##                                                 R-squared         =     0.0762
    ##                                                 Root MSE          =     .37699
    ## 
    ## ------------------------------------------------------------------------------
    ##              |               Robust
    ##      ln_wage |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
    ## -------------+----------------------------------------------------------------
    ##      1.union |   .2045053   .0291682     7.01   0.000     .1472808    .2617298
    ##      1.black |  -.1709034   .0308067    -5.55   0.000    -.2313425   -.1104644
    ##              |
    ##  union#black |
    ##         1 1  |   .0386275   .0516609     0.75   0.455     -.062725      .13998
    ##              |
    ##        _cons |   1.657525   .0138278   119.87   0.000     1.630396    1.684653
    ## ------------------------------------------------------------------------------
    ## 
    ## . margins union#black
    ## 
    ## Adjusted predictions                            Number of obs     =      1,244
    ## Model VCE    : Robust
    ## 
    ## Expression   : Linear prediction, predict()
    ## 
    ## ------------------------------------------------------------------------------
    ##              |            Delta-method
    ##              |     Margin   Std. Err.      t    P>|t|     [95% Conf. Interval]
    ## -------------+----------------------------------------------------------------
    ##  union#black |
    ##         0 0  |   1.657525   .0138278   119.87   0.000     1.630396    1.684653
    ##         0 1  |   1.486621    .027529    54.00   0.000     1.432613     1.54063
    ##         1 0  |    1.86203   .0256822    72.50   0.000     1.811644    1.912415
    ##         1 1  |   1.729754   .0325611    53.12   0.000     1.665873    1.793635
    ## ------------------------------------------------------------------------------
    ## 
    ## . margins union#black, pwcompare
    ## 
    ## Pairwise comparisons of adjusted predictions
    ## Model VCE    : Robust
    ## 
    ## Expression   : Linear prediction, predict()
    ## 
    ## -----------------------------------------------------------------
    ##                 |            Delta-method         Unadjusted
    ##                 |   Contrast   Std. Err.     [95% Conf. Interval]
    ## ----------------+------------------------------------------------
    ##     union#black |
    ## (0 1) vs (0 0)  |  -.1709034   .0308067     -.2313425   -.1104644
    ## (1 0) vs (0 0)  |   .2045053   .0291682      .1472808    .2617298
    ## (1 1) vs (0 0)  |   .0722294   .0353756      .0028268     .141632
    ## (1 0) vs (0 1)  |   .3754087   .0376487      .3015466    .4492709
    ## (1 1) vs (0 1)  |   .2431328   .0426388      .1594807     .326785
    ## (1 1) vs (1 0)  |  -.1322759   .0414705     -.2136359   -.0509159
    ## -----------------------------------------------------------------
    ## 
    ## .

What we get by using "margins unio\#black" is the four cell means of
*E*(*Y*), in this case, log of wage. Then "margins union\#black,
pwcompare" tells us all pairwise comparison of these four cell means.
Instead of only paying attention to the interaction coefficient, in this
case we might be interested in some comparisons of the four different
situations of union and black. In fact, in this example, despite the
interaction term being insignificant, all six comparisons of the cell
means turn out to have 95% confidence intervals that do not include
zero.

Interaction with continuous variables
=====================================

Let's start with the simpliest situation: *x*<sub>1</sub> and
*x*<sub>2</sub> are continuous.

*E*(*y*)=*β*<sub>1</sub>*x*<sub>1</sub> + *β*<sub>2</sub>*x*<sub>2</sub> + *β*<sub>12</sub>*x*<sub>1</sub> \* *x*<sub>2</sub>

In this case, we recommend "centering" *x*<sub>1</sub> and
*x*<sub>2</sub> if they are continuous; that is, subtracting the mean
value from each continuous independent variable when they are involved
in the interaction term. There are two reason for it:

1.  To reduce multi-collinearity. If the range of *x*<sub>1</sub> and
    *x*<sub>2</sub> include only positive numbers, then
    *x*<sub>1</sub> \* *x*<sub>2</sub> can be highly correlated with
    both or one of *x*<sub>1</sub> and *x*<sub>2</sub>. This can lead to
    numerical problems and unstable coefficient estimates
    (multi-collinearity problem).

"Centering" can reduce the correlation between the interaction term and
the independent variables. If the original variables are normally
distributed, interaction term after centering is actually uncorrelated
with the original variables. When they are not normally distributed,
centering will still reduce the correlation to a large degree.

1.  To help with interpretation. In a model with interaction,
    *β*<sub>1</sub> represents the effect of *x*<sub>1</sub> when
    *x*<sub>2</sub> is zero. However, in many situations, zero is not
    within the range of *x*<sub>2</sub>. After centering, centered
    *x*<sub>2</sub> at zero simply means original *x*<sub>2</sub> at its
    mean value.

When we have dummy variable interacting with continuous variable, only
continuous variable should be centered.

Again, Stata's margins command is helpful.

    sysuse auto
    gen mpg_centered=mpg-r(mean)
    sum mpg_centered
    reg price i.foreign##c.mpg_centered
    margins foreign, at(mpg_centered=(-3 (1) 3))
    marginsplot

    ## 
    ## . sysuse auto
    ## (1978 Automobile Data)
    ## 
    ## . gen mpg_centered=mpg-r(mean)
    ## (74 missing values generated)
    ## 
    ## . sum mpg_centered
    ## 
    ##     Variable |        Obs        Mean    Std. Dev.       Min        Max
    ## -------------+---------------------------------------------------------
    ## mpg_centered |          0
    ## 
    ## . reg price i.foreign##c.mpg_centered
    ## no observations
    ## r(2000);
    ## 
    ## end of do-file
    ## r(2000);

In this example, the graph shows the predicted price for foreign and
domestic cars at different level of mpg.
