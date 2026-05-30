# Multi-Product Demand and Profitability Analysis in R

This project evaluates how coordinated price changes affect demand and profitability across a three-product category.

## Business Question

When products compete with one another, how should a manager evaluate whether a price change increases profit after accounting for own-price elasticity, cross-price elasticity, margin, and marginal cost?

## Tools

- R
- R Markdown
- Price elasticity analysis
- Profit ratio modeling
- Break-even marginal cost analysis

## Methods

- Built an elasticity matrix for three competing products.
- Calculated quantity ratios from simultaneous price changes.
- Created reusable R functions for quantity and profit changes.
- Used exact quantity ratios from the demand model when calculating profit impact.
- Solved for the marginal cost threshold at which product 3's price cut would break even.

## Key Findings

- Product 1 loses demand because its own price increases while product 3 becomes cheaper.
- Product 2 also loses demand because the demand pulled toward cheaper product 3 outweighs the benefit from product 1 becoming more expensive.
- Product 3 gains volume from the price cut, but the price cut is not profitable at the current marginal cost.
- Using exact quantity ratios matters because rounded or manually typed values can change profit and break-even calculations.

## Files

- `multiproduct_profitability_analysis.Rmd` - corrected portfolio analysis.
- `assets/multiproduct_profitability_analysis_original_report.pdf` - original submitted report before the Q4a/Q5 correction.

## Portfolio Note

This project uses a provided demand system rather than a private dataset, so no source data file is required.
