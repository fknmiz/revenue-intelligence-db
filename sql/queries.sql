-- ============================================================
-- REVENUE INTELLIGENCE: BUSINESS METRIC QUERIES
-- ============================================================

-- ============================================================
-- 1. CUSTOMER ACQUISITION COST (CAC)
--    CAC = Total Campaign Spend / New Customers Acquired
--    Per campaign, rolling 12 months
-- ============================================================
SELECT
    c.campaign_name,
    c.campaign_type,
    c.budget                                          AS campaign_spend,
    COUNT(DISTINCT r.customer_id)                     AS customers_acquired,
    ROUND(
        c.budget / NULLIF(COUNT(DISTINCT r.customer_id), 0),
    2)                                                AS cac
FROM campaigns c
LEFT JOIN leads l ON l.campaign_id = c.campaign_id
LEFT JOIN pipeline p ON p.lead_id = l.lead_id AND p.stage = 'closed_won'
LEFT JOIN revenue r ON r.opportunity_id = p.opportunity_id
WHERE c.start_date >= NOW() - INTERVAL '12 months'
GROUP BY c.campaign_id, c.campaign_name, c.campaign_type, c.budget
ORDER BY cac ASC NULLS LAST;


-- ============================================================
-- 2. PIPELINE SUMMARY BY STAGE
--    Shows deal count, total value, and weighted pipeline value
-- ============================================================
SELECT
    stage,
    COUNT(*)                                                AS deals,
    SUM(amount)                                             AS total_value,
    ROUND(AVG(probability), 1)                              AS avg_probability_pct,
    ROUND(SUM(amount * probability / 100.0), 2)             AS weighted_pipeline_value
FROM pipeline
WHERE stage NOT IN ('closed_won', 'closed_lost')
GROUP BY stage
ORDER BY
    ARRAY_POSITION(
        ARRAY['prospecting','qualification','proposal','negotiation']::deal_stage[],
        stage
    );


-- ============================================================
-- 3. LEAD CONVERSION RATE
--    Total leads -> MQLs -> SQLs -> Opportunities -> Won
-- ============================================================
WITH funnel AS (
    SELECT
        COUNT(*)                                            AS total_leads,
        COUNT(*) FILTER (WHERE status IN ('mql','sql','opportunity','closed_won','closed_lost'))
                                                            AS total_mqls,
        COUNT(*) FILTER (WHERE status IN ('sql','opportunity','closed_won','closed_lost'))
                                                            AS total_sqls,
        COUNT(*) FILTER (WHERE status IN ('opportunity','closed_won','closed_lost'))
                                                            AS total_opportunities,
        COUNT(*) FILTER (WHERE status = 'closed_won')       AS total_won
    FROM leads
)
SELECT
    total_leads,
    total_mqls,
    total_sqls,
    total_opportunities,
    total_won,
    ROUND(100.0 * total_mqls       / NULLIF(total_leads, 0), 2)        AS lead_to_mql_pct,
    ROUND(100.0 * total_sqls       / NULLIF(total_mqls, 0), 2)         AS mql_to_sql_pct,
    ROUND(100.0 * total_opportunities / NULLIF(total_sqls, 0), 2)      AS sql_to_opp_pct,
    ROUND(100.0 * total_won        / NULLIF(total_opportunities, 0), 2) AS opp_to_win_pct,
    ROUND(100.0 * total_won        / NULLIF(total_leads, 0), 2)        AS overall_conversion_pct
FROM funnel;


-- ============================================================
-- 4. MQL-TO-SQL CONVERSION RATE
--    Broken down by campaign and source
-- ============================================================
SELECT
    COALESCE(c.campaign_name, 'Direct / Organic')           AS campaign,
    c.campaign_type,
    COUNT(l.lead_id)                                        AS total_mqls,
    COUNT(l.lead_id) FILTER (WHERE l.status IN ('sql','opportunity','closed_won','closed_lost'))
                                                            AS converted_to_sql,
    ROUND(
        100.0 *
        COUNT(l.lead_id) FILTER (WHERE l.status IN ('sql','opportunity','closed_won','closed_lost'))
        / NULLIF(COUNT(l.lead_id), 0)
    , 2)                                                    AS mql_to_sql_rate_pct
