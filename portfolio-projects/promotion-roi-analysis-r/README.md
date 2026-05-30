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
- Estimated log-linear demand models.
- Compared temporary price reduction, display, and feature/display promotion scenarios.
- Calculated lift factors from model coefficients.
- Evaluated promotion ROI with and without forward buying.

## Key Findings

- Price reductions, display support, and feature support affect demand differently.
- Display and feature activity should be evaluated as coordinated promotion tools, not isolated tactics.
- Forward buying can materially weaken promotion profitability.
- Promotion recommendations should consider both incremental demand and total event cost.

## Files

- `promotion_roi_analysis.Rmd` - source analysis.
- `assets/promotion_roi_analysis_report.docx` - knitted report.

## Portfolio Note

The source dataset and course workbook are not included in this public version. The repository preserves the analytical workflow and business interpretation.
