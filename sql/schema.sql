-- ============================================================
-- REVENUE INTELLIGENCE DATABASE
-- PostgreSQL | Normalized Schema | v1.0
-- Author: Miz Causevic | github.com/fknmiz
-- ============================================================

-- ============================================================
-- EXTENSIONS
-- ============================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- ENUMS
-- ============================================================
CREATE TYPE lead_status   AS ENUM ('new', 'mql', 'sql', 'opportunity', 'closed_won', 'closed_lost');
CREATE TYPE campaign_type AS ENUM ('email', 'paid_search', 'social', 'content', 'event', 'referral', 'direct');
CREATE TYPE deal_stage    AS ENUM ('prospecting', 'qualification', 'proposal', 'negotiation', 'closed_won', 'closed_lost');

-- ============================================================
-- 1. CUSTOMERS
-- ============================================================
CREATE TABLE customers (
    customer_id   UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_name  VARCHAR(255) NOT NULL,
    industry      VARCHAR(100),
    employee_size VARCHAR(50),  -- e.g. '1-50', '51-200', '201-1000', '1000+'
    region        VARCHAR(100),
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 2. CAMPAIGNS
-- ============================================================
CREATE TABLE campaigns (
    campaign_id   UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    campaign_name VARCHAR(255)  NOT NULL,
    campaign_type campaign_type NOT NULL,
    channel       VARCHAR(100),
    budget        NUMERIC(12,2) NOT NULL DEFAULT 0,
    start_date    DATE          NOT NULL,
    end_date      DATE,
    is_active     BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 3. LEADS
-- ============================================================
CREATE TABLE leads (
    lead_id         UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id     UUID        REFERENCES customers(customer_id) ON DELETE SET NULL,
    campaign_id     UUID        REFERENCES campaigns(campaign_id) ON DELETE SET NULL,
    first_name      VARCHAR(100),
    last_name       VARCHAR(100),
    email           VARCHAR(255) NOT NULL UNIQUE,
    company         VARCHAR(255),
    job_title       VARCHAR(150),
    lead_source     VARCHAR(100),
    status          lead_status  NOT NULL DEFAULT 'new',
    mql_date        DATE,        -- when lead became MQL
    sql_date        DATE,        -- when lead became SQL
    disqualified_at TIMESTAMPTZ,
    disqualify_reason TEXT,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 4. PIPELINE (OPPORTUNITIES)
-- ============================================================
CREATE TABLE pipeline (
    opportunity_id UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    lead_id        UUID          REFERENCES leads(lead_id) ON DELETE RESTRICT,
    customer_id    UUID          REFERENCES customers(customer_id) ON DELETE RESTRICT,
    opportunity_name VARCHAR(255) NOT NULL,
    stage          deal_stage    NOT NULL DEFAULT 'prospecting',
    amount         NUMERIC(14,2) NOT NULL DEFAULT 0,
    probability    SMALLINT      CHECK (probability BETWEEN 0 AND 100),
    expected_close DATE,
    actual_close   DATE,
    assigned_to    VARCHAR(150),
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 5. REVENUE
-- ============================================================
CREATE TABLE revenue (
    revenue_id     UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id    UUID          NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    opportunity_id UUID          REFERENCES pipeline(opportunity_id) ON DELETE SET NULL,
    contract_value NUMERIC(14,2) NOT NULL,
    contract_type  VARCHAR(50)   DEFAULT 'subscription',  -- subscription | one_time | expansion
    billing_period VARCHAR(20)   DEFAULT 'annual',        -- monthly | annual
    start_date     DATE          NOT NULL,
    end_date       DATE,
    is_recurring   BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX idx_leads_status      ON leads(status);
CREATE INDEX idx_leads_campaign    ON leads(campaign_id);
CREATE INDEX idx_leads_customer    ON leads(customer_id);
CREATE INDEX idx_leads_mql_date    ON leads(mql_date);
CREATE INDEX idx_leads_sql_date    ON leads(sql_date);
CREATE INDEX idx_pipeline_stage    ON pipeline(stage);
CREATE INDEX idx_pipeline_customer ON pipeline(customer_id);
CREATE INDEX idx_revenue_customer  ON revenue(customer_id);
CREATE INDEX idx_revenue_start     ON revenue(start_date);

-- ============================================================
-- UPDATED_AT TRIGGER FUNCTION
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_customers_updated BEFORE UPDATE ON customers FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_leads_updated     BEFORE UPDATE ON leads     FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_pipeline_updated  BEFORE UPDATE ON pipeline  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
