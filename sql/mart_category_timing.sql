-- ============================================
-- Mart: Category Procurement Timing
-- ============================================
-- Purpose:
-- Aggregates procurement spend by department, fiscal year,
-- category, and subcategory to identify which categories
-- drive late-year purchasing behavior.
--
-- Outputs:
-- - Total spend by category/subcategory
-- - Spend in last 30 / 60 / 90 days
-- - Percentage of spend in each late-year window
-- ============================================

DROP TABLE IF EXISTS mart.po_category_timing_dept_fy_mart;

CREATE TABLE mart.po_category_timing_dept_fy_mart AS

WITH base AS (
    SELECT
        dept_canonical,
        fiscal_year,
        category,
        subcategory,
        input_date,
        po_spend_total
    FROM po_clean
),

date_bounds AS (
    SELECT
        dept_canonical,
        fiscal_year,
        MAX(input_date) AS last_po_date
    FROM base
    GROUP BY dept_canonical, fiscal_year
),

joined AS (
    SELECT
        b.dept_canonical,
        b.fiscal_year,
        b.category,
        b.subcategory,
        b.input_date,
        b.po_spend_total,
        d.last_po_date
    FROM base b
    JOIN date_bounds d
        ON b.dept_canonical = d.dept_canonical
       AND b.fiscal_year = d.fiscal_year
)

SELECT
    dept_canonical,
    fiscal_year,
    category,
    subcategory,

    COUNT(*) AS po_rows,

    SUM(po_spend_total) AS spend_total,

    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '30 days'
        THEN po_spend_total ELSE 0 END) AS spend_last_30d,

    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '60 days'
        THEN po_spend_total ELSE 0 END) AS spend_last_60d,

    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '90 days'
        THEN po_spend_total ELSE 0 END) AS spend_last_90d,

    -- Weighted percentages
    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '30 days'
        THEN po_spend_total ELSE 0 END)
        / NULLIF(SUM(po_spend_total), 0) AS pct_last_30d,

    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '60 days'
        THEN po_spend_total ELSE 0 END)
        / NULLIF(SUM(po_spend_total), 0) AS pct_last_60d,

    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '90 days'
        THEN po_spend_total ELSE 0 END)
        / NULLIF(SUM(po_spend_total), 0) AS pct_last_90d

FROM joined
GROUP BY
    dept_canonical,
    fiscal_year,
    category,
    subcategory;

-- Index for filtering and joins
CREATE INDEX ix_po_cat_timing_dept_fy_mart
ON mart.po_category_timing_dept_fy_mart (
    dept_canonical,
    fiscal_year,
    category,
    subcategory
);