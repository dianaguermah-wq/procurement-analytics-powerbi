-- ============================================
-- Mart: Vendor Concentration by Department
-- ============================================
-- Purpose:
-- Aggregates procurement spend by department and fiscal year
-- to measure how concentrated spend is among a department's
-- top vendors.
--
-- Outputs:
-- - Total vendor spend
-- - Spend attributed to top 10 vendors
-- - Share of spend represented by top 10 vendors
-- ============================================

DROP TABLE IF EXISTS mart.po_vendor_concentration_dept_fy_mart;

CREATE TABLE mart.po_vendor_concentration_dept_fy_mart AS

WITH vendor_spend AS (
    SELECT
        dept_canonical,
        fiscal_year,
        vendor_name,
        SUM(vendor_spend) AS vendor_spend
    FROM po_clean
    GROUP BY
        dept_canonical,
        fiscal_year,
        vendor_name
),

ranked_vendors AS (
    SELECT
        dept_canonical,
        fiscal_year,
        vendor_name,
        vendor_spend,
        ROW_NUMBER() OVER (
            PARTITION BY dept_canonical, fiscal_year
            ORDER BY vendor_spend DESC
        ) AS vendor_rank
    FROM vendor_spend
)

SELECT
    dept_canonical,
    fiscal_year,

    SUM(vendor_spend) AS total_vendor_spend,

    SUM(
        CASE
            WHEN vendor_rank <= 10 THEN vendor_spend
            ELSE 0
        END
    ) AS top10_vendor_spend,

    SUM(
        CASE
            WHEN vendor_rank <= 10 THEN vendor_spend
            ELSE 0
        END
    ) / NULLIF(SUM(vendor_spend), 0) AS top10_vendor_share

FROM ranked_vendors
GROUP BY
    dept_canonical,
    fiscal_year;

-- Index for filtering and joins
CREATE INDEX ix_po_vendor_conc_dept_fy_mart
ON mart.po_vendor_concentration_dept_fy_mart (
    dept_canonical,
    fiscal_year
);