---
author: Xiang Ao
layout: post
title: A comparison of Lewbel model vs. OLS and TSLS
comments: true
tags: statistics
---

This post is inspired by [diffuse prior](http://diffuseprior.wordpress.com/2014/05/15/the-ivlewbel-package-a-new-way-to-tackle-endogenous-regressor-models/)

[Lewbel's 2012 paper](https://www2.bc.edu/~lewbel/simhet16.pdf) proposed an estimator based on heteroscedasticity to address the problem of endogeneity without an instrument.  This problem has been an issue for many (maybe most) empirical researchers with observational data.  People are challenged with endogeneity and they have difficulty locating a valid instrument (who doesn't?).  

Using the "ivlewbel" package in R, I compare the performance of Lewbel's estimator with OLS and TSLS (two stage least square) estimators, with different values of sample size, and heteroscedasticity.

``` r
library(ivlewbel)
require(snowfall)
set.seed(666)

## initialize parallel cores.
sfInit( parallel=TRUE, cpus=12)

gen.sim <- function(df){
    k <- df['k']
    nobs <- df['nobs']
    x<-runif(nobs, min=-1, max=1)
    u <- rnorm(nobs,0,1)
    u1 <- rnorm(nobs,0,1)
    u2 <- rnorm(nobs,0,1)
    x1 <-runif(nobs, min=-1, max=1)
    x2 <- rnorm(nobs,0,1)
    z <- rnorm(nobs,0,1)
    e1 = exp(.3*k*(x+x1))*u1
    e2 = u2

    ## y1 is the endogenous variable; z is the instrument; x1 is
    ## omitted but determines heteroskedasticity of y1; e1 e2 are
    ## correlated because of common factor of u; x is the only
    ## observed exogenous variable.  The true coefficient on y1 should
    ## be 1.  lewbel model use x as both the exogenous variable and
    ## the heteroscedasticity factor.  tsls assumes we have an
    ## instrument z.  k is to adjust for degree of heteroscedasticity.
    y1 = 1 + z + x + x1 +  e1
    y2 = 1 + y1  + x + x1 +  e2
    data = data.frame(y2, y1, x1, x2, z, x)

    lewbel.model <- lewbel(formula = y2 ~ y1  | x   | x  , data = data)
    lm.model <- lm(y2 ~ y1 + x, data=data)
    tsls.model <- tsls(y2 ~ y1 + x   , ~ z + x  , data=data)

    lm.y1 <- summary(lm.model)$coefficients['y1','Estimate']-1
    tsls.y1 <- tsls.model$coefficients['y1']-1
    lewbel.y1 <- lewbel.model$coef.est['y1', 'Estimate']-1
    return(c(lm=lm.y1, lewbel=lewbel.y1,tsls=tsls.y1))
}


## set parameter space
sim.grid = seq(1,100,1)
k.grid=seq(1,10,1)
nobs.grid = ceiling(exp(seq(4, 8, 1))/100)*100
data.grid <- expand.grid(nobs.grid, sim.grid, k.grid)
names(data.grid) <- c('nobs', 'nsim', 'k')

## export functions to the slaves
## export data to the slaves if necessary
sfExport(list=list("gen.sim"))

## export function to the slaves
sfLibrary(ivlewbel)

## parallel computing
results <- data.frame(t(sfApply(data.grid, 1, gen.sim)))

## stop the cluster
sfStop()

names(results) <- c('lm','lewbel','tsls')
forshiny <- cbind(data.grid, results)
## write out for use in shiny.
write.csv(forshiny, 'results.csv')
```

The data generating processes in this simulation study are:  $$y_2$$ is the dependent variable.

$$
y_2 = y_1 + x + x_1 + e_2
$$

$$
y_1 = z + x + x_1 + e_1
$$

Here $$e_1$$ and $$e_2$$ are the error terms.  Among the independent variables of $$y_2$$, $$x$$ is observed; $$x_1$$ is unobserved, $$z$$ is the intended instruments.  $$y_1$$ is the endogenous variable, since it's determined by $$x_1$$, and $$x_1$$ is part of $$y_2$$'s error term since $$x_1$$ is unobserved.  If we have $$z$$, then we can use TSLS to estimate the model.  If not, then we'll try Lewbel's model to see if it works.  

The 'gen_sim' function returns the three estimates (OLS, TSLS and Lewbel).  $$e_1$$ is assumed to have some degree of heteroscedasticity:

$$
e_1 = e^{0.3*k*(x+x_1)}*u_1
$$

where $$u_1$$ is a standard normal variable.  $$k$$ is a variable used to adjust for degree of heteroscedasticity.  Here we assume we know a variable that determines the heteroscedasticity: $$x$$.  But $$x_1$$ remains unobserved.  

We then simulate 100 times with $$k$$ ranging from 1 to 10; number of observations from $$e^4$$ to $$e^8$$.

Since there are many simulations, we used "snowfall" library to speed things up.  

For raw code, please visit [here](https://github.com/xiangao/lewbel2).

<center>
<iframe src="https://xiangao.shinyapps.io/lewbel2/" style="border: none; width: 700px; height: 700px;"></iframe>
</center>

We can see at moderate degree of heteroscedasticity, Lewbel's estimator performs well, at reasonably large sample size.  TSLS performs well since we assume we observe $$z$$.  At very high degree of heteroscedasticity, both OLS and Lewbel's estimator perform well.  My explanation is that when there is very high degree of heteroscedasticity, heteroscedasticity just outplays endogeneity so that OLS' bias goes down (since we know that OLS under heteroscedasticity is consistent.), with large sample size.
