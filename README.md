# Procurement Timing & Vendor Dependence Analysis

This project analyzes procurement behavior across three dimensions: 
- Timing (when spend occurs)
- Category (what is being purchased)
- Vendor (who supplies it)
The goal is to identify patterns such as late-year spending concentration, category-driven timing, and supplier dependence.

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
