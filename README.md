# Revenue Intelligence Database 📊

> **PostgreSQL portfolio project** demonstrating normalized relational schema design, realistic B2B SaaS seed data, and production-grade SQL queries for key revenue metrics.

**Recruiter takeaway:** *"This person understands data modeling and business metrics."*

---

## Project Overview

| Attribute | Detail |
|---|---|
| **Database** | PostgreSQL 15+ |
| **Schema Style** | 3NF Normalized, UUID primary keys |
| **Domain** | B2B SaaS Revenue Intelligence |
| **Seed Data** | 12 customers · 8 campaigns · 30 leads · 15 pipeline deals · 7 revenue records |
| **Metrics Covered** | CAC · Pipeline · Conversion · MQL→SQL · ARR · CLV |

---

## Schema Architecture

```
customers ──────────────────────────────────────────────┐
    │                                                    │
    │ 1:N                                                │ 1:N
    ▼                                                    ▼
  leads ──────────────── campaigns               revenue
    │                                                ▲
    │ 1:1                                            │ 1:1
    ▼                                                │
  pipeline ───────────────────────────────────────────
```

### Tables

| Table | Purpose | Key Columns |
|---|---|---|
| `customers` | Account master — B2B companies | `customer_id`, `industry`, `employee_size`, `region` |
| `campaigns` | Marketing campaigns with budget & type | `campaign_id`, `campaign_type`, `budget`, `start_date` |
| `leads` | Lead lifecycle from new → closed | `lead_id`, `status` (enum), `mql_date`, `sql_date` |
| `pipeline` | Sales opportunities with stage & value | `opportunity_id`, `stage` (enum), `amount`, `probability` |
| `revenue` | Active contracts and ARR tracking | `revenue_id`, `contract_value`, `billing_period`, `is_recurring` |

### ENUMs

```sql
lead_status:   new | mql | sql | opportunity | closed_won | closed_lost
campaign_type: email | paid_search | social | content | event | referral | direct
deal_stage:    prospecting | qualification | proposal | negotiation | closed_won | closed_lost
```

---

## Getting Started

### Prerequisites

- PostgreSQL 15+
- `psql` CLI or any SQL client (TablePlus, DBeaver, pgAdmin)

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/mizcausevic-dev/revenue-intelligence-db.git
cd revenue-intelligence-db

# 2. Create the database
psql -U postgres -c "CREATE DATABASE revenue_intelligence;"

# 3. Run the schema
psql -U postgres -d revenue_intelligence -f sql/schema.sql

# 4. Load seed data
psql -U postgres -d revenue_intelligence -f sql/seed.sql

# 5. Run queries
psql -U postgres -d revenue_intelligence -f sql/queries.sql
```

---

## Business Metric Queries

### 1. Customer Acquisition Cost (CAC)

```sql
-- CAC = Campaign Spend / Customers Acquired per campaign
SELECT campaign_name, budget AS campaign_spend,
       COUNT(DISTINCT r.customer_id) AS customers_acquired,
       ROUND(budget / NULLIF(COUNT(DISTINCT r.customer_id), 0), 2) AS cac
FROM campaigns c
LEFT JOIN leads l ON l.campaign_id = c.campaign_id
LEFT JOIN pipeline p ON p.lead_id = l.lead_id AND p.stage = 'closed_won'
LEFT JOIN revenue r ON r.opportunity_id = p.opportunity_id
GROUP BY c.campaign_id, campaign_name, budget
ORDER BY cac ASC;
```

### 2. Pipeline by Stage

```sql
SELECT stage, COUNT(*) AS deals,
       SUM(amount) AS total_value,
       ROUND(SUM(amount * probability / 100.0), 2) AS weighted_value
FROM pipeline
WHERE stage NOT IN ('closed_won','closed_lost')
GROUP BY stage;
```

### 3. Full Funnel Conversion Rates

```sql
-- Lead → MQL → SQL → Opportunity → Won (with % at each step)
WITH funnel AS ( ... )
SELECT lead_to_mql_pct, mql_to_sql_pct, sql_to_opp_pct,
       opp_to_win_pct, overall_conversion_pct
FROM funnel;
```

### 4. MQL-to-SQL Rate by Campaign

```sql
SELECT c.campaign_name, COUNT(l.lead_id) AS total_mqls,
       COUNT(...) AS converted_to_sql,
       ROUND(100.0 * ... / NULLIF(COUNT(l.lead_id), 0), 2) AS mql_to_sql_rate_pct
