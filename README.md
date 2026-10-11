# Household Risk-Asset Allocation & Minor Children: Evidence from CFPS 2022

Empirical research project using the China Family Panel Studies (CFPS) 2022 microdata (group contribution: descriptive statistics, data diagnostics, heterogeneity results and output verification).

## Project Overview
Examined how the number of minor children affects household risk-asset holding decisions, using OLS, Probit and Tobit models with heteroskedasticity-robust standard errors.

## Tech Stack
- Stata (do-file: data cleaning, variable construction, regressions)
- Descriptive statistics, VIF multicollinearity checks, skewness & kurtosis diagnostics

## Key Results
- 9,897 valid household observations from CFPS 2022; baseline risk-asset participation rate of 10.6% and mean minor-child count of 1.224
- Documented log-income transformation after identifying severe right skew and heavy tails in raw income
- Income-stratified heterogeneity: each additional child reduces risk-asset participation by ~3.1 pp for high-income households vs ~0.97 pp for low-income households
- Baseline regressions show a highly significant negative effect of minor-child count on risk-asset participation (≈2.06%–2.25% per additional child)

## Files
- `analysis.do`: full commented Stata do-file
- `report.pdf`: full project write-up

## Dataset
CFPS 2022. Raw survey data is **not included** in this repository due to data licensing; access via the official CFPS portal.
