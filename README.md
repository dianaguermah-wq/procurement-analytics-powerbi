# Procurement Timing & Vendor Dependence Analysis
## Repository Structure

- `README.md` — project overview and dashboard preview
- `assets/` — dashboard screenshots
- `sql/` — SQL scripts for marts and supporting logic
- `powerbi/` — Power BI file and supporting exports

## Methodology

- Built SQL mart tables in PostgreSQL as the analytical source of truth
- Modeled a star schema in Power BI
- Created weighted measures in DAX to avoid misleading averages
- Analyzed procurement across timing, category, and vendor dimensions

## Why It Matters

This analysis helps surface:
- year-end spending concentration
- category-specific purchasing patterns
- supplier dependency risk

These insights can support better planning, contract strategy, and operational predictability.


This project analyzes procurement behavior across three dimensions: 
- Timing (when spend occurs)
- Category (what is being purchased)
- Vendor (who supplies it)
The goal is to identify patterns such as late-year spending concentration, category-driven timing, and supplier dependence.

Business Question

How can procurement data be analyzed beyond total spend to identify timing concentration, category-driven patterns, and supplier dependence?

Key Insights

- ~23% of spend occurs in the final 90 days
- Certain departments show high late-year concentration
- Specific categories drive year-end purchasing
- Vendor spend is highly concentrated

Tools
PostgreSQL | Power BI | SQL | DAX

## Dashboard Preview

### Late-Year Procurement Timing
![Timing Dashboard](assets/page1_timing.png)

### Category Timing Sensitivity
![Category Dashboard](assets/page2_category.png)

### Vendor Concentration
![Vendor Dashboard](assets/page3_vendor.png)

Data Modeling

- SQL-based mart tables used as single source of truth
- Star schema implemented in Power BI
- Weighted measures used to avoid aggregation bias

## SQL Logic

Core transformations and aggregations were implemented in PostgreSQL using SQL mart tables:

- `mart_po_timing.sql` — department-level timing metrics for final 30 / 60 / 90 day spend
- `mart_category_timing.sql` — category and subcategory timing sensitivity
- `mart_vendor_concentration.sql` — department-level top 10 vendor concentration

These marts serve as the analytical source of truth for the Power BI model.

## Star Schema

Dimensions and Facts tables used to create relationships between the vast amount of data
![Power BI Model](powerbi/powerbi_starschema.png)