FROM leads l
LEFT JOIN campaigns c ON c.campaign_id = l.campaign_id
WHERE l.mql_date IS NOT NULL
GROUP BY c.campaign_id, c.campaign_name;
```

### 5. Annual Recurring Revenue (ARR)

```sql
SELECT DATE_TRUNC('month', start_date) AS cohort_month,
       COUNT(DISTINCT customer_id) AS paying_customers,
       SUM(CASE WHEN billing_period = 'monthly' THEN contract_value * 12
                ELSE contract_value END) AS arr
FROM revenue
WHERE is_recurring = TRUE AND contract_type = 'subscription'
  AND (end_date IS NULL OR end_date >= NOW())
GROUP BY cohort_month;
```

> See [`sql/queries.sql`](sql/queries.sql) for complete implementations of all 8 queries including CLV and revenue-by-industry.

---

## ERD Diagram

```
┌──────────────────┐       ┌──────────────────────┐
│   customers      │       │    campaigns         │
│──────────────────│       │──────────────────────│
│ customer_id (PK) │       │ campaign_id (PK)     │
│ company_name     │       │ campaign_name        │
│ industry         │       │ campaign_type (enum) │
│ employee_size    │       │ channel              │
│ region           │       │ budget               │
│ created_at       │       │ start_date / end_date│
└────────┬─────────┘       └──────────┬───────────┘
         │ 1:N                         │ 1:N
         ▼                             ▼
┌──────────────────────────────────────────────────┐
│                   leads                          │
│──────────────────────────────────────────────────│
│ lead_id (PK)                                     │
│ customer_id (FK → customers)                     │
│ campaign_id (FK → campaigns)                     │
│ first_name, last_name, email, job_title          │
│ status (enum: new→mql→sql→opportunity→won/lost)  │
│ mql_date, sql_date                               │
└───────────────────────┬──────────────────────────┘
                        │ 1:1
                        ▼
┌──────────────────────────────────────────────────┐
│                  pipeline                        │
│──────────────────────────────────────────────────│
│ opportunity_id (PK)                              │
│ lead_id (FK → leads)                             │
│ customer_id (FK → customers)                     │
│ opportunity_name                                 │
│ stage (enum: prospecting → closed_won)           │
│ amount, probability (0-100), expected_close      │
└───────────────────────┬──────────────────────────┘
                        │ 1:N
                        ▼
┌──────────────────────────────────────────────────┐
│                  revenue                         │
│──────────────────────────────────────────────────│
│ revenue_id (PK)                                  │
│ customer_id (FK → customers)                     │
│ opportunity_id (FK → pipeline)                   │
│ contract_value, contract_type, billing_period    │
│ start_date, end_date, is_recurring               │
└──────────────────────────────────────────────────┘
```

---

## Key Design Decisions

| Decision | Rationale |
|---|---|
| **UUID PKs** | Globally unique, safe for distributed systems and API exposure |
| **ENUM types** | Enforce valid lead/deal states at the database level |
| **NULLIF guards in metrics** | Prevents division-by-zero in CAC and conversion rate queries |
| **Trigger for `updated_at`** | Automatic timestamp maintenance without application-layer code |
| **`billing_period` normalization** | Monthly vs. annual contracts normalized to ARR in queries (×12 for monthly) |
| **Probability on pipeline** | Enables weighted pipeline value — a standard sales forecasting technique |
| **Denormalized `customer_id` on pipeline** | Allows direct customer queries on pipeline without requiring a lead to exist |

---

## Metrics Reference

| Metric | Formula | Query |
|---|---|---|
| **CAC** | Campaign Spend ÷ New Customers | `queries.sql` Line 12 |
| **MQL→SQL Rate** | (SQLs ÷ MQLs) × 100 | `queries.sql` Line 74 |
| **Overall Conversion** | (Won ÷ Total Leads) × 100 | `queries.sql` Line 44 |
| **ARR** | Σ(annual_contract_value) for active recurring | `queries.sql` Line 98 |
| **Weighted Pipeline** | Σ(amount × probability%) | `queries.sql` Line 33 |
| **CLV** | Avg ARR ÷ Churn Rate | `queries.sql` Line 122 |

---

## Tech Stack

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-336791?logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Standard-4479A1)
![License](https://img.shields.io/badge/License-MIT-green)

---

*Part of [mizcausevic-dev's GitHub portfolio](https://github.com/mizcausevic-dev) — demonstrating enterprise data modeling and B2B revenue analytics.*

---

**Connect:** [LinkedIn](https://www.linkedin.com/in/mirzacausevic/) · [Kinetic Gain](https://kineticgain.com) · [Medium](https://medium.com/@mizcausevic/) · [Skills](https://mizcausevic.com/skills/)
