<!-- README.md is generated from README.Rmd. Please edit that file -->
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

altqplot
========

This package is at the moment just a placeholder for one function,
`alt_qplot`. Perhaps more functionality will get added, or this function
will move elsewhere, or this package will continue as is…

The goal of `alt_qplot` is to provide `qplot` like functionality for the
[altair](https://github.com/vegawidget/altair) R package (which is a
port of the [Altair python
package](https://altair-viz.github.io/index.html)). Although altair
(like `ggplot`) is very powerful thanks to the grammar of graphics
framework, sometimes you want to very quickly make a plot and it is
handy to be able to call one simple function. The purpose of the
`alt_qplot` function in this package is to provide a convenient wrapper
for quickly making a plot using altair. That plot can further be
modified using altair methods, although when making anything beyond very
simple plots, using altair directly should be preferred…

Examples
--------

``` r
library(altqplot)
#> Loading required package: altair
alt_qplot(x = mtcars$mpg)
#> The installed version of reticulate is 1.7
#> Using this version of reticulate, you will have a problem to access the vega dataset "gapminder".
#> To fix the problem, you can install the dev version of reticulate using: devtools::install_github("rstudio/reticulate")
```

![](man/figures/README-hist-1.png)

``` r
alt_qplot(x = wt, y = mpg, data = mtcars)
```

![](man/figures/README-scatter-1.png)

You can also pass the encoding as strings. When doing so, you can
specify the type (rather than altair picking its default):

``` r
alt_qplot(x = "wt", y = "mpg", color = "gear:N", data = mtcars)
```

![](man/figures/README-string-1.png)

You can also pass along altair’s long form encoding:

``` r
alt_qplot(x = alt$X("wt:Q", bin = TRUE), 
          y = alt$X("mpg:Q", bin = TRUE), 
          size = "count()", 
          data = mtcars)
```

![](man/figures/README-longform-1.png)

Future work
===========

It might be useful to add a few more options to the `alt_qplot`
function, such as facetting, although the goal is for this function to
be pretty limited (b/c if you want something more complex you should use
altair itself).

Maybe a Python version of this function/package? (although in python a
simpler interface to vegalite already exists through pdvega, and all the
nse nonsense in this function doesn’t really have python equivalents
afaik)
