# Mobile Ad Click Prediction in R

This project analyzes how ad variety and user history affect mobile advertising click behavior. It compares decision tree and XGBoost models, evaluates predictive performance, and translates the model output into a targeting and budget allocation recommendation.

## Business Question

How can a marketer identify the highest-value mobile ad impressions and improve return on ad spend?

## Tools

- R
- R Markdown
- CART / `rpart`
- XGBoost
- AUC and relative information gain
- ROI analysis

## Methods

- Compared within-session behavior, pre-session history, and combined feature sets.
- Built CART and XGBoost models for click prediction.
- Evaluated model performance with AUC and RIG.
- Ranked impressions by predicted click probability.
- Compared buying all impressions against buying only the highest-value impressions.

## Key Findings

- Pre-session history was the strongest standalone signal, especially prior user CTR.
- In-session ad variety had a positive relationship with click behavior.
- The combined XGBoost model performed best.
- Targeting the top predicted impressions produced stronger ROI than buying all available impressions.

## Files

- `mobile_ad_click_prediction.Rmd` - source analysis.
- `assets/*.png` - generated model and exploratory visuals.

## Portfolio Note

The original data files, instructor prompt, and submitted course report are not included. This repository is curated for portfolio review and focuses on the analysis workflow, modeling approach, generated visuals, and business interpretation.
