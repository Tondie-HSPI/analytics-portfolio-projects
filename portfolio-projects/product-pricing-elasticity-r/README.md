# Product Pricing and Elasticity Analysis in R

This project analyzes product-line pricing for Tide and competitive pressure from Wisk using scanner-style retail data and elasticity modeling.

## Business Question

How should a brand evaluate cannibalization, competitive threat, and pricing changes across related products?

## Tools

- R
- R Markdown
- Linear regression
- Log-linear demand models
- Own-price and cross-price elasticity
- Store fixed effects
- Profit simulation

## Methods

- Calculated market shares and price gaps.
- Estimated demand models for Tide 64 oz and Tide 128 oz.
- Compared models with time trends, promotion filtering, and store fixed effects.
- Interpreted own-price and cross-price elasticities.
- Simulated profit impact from alternative price changes.

## Key Findings

- Product-line pricing should account for cannibalization between Tide pack sizes.
- Cross-price elasticities help evaluate whether Wisk is a competitive threat.
- Filtering promoted weeks and adding fixed effects improves elasticity interpretation.
- Pricing recommendations should be tied to expected profit, not volume alone.

## Files

- `product_pricing_elasticity.Rmd` - public portfolio summary and representative workflow.

## Portfolio Note

The source dataset, instructor prompt, and submitted course report are not included in this public version. The portfolio README and R Markdown file highlight the finished analysis approach, model interpretation, and business recommendation work.
