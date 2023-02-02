# sasr

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

## Short Tutorial

To use `sasr`, you need to follow these steps

1. Configure your SAS server in `sascfg_personal.py` under your working directory or the home directory. This is the default file that `sasr` will look at. However, you can still change that through `options(sascfg = )`, then `sasr` will try to find any name that is available in your specified option.
    1. If you don't know how to create this file, use `sascfg()` to create the file. Required arguments include `host` and `saspath`.
        1. `sascfg()` only creates ssh based SAS session.
        1. Only password-less ssh connection is supported, e.g. ssh via public keys.
        1. `host` is the hostname of the SAS server.
        1. `saspath` is the SAS executable path on the SAS server.
        1. Other arguments are added to the configuration file directly.
        1. `tunnel` and `rtunnel` are required if you want to transfer datasets between R and SAS. Use integers like `tunnel = 9999L` in R, or modify `sascfg_personal.py` to make sure they are integers.
    1. You can create the configuration by yourself and then SAS connection will not be restricted to ssh.
    1. You can have multiple configuration files with different file names
1. Create the SAS session based on the configuration file
    1. To use the default connection specified in the configuration file, you can run any command like `run_sas`, `df2sd` or `sd2df`.
        1. The session will be created if there is no session available stored in `.sasr_env$.sas_session`
        1. If `.sasr_env$.sas_session` is created, this session will be used by default.
        1. Do not create any variable called `.sas_session` in environment `sasr:::.sasr_env`
    1. To create the session manually, you can call `sas_session_ssh()`
        1. `SAS_session` have one argument `sascfg`, pointing to the SAS session configuration file.
    1. To use multiple sessions, you need to store the session `your_session <- sas_session_ssh(sascfg)`
1. Transfer the datasets from R to SAS using `df2sd`
    1. Tunneling must be enabled to transfer datasets.
    1. The variable names of the datasets should not contain dots otherwise SAS may not recognize.
    1. The index (row names) will not be transferred to SAS.
1. Use `run_sas` to submit SAS code to the SAS server.
    1. The returned value is a named list, `LST` is the result and `LOG` is the log file
    1. `run_sas` has argument `results=`, it can be either "TEXT" or "HTML". This argument decides the LST format.
1. Transfer SAS datasets back to R use `sd2df`

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
