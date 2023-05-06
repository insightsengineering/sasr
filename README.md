# sasr

<img src="man/figures/sasr-logo.svg" align="right" alt="" width="180">

<!-- start badges -->
[![Code Coverage](https://raw.githubusercontent.com/insightsengineering/sasr/_xml_coverage_reports/data/main/badge.svg)](https://raw.githubusercontent.com/insightsengineering/sasr/_xml_coverage_reports/data/main/coverage.xml)
<!-- end badges -->

This package provides interface to SAS through `saspy` and `reticulate`.

## Prerequisites

To use `sasr`, you need to make sure you have the following

1. An SAS server that is accessible from the machine that you want to run `sasr` on
1. The machine that you want to run `sasr` has Python and Java

## Installation

To install `sasr`, please use the following command

```{r}
remotes::install_github(repo = 'insightsengineering/sasr')
```

Reticulate will be installed automatically, but Python package `saspy` will not.

If you do not have Python, you can use the following code to install Python, or it can be installed automatically after you call some python related stuffs.

```{r}
library(reticulate)
install_python()
```

To install `saspy`, use the following code

```{r}
library(sasr)
install_saspy()
```

After the installation completes, you are ready to use `sasr` package.

### Short Example

```{r}
library(sasr)
df2sd(mtcars, "mt")
result <- run_sas("
  proc freq data = mt;
  run;
")

cat(result$LOG)

cat(result$LST)
```

## FAQ

Q: Why use `saspy` instead of using `ssh` tunnels?

A: Although we can use `ssh` tunnels to transfer data and
execute SAS commands, there are many restrictions: it only
supports `ssh` connection. Using `saspy`, the official Python
interface to SAS, we can enable all connection types, without
reinventing the wheel, e.g. we can also connect to a local SAS
installation with the same syntax, or connect to a remote SAS
Viya through `http`. In addition, SAS sessions in `saspy` will
not end until you terminate it (or encounter net work issues),
it will be nice to execute multiple SAS code one by one, not
necessarily putting them in one script and execute the whole
script at once. Also, with the update of `saspy` over time,
`sasr` will be easily extensible, to include functionalities
other than transferring data and executing SAS code.
