# sasr

This package provides interface to SAS through `saspy` and `reticulate`.

## Pre-requistes

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

1. Configure your SAS server in `sascfg_personal.py` under your working directory. This is the default file that `sasr` will look at.
  1. If you don't know how to create this file, use `sascfg()` to create the file. Reuqired arguments include `host` and `sas`.
    1. `sascfg()` only creates ssh based SAS session.
    1. Only password-less ssh connection is supported, e.g. ssh via public keys.
    1. `host` is the hostname of the SAS server.
    1. `sas` is the SAS executable path on the SAS server.
    1. Other arguments are added to the configuration file directly.
    1. `tunnel` and `rtunnel` are reuqired if you want to transfer datasets between R and SAS. Use integers like `tunnel = 9999L` in R, or modify sascfg_personal.py to make sure they are integers.
  1. You can create the configuration by yourself and then SAS connection will not be restricted to ssh.
  1. You can have multiple configuration files with different file names
1. Create the SAS session based on the configuration file
  1. To use the default connection in `sascfg_personal.py`, you can run any command like `run_sas`, `df2sd` or `sd2df`.
    1. The session will be created if there is no session available stored in `.sas_session`
    1. If `.sas_session` is created, this session will be used by default.
    1. Do not create any variable called `.sas_session`
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