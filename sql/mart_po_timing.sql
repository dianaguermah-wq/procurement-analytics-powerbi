-- ============================================
-- Mart: Department Procurement Timing
-- ============================================
-- Purpose:
-- Aggregates procurement spend by department and fiscal year
-- to analyze timing of spending near fiscal year-end.
--
-- Outputs:
-- - Total spend
-- - Spend in last 30 / 60 / 90 days
-- - Percentage of spend in each late-year window
-- ============================================

DROP TABLE IF EXISTS mart.po_timing_dept_fy_mart;

CREATE TABLE mart.po_timing_dept_fy_mart AS

WITH base AS (
    SELECT
        dept_canonical,
        fiscal_year,
        input_date,
        po_spend_total
    FROM po_timing_dept_fy
),

date_bounds AS (
    SELECT
        dept_canonical,
        fiscal_year,
        MIN(input_date) AS first_po_date,
        MAX(input_date) AS last_po_date
    FROM base
    GROUP BY dept_canonical, fiscal_year
),

joined AS (
    SELECT
        b.dept_canonical,
        b.fiscal_year,
        b.input_date,
        b.po_spend_total,
        d.first_po_date,
        d.last_po_date
    FROM base b
    JOIN date_bounds d
        ON b.dept_canonical = d.dept_canonical
       AND b.fiscal_year = d.fiscal_year
)

SELECT
    dept_canonical,
    fiscal_year,

    MIN(first_po_date) AS first_po_date,
    MAX(last_po_date) AS last_po_date,

    COUNT(*) AS po_rows,

    SUM(po_spend_total) AS po_spend_total,

    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '30 days'
        THEN po_spend_total ELSE 0 END) AS po_spend_last_30d,

    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '60 days'
        THEN po_spend_total ELSE 0 END) AS po_spend_last_60d,

    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '90 days'
        THEN po_spend_total ELSE 0 END) AS po_spend_last_90d,

    -- Percentages (weighted)
    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '30 days'
        THEN po_spend_total ELSE 0 END)
        / NULLIF(SUM(po_spend_total), 0) AS pct_spend_last_30d,

    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '60 days'
        THEN po_spend_total ELSE 0 END)
        / NULLIF(SUM(po_spend_total), 0) AS pct_spend_last_60d,

    SUM(CASE WHEN input_date >= last_po_date - INTERVAL '90 days'
        THEN po_spend_total ELSE 0 END)
        / NULLIF(SUM(po_spend_total), 0) AS pct_spend_last_90d

FROM joined
GROUP BY dept_canonical, fiscal_year;

-- Index for performance
CREATE INDEX ix_po_timing_dept_fy_mart
ON mart.po_timing_dept_fy_mart (dept_canonical, fiscal_year);