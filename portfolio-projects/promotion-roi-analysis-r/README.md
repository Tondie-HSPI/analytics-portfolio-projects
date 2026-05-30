# Promotion ROI Analysis in R

This project evaluates trade promotion profitability for Hellmann's mayonnaise using demand modeling, lift factors, and ROI calculations.

## Business Question

Which promotion tactics create profitable incremental sales, and how much does retailer forward buying reduce promotion profitability?

## Tools

- R
- R Markdown
- Log-linear demand modeling
- Promotion lift factors
- ROI analysis
- Excel-supported business calculations

## Methods

- Created price and promotion variables from account-level sales data.
- Estimated log-linear demand models separately for Dominick's and Jewel.
- Compared temporary price reduction, display, and feature/display promotion scenarios.
- Calculated account-specific lift factors from statistically significant model coefficients.
- Evaluated promotion ROI with and without forward buying.

## Key Findings

- Price reductions, display support, and feature support affect demand differently.
- Display and feature activity should be evaluated as coordinated promotion tools, not isolated tactics.
- Forward buying can materially weaken promotion profitability.
- Account-specific regressions matter because Dominick's and Jewel have different promotion response and cost structures.
- Promotion recommendations should consider both incremental demand and total event cost.

## Files

- `promotion_roi_analysis.Rmd` - source analysis.
- `assets/part1_promotion_planning_amended.xlsx` - Part I workbook with a dedicated `Q4_Forward_Buy` sheet.
- `assets/part2_hellmans_roi_amended.xlsx` - Part II workbook with account-specific lift factors and ROI calculations.

## Portfolio Note

The source dataset is not included in this public version. The repository preserves the corrected analytical workflow, business interpretation, and amended workbook outputs.
