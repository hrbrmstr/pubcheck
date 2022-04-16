
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/hrbrmstr)
![Signed commit
%](https://img.shields.io/badge/Signed_Commits-100%25-lightgrey.svg)
[![R-CMD-check](https://github.com/hrbrmstr/pubcheck/workflows/R-CMD-check/badge.svg)](https://github.com/hrbrmstr/pubcheck/actions?query=workflow%3AR-CMD-check)
[![Linux build
Status](https://travis-ci.org/hrbrmstr/pubcheck.svg?branch=master)](https://travis-ci.org/hrbrmstr/pubcheck)
[![Coverage
Status](https://codecov.io/gh/hrbrmstr/pubcheck/branch/master/graph/badge.svg)](https://codecov.io/gh/hrbrmstr/pubcheck)
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-4.1.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

# pubcheck

Check Safety of SSH Public Keys

## Description

SSH is great! Poorly-configured SSH keys are not. Tools are provided to
assess the safety of SSH public keys in multiple contexts.

## What’s Inside The Tin

The following functions are implemented:

-   `check_gh_following`: Check all SSH keys of GitHub users a
    particular account is following
-   `check_gh_user_keys`: Check one or more GitHub user’s keys
-   `check_ssh_pub_key`: Check one SSH public key

## Installation

``` r
remotes::install_github("hrbrmstr/pubcheck")
```

NOTE: To use the ‘remotes’ install options you will need to have the
[{remotes} package](https://github.com/r-lib/remotes) installed.

## Usage

``` r
library(pubcheck)
library(tidyverse)

# current version
packageVersion("pubcheck")
## [1] '0.1.0'
```

### Local file

``` r
check_ssh_pub_key("~/.ssh/id_rsa.pub") |> 
  mutate(key = ifelse(is.na(key), NA_character_, sprintf("%s…", substr(key, 1, 30)))) |> 
  knitr::kable()
```

| key                             | algo |  len | status                                                                |
|:--------------------------------|:-----|-----:|:----------------------------------------------------------------------|
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQ… | rsa  | 2048 | ✅ Key is safe; For the RSA algorithm at least 2048, recommended 4096 |

### A GitHub user

``` r
check_gh_user_keys(c("hrbrmstr", "mikemahoney218")) |> 
  mutate(key = ifelse(is.na(key), NA_character_, sprintf("%s…", substr(key, 1, 30)))) |> 
  knitr::kable()
```

| user           | key                             | algo    |  len | status                                                                |
|:---------------|:--------------------------------|:--------|-----:|:----------------------------------------------------------------------|
| hrbrmstr       | ssh-rsa AAAAB3NzaC1yc2EAAAADAQ… | rsa     | 2048 | ✅ Key is safe; For the RSA algorithm at least 2048, recommended 4096 |
| hrbrmstr       | ssh-rsa AAAAB3NzaC1yc2EAAAADAQ… | rsa     | 2048 | ✅ Key is safe; For the RSA algorithm at least 2048, recommended 4096 |
| hrbrmstr       | ssh-rsa AAAAB3NzaC1yc2EAAAADAQ… | rsa     | 2048 | ✅ Key is safe; For the RSA algorithm at least 2048, recommended 4096 |
| mikemahoney218 | ssh-rsa AAAAB3NzaC1yc2EAAAADAQ… | rsa     | 4096 | ✅ Key is safe                                                        |
| mikemahoney218 | ssh-ed25519 AAAAC3NzaC1lZDI1NT… | ed25519 |  256 | ✅ Key is safe                                                        |
| mikemahoney218 | ssh-ed25519 AAAAC3NzaC1lZDI1NT… | ed25519 |  256 | ✅ Key is safe                                                        |
| mikemahoney218 | ssh-ed25519 AAAAC3NzaC1lZDI1NT… | ed25519 |  256 | ✅ Key is safe                                                        |

### Keys of all the users a GitHub account is following

``` r
check_gh_following("koenrh") |> 
  mutate(key = ifelse(is.na(key), NA_character_, sprintf("%s…", substr(key, 1, 30)))) |> 
  knitr::kable()
```

| user   | key                             | algo |  len | status                                                                |
|:-------|:--------------------------------|:-----|-----:|:----------------------------------------------------------------------|
| framer | NA                              | NA   |   NA | NA                                                                    |
| jurre  | ssh-rsa AAAAB3NzaC1yc2EAAAADAQ… | rsa  | 2048 | ✅ Key is safe; For the RSA algorithm at least 2048, recommended 4096 |

## pubcheck Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
|:-----|---------:|-----:|----:|-----:|------------:|-----:|---------:|-----:|
| R    |        6 | 0.33 |  99 | 0.33 |          29 | 0.24 |       36 | 0.24 |
| YAML |        2 | 0.11 |  35 | 0.12 |          10 | 0.08 |        2 | 0.01 |
| Rmd  |        1 | 0.06 |  18 | 0.06 |          21 | 0.17 |       37 | 0.25 |
| SUM  |        9 | 0.50 | 152 | 0.50 |          60 | 0.50 |       75 | 0.50 |

clock Package Metrics for pubcheck

## Code of Conduct

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.