FROM leads l
LEFT JOIN campaigns c ON c.campaign_id = l.campaign_id
WHERE l.status != 'new'
  AND l.mql_date IS NOT NULL
GROUP BY c.campaign_id, c.campaign_name, c.campaign_type
ORDER BY mql_to_sql_rate_pct DESC NULLS LAST;


-- ============================================================
-- 5. ARR (ANNUAL RECURRING REVENUE)
--    Snapshot of current ARR across active subscriptions
-- ============================================================
SELECT
    DATE_TRUNC('month', r.start_date)                       AS cohort_month,
    COUNT(DISTINCT r.customer_id)                           AS paying_customers,
    SUM(
        CASE
            WHEN r.billing_period = 'monthly' THEN r.contract_value * 12
            ELSE r.contract_value
        END
    )                                                       AS arr,
    ROUND(AVG(
        CASE
            WHEN r.billing_period = 'monthly' THEN r.contract_value * 12
            ELSE r.contract_value
        END
    ), 2)                                                   AS avg_arr_per_customer
FROM revenue r
WHERE r.is_recurring = TRUE
  AND r.contract_type = 'subscription'
  AND (r.end_date IS NULL OR r.end_date >= NOW())
GROUP BY cohort_month
ORDER BY cohort_month;


-- ============================================================
-- 6. CURRENT ARR (SINGLE VALUE)
-- ============================================================
SELECT
    ROUND(SUM(
        CASE
            WHEN billing_period = 'monthly' THEN contract_value * 12
            ELSE contract_value
        END
    ), 2) AS current_arr
FROM revenue
WHERE is_recurring = TRUE
  AND contract_type = 'subscription'
  AND (end_date IS NULL OR end_date >= NOW());


-- ============================================================
-- 7. CUSTOMER LIFETIME VALUE (CLV) — SIMPLIFIED
--    CLV = Avg ARR per Customer / Churn Rate
--    (churn approximated by closed contracts)
-- ============================================================
WITH active AS (
    SELECT COUNT(DISTINCT customer_id) AS active_count,
           AVG(CASE WHEN billing_period = 'monthly' THEN contract_value * 12
                    ELSE contract_value END) AS avg_arr
    FROM revenue
    WHERE is_recurring = TRUE
      AND contract_type = 'subscription'
      AND (end_date IS NULL OR end_date >= NOW())
),
churned AS (
    SELECT COUNT(DISTINCT customer_id) AS churned_count
    FROM revenue
    WHERE is_recurring = TRUE
      AND end_date < NOW()
      AND end_date >= NOW() - INTERVAL '12 months'
)
SELECT
    a.active_count,
    ROUND(a.avg_arr, 2)                                              AS avg_arr,
    c.churned_count,
    ROUND(100.0 * c.churned_count / NULLIF(a.active_count, 0), 2)   AS annual_churn_rate_pct,
    ROUND(a.avg_arr / NULLIF(c.churned_count::NUMERIC / a.active_count, 0), 2) AS estimated_clv
FROM active a, churned c;


-- ============================================================
-- 8. REVENUE BY CUSTOMER + INDUSTRY
-- ============================================================
SELECT
    cu.industry,
    COUNT(DISTINCT cu.customer_id)                          AS customers,
    SUM(CASE WHEN r.billing_period = 'monthly' THEN r.contract_value * 12
             ELSE r.contract_value END)                     AS total_arr,
    ROUND(AVG(CASE WHEN r.billing_period = 'monthly' THEN r.contract_value * 12
              ELSE r.contract_value END), 2)                AS avg_arr_per_customer
FROM customers cu
JOIN revenue r ON r.customer_id = cu.customer_id
WHERE r.is_recurring = TRUE
  AND (r.end_date IS NULL OR r.end_date >= NOW())
GROUP BY cu.industry
ORDER BY total_arr DESC;
