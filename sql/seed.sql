-- ============================================================
-- SEED DATA — Revenue Intelligence Database
-- Realistic B2B SaaS scenario: 8 campaigns, 30 leads, 15 deals
-- ============================================================

-- ============================================================
-- CUSTOMERS (12 companies)
-- ============================================================
INSERT INTO customers (customer_id, company_name, industry, employee_size, region) VALUES
  ('11111111-0001-0000-0000-000000000001', 'Nexus Analytics',     'Technology',       '51-200',  'Northeast'),
  ('11111111-0002-0000-0000-000000000001', 'Bridgewater Health',  'Healthcare',        '201-1000','Southeast'),
  ('11111111-0003-0000-0000-000000000001', 'Ironclad Legal',      'Legal',             '1-50',    'Midwest'),
  ('11111111-0004-0000-0000-000000000001', 'Apex Manufacturing',  'Manufacturing',     '1000+',   'Southwest'),
  ('11111111-0005-0000-0000-000000000001', 'Vanta Retail',        'Retail',            '51-200',  'West'),
  ('11111111-0006-0000-0000-000000000001', 'Clearwater Finance',  'Financial Services','201-1000','Northeast'),
  ('11111111-0007-0000-0000-000000000001', 'Orbit EdTech',        'Education',         '1-50',    'West'),
  ('11111111-0008-0000-0000-000000000001', 'Pinnacle Logistics',  'Logistics',         '51-200',  'Southeast'),
  ('11111111-0009-0000-0000-000000000001', 'TerraFarm AI',        'AgTech',            '1-50',    'Midwest'),
  ('11111111-0010-0000-0000-000000000001', 'Strata Security',     'Cybersecurity',     '51-200',  'Northeast'),
  ('11111111-0011-0000-0000-000000000001', 'Luminary Media',      'Media & Marketing', '201-1000','West'),
  ('11111111-0012-0000-0000-000000000001', 'Foundry Industrial',  'Manufacturing',     '1000+',   'Midwest');

-- ============================================================
-- CAMPAIGNS (8 campaigns across types)
-- ============================================================
INSERT INTO campaigns (campaign_id, campaign_name, campaign_type, channel, budget, start_date, end_date) VALUES
  ('22222222-0001-0000-0000-000000000002', 'Q1 Google Ads Push',          'paid_search', 'Google Ads',    18000.00, '2025-01-01', '2025-03-31'),
  ('22222222-0002-0000-0000-000000000002', 'H1 Content Marketing',        'content',     'Blog + SEO',     6000.00, '2025-01-01', '2025-06-30'),
  ('22222222-0003-0000-0000-000000000002', 'Spring LinkedIn Campaign',    'social',      'LinkedIn',      12000.00, '2025-03-01', '2025-05-31'),
  ('22222222-0004-0000-0000-000000000002', 'SaaStr 2025 Sponsorship',     'event',       'Conference',    22000.00, '2025-04-15', '2025-04-17'),
  ('22222222-0005-0000-0000-000000000002', 'Q2 Nurture Email Sequence',   'email',       'HubSpot',        3500.00, '2025-04-01', '2025-06-30'),
  ('22222222-0006-0000-0000-000000000002', 'Q3 Partner Referral Program', 'referral',    'Partner Network', 5000.00, '2025-07-01', NULL),
  ('22222222-0007-0000-0000-000000000002', 'Q3 Paid Social Retargeting',  'social',      'LinkedIn + Meta',9000.00, '2025-07-01', '2025-09-30'),
  ('22222222-0008-0000-0000-000000000002', 'H2 SEO & Content Push',       'content',     'Blog + SEO',     7500.00, '2025-07-01', NULL);

-- ============================================================
-- LEADS (30 leads)
-- ============================================================
INSERT INTO leads (lead_id, customer_id, campaign_id, first_name, last_name, email, company, job_title, lead_source, status, mql_date, sql_date) VALUES
  ('33333333-0001-0000-0000-000000000003', '11111111-0001-0000-0000-000000000001', '22222222-0001-0000-0000-000000000002', 'Alex',    'Mercer',    'alex.mercer@nexusanalytics.io',    'Nexus Analytics',    'VP Engineering',    'paid_search', 'closed_won',  '2025-01-20', '2025-02-05'),
  ('33333333-0002-0000-0000-000000000003', '11111111-0002-0000-0000-000000000001', '22222222-0001-0000-0000-000000000002', 'Jordan',  'Ellis',     'jordan.ellis@bridgewaterhealth.com','Bridgewater Health', 'Director IT',       'paid_search', 'sql',          '2025-02-01', '2025-02-20'),
  ('33333333-0003-0000-0000-000000000003', '11111111-0003-0000-0000-000000000001', '22222222-0002-0000-0000-000000000002', 'Sam',     'Nguyen',    'sam.nguyen@ironcladlegal.com',     'Ironclad Legal',     'COO',               'organic_search','closed_won',  '2025-01-28', '2025-02-14'),
  ('33333333-0004-0000-0000-000000000003', '11111111-0004-0000-0000-000000000001', '22222222-0003-0000-0000-000000000002', 'Morgan',  'Clarke',    'morgan.clarke@apexmfg.com',        'Apex Manufacturing', 'Head of IT',        'social',       'opportunity',  '2025-03-10', '2025-03-28'),
  ('33333333-0005-0000-0000-000000000003', '11111111-0005-0000-0000-000000000001', '22222222-0003-0000-0000-000000000002', 'Taylor',  'Reeves',    'treeves@vantaretail.com',          'Vanta Retail',       'CTO',               'social',       'opportunity',  '2025-03-15', '2025-04-01'),
  ('33333333-0006-0000-0000-000000000003', '11111111-0006-0000-0000-000000000001', '22222222-0004-0000-0000-000000000002', 'Chris',   'Vance',     'cvance@clearwaterfinance.com',     'Clearwater Finance', 'SVP Technology',    'event',        'closed_won',   '2025-04-16', '2025-04-22'),
  ('33333333-0007-0000-0000-000000000003', '11111111-0007-0000-0000-000000000001', '22222222-0004-0000-0000-000000000002', 'Riley',   'Hoffman',   'riley.hoffman@orbit.edu',          'Orbit EdTech',       'Product Manager',   'event',        'closed_won',   '2025-04-16', '2025-05-01'),
  ('33333333-0008-0000-0000-000000000003', '11111111-0008-0000-0000-000000000001', '22222222-0005-0000-0000-000000000002', 'Blake',   'Kim',       'bkim@pinnacle-log.com',            'Pinnacle Logistics', 'Operations Dir.',   'email',        'sql',          '2025-04-20', '2025-05-10'),
  ('33333333-0009-0000-0000-000000000003', '11111111-0009-0000-0000-000000000001', '22222222-0005-0000-0000-000000000002', 'Quinn',   'Patel',     'q.patel@terrafarm.ai',             'TerraFarm AI',       'CEO',               'email',        'mql',          '2025-05-05', NULL),
  ('33333333-0010-0000-0000-000000000003', '11111111-0010-0000-0000-000000000001', '22222222-0003-0000-0000-000000000002', 'Avery',   'Stone',     'avery.stone@stratasec.io',         'Strata Security',    'CISO',              'social',       'closed_won',   '2025-04-05', '2025-04-18'),
  ('33333333-0011-0000-0000-000000000003', '11111111-0011-0000-0000-000000000001', '22222222-0002-0000-0000-000000000002', 'Drew',    'Lavoie',    'drew@luminarymedia.co',            'Luminary Media',     'VP Marketing',      'organic_search','closed_won',   '2025-02-12', '2025-03-01'),
  ('33333333-0012-0000-0000-000000000003', '11111111-0012-0000-0000-000000000001', '22222222-0004-0000-0000-000000000002', 'Casey',   'Walsh',     'cwalsh@foundryind.com',            'Foundry Industrial', 'Director Digital',  'event',        'opportunity',  '2025-04-17', '2025-05-03'),
  ('33333333-0013-0000-0000-000000000003', NULL, '22222222-0001-0000-0000-000000000002', 'Jamie',  'Brooks',    'jbrooks@techventure.io',           'Tech Venture',       'Founder',           'paid_search', 'closed_lost',  '2025-01-25', '2025-02-10'),
  ('33333333-0014-0000-0000-000000000003', NULL, '22222222-0006-0000-0000-000000000002', 'Phoenix','Crane',     'pcrane@saasgrowth.com',            'SaaS Growth Co',     'Head of Ops',       'referral',    'sql',          '2025-08-01', '2025-08-15'),
  ('33333333-0015-0000-0000-000000000003', NULL, '22222222-0006-0000-0000-000000000002', 'Reese',  'Dumont',    'reese.dumont@cloudbridge.io',      'CloudBridge',        'CTO',               'referral',    'opportunity',  '2025-07-20', '2025-08-05'),
  ('33333333-0016-0000-0000-000000000003', NULL, '22222222-0007-0000-0000-000000000002', 'Sage',   'Park',      'sage.park@fintechrise.com',        'FinTech Rise',       'VP Product',        'social',      'mql',          '2025-07-15', NULL),
  ('33333333-0017-0000-0000-000000000003', NULL, '22222222-0007-0000-0000-000000000002', 'River',  'Okafor',    'r.okafor@hrsuite.co',              'HR Suite',           'CEO',               'social',      'sql',          '2025-08-10', '2025-08-25'),
  ('33333333-0018-0000-0000-000000000003', NULL, '22222222-0008-0000-0000-000000000002', 'Skyler', 'Abrams',    'skyler@datamesh.io',               'DataMesh',           'Data Architect',    'organic_search','mql',         '2025-08-01', NULL),
  ('33333333-0019-0000-0000-000000000003', NULL, '22222222-0002-0000-0000-000000000002', 'Finley', 'Roth',      'finley.roth@mediapulse.com',       'MediaPulse',         'Dir. Technology',   'organic_search','new',         NULL,          NULL),
  ('33333333-0020-0000-0000-000000000003', NULL, '22222222-0001-0000-0000-000000000002', 'Peyton', 'Nakamura',  'p.nakamura@venture42.com',         'Venture 42',         'COO',               'paid_search', 'new',          NULL,          NULL),
  ('33333333-0021-0000-0000-000000000003', NULL, '22222222-0003-0000-0000-000000000002', 'Harlow', 'Ingram',    'h.ingram@b2bops.io',               'B2B Ops',            'Operations Lead',   'social',      'mql',          '2025-05-20', NULL),
  ('33333333-0022-0000-0000-000000000003', NULL, '22222222-0005-0000-0000-000000000002', 'Emery',  'Walsh',     'emery.walsh@growthloop.io',        'Growth Loop',        'Head of Marketing', 'email',       'closed_lost',  '2025-05-01', '2025-05-18'),
  ('33333333-0023-0000-0000-000000000003', NULL, '22222222-0004-0000-0000-000000000002', 'Roan',   'Samuels',   'roan.s@platformx.co',              'Platform X',         'VP Engineering',    'event',       'sql',          '2025-04-17', '2025-05-05'),
  ('33333333-0024-0000-0000-000000000003', NULL, '22222222-0006-0000-0000-000000000002', 'Luca',   'Ferrara',   'luca.f@italianfintech.io',         'Italian FinTech',    'COO',               'referral',    'mql',          '2025-09-01', NULL),
  ('33333333-0025-0000-0000-000000000003', NULL, '22222222-0007-0000-0000-000000000002', 'Nia',    'Thompson',  'nia.t@blockchainlogic.io',         'Blockchain Logic',   'CTO',               'social',      'new',          NULL,          NULL),
  ('33333333-0026-0000-0000-000000000003', NULL, '22222222-0008-0000-0000-000000000002', 'Hugo',   'Lefort',    'h.lefort@analyticspro.fr',         'Analytics Pro',      'Chief Data Officer','organic_search','mql',         '2025-09-10', NULL),
  ('33333333-0027-0000-0000-000000000003', NULL, '22222222-0005-0000-0000-000000000002', 'Avani',  'Singh',     'a.singh@cloudfirst.in',            'CloudFirst',         'Head of DevOps',    'email',       'new',          NULL,          NULL),
  ('33333333-0028-0000-0000-000000000003', NULL, '22222222-0001-0000-0000-000000000002', 'Cole',   'Barton',    'c.barton@scaleops.io',             'ScaleOps',           'VP Engineering',    'paid_search', 'sql',          '2025-03-10', '2025-03-25'),
  ('33333333-0029-0000-0000-000000000003', NULL, '22222222-0003-0000-0000-000000000002', 'Jade',   'Moreau',    'j.moreau@paristech.fr',            'Paris Tech',         'CTO',               'social',      'mql',          '2025-05-30', NULL),
  ('33333333-0030-0000-0000-000000000003', NULL, '22222222-0002-0000-0000-000000000002', 'Eli',    'Katz',      'eli.katz@medlytix.com',            'Medlytix',           'Dir. Analytics',    'organic_search','opportunity', '2025-02-20', '2025-03-08');

-- ============================================================
-- PIPELINE (15 opportunities)
-- ============================================================
INSERT INTO pipeline (opportunity_id, lead_id, customer_id, opportunity_name, stage, amount, probability, expected_close, actual_close, assigned_to) VALUES
  ('44444444-0001-0000-0000-000000000004', '33333333-0001-0000-0000-000000000003', '11111111-0001-0000-0000-000000000001', 'Nexus Analytics — Platform License',    'closed_won',    42000.00,  100, '2025-03-15', '2025-03-12', 'Sarah Kim'),
  ('44444444-0002-0000-0000-000000000004', '33333333-0003-0000-0000-000000000003', '11111111-0003-0000-0000-000000000001', 'Ironclad Legal — Starter Plan',         'closed_won',    14400.00,  100, '2025-03-28', '2025-03-25', 'Tom Reyes'),
  ('44444444-0003-0000-0000-000000000004', '33333333-0006-0000-0000-000000000003', '11111111-0006-0000-0000-000000000001', 'Clearwater Finance — Enterprise Deal',  'closed_won',    96000.00,  100, '2025-06-30', '2025-06-28', 'Sarah Kim'),
  ('44444444-0004-0000-0000-000000000004', '33333333-0007-0000-0000-000000000003', '11111111-0007-0000-0000-000000000001', 'Orbit EdTech — Growth Plan',            'closed_won',    18000.00,  100, '2025-06-15', '2025-06-10', 'Tom Reyes'),
  ('44444444-0005-0000-0000-000000000004', '33333333-0010-0000-0000-000000000003', '11111111-0010-0000-0000-000000000001', 'Strata Security — Pro License',         'closed_won',    36000.00,  100, '2025-06-01', '2025-05-30', 'Sarah Kim'),
  ('44444444-0006-0000-0000-000000000004', '33333333-0011-0000-0000-000000000003', '11111111-0011-0000-0000-000000000001', 'Luminary Media — Business Plan',        'closed_won',    28800.00,  100, '2025-04-30', '2025-04-28', 'Tom Reyes'),
  ('44444444-0007-0000-0000-000000000004', '33333333-0004-0000-0000-000000000003', '11111111-0004-0000-0000-000000000001', 'Apex Manufacturing — Enterprise Pilot', 'negotiation',  120000.00,   80, '2025-12-01', NULL, 'Sarah Kim'),
  ('44444444-0008-0000-0000-000000000004', '33333333-0005-0000-0000-000000000003', '11111111-0005-0000-0000-000000000001', 'Vanta Retail — Mid-Market Plan',        'proposal',      32000.00,   60, '2025-11-15', NULL, 'Tom Reyes'),
  ('44444444-0009-0000-0000-000000000004', '33333333-0012-0000-0000-000000000003', '11111111-0012-0000-0000-000000000001', 'Foundry Industrial — Enterprise Suite', 'qualification', 88000.00,   40, '2026-01-31', NULL, 'Sarah Kim'),
  ('44444444-0010-0000-0000-000000000004', '33333333-0015-0000-0000-000000000003', NULL, 'CloudBridge — Scale-Up Plan',           'proposal',      24000.00,   55, '2025-11-01', NULL, 'Tom Reyes'),
  ('44444444-0011-0000-0000-000000000004', '33333333-0023-0000-0000-000000000003', NULL, 'Platform X — Professional Plan',        'qualification', 19200.00,   35, '2025-12-15', NULL, 'Tom Reyes'),
  ('44444444-0012-0000-0000-000000000004', '33333333-0030-0000-0000-000000000003', NULL, 'Medlytix — Analytics Suite',            'proposal',      16800.00,   60, '2025-10-31', NULL, 'Sarah Kim'),
  ('44444444-0013-0000-0000-000000000004', '33333333-0028-0000-0000-000000000003', NULL, 'ScaleOps — Starter',                    'prospecting',    9600.00,   25, '2026-02-28', NULL, 'Tom Reyes'),
  ('44444444-0014-0000-0000-000000000004', '33333333-0002-0000-0000-000000000003', '11111111-0002-0000-0000-000000000001', 'Bridgewater Health — Growth Plan',      'negotiation',   48000.00,   75, '2025-12-31', NULL, 'Sarah Kim'),
  ('44444444-0015-0000-0000-000000000004', '33333333-0017-0000-0000-000000000003', NULL, 'HR Suite — Team License',               'qualification', 14400.00,   40, '2026-01-15', NULL, 'Tom Reyes');

-- ============================================================
-- REVENUE (active subscriptions for 7 closed-won customers)
-- ============================================================
INSERT INTO revenue (customer_id, opportunity_id, contract_value, contract_type, billing_period, start_date, end_date, is_recurring) VALUES
  ('11111111-0001-0000-0000-000000000001', '44444444-0001-0000-0000-000000000004', 42000.00, 'subscription', 'annual',  '2025-04-01', '2026-03-31', TRUE),
  ('11111111-0003-0000-0000-000000000001', '44444444-0002-0000-0000-000000000004', 14400.00, 'subscription', 'annual',  '2025-04-01', '2026-03-31', TRUE),
  ('11111111-0006-0000-0000-000000000001', '44444444-0003-0000-0000-000000000004', 96000.00, 'subscription', 'annual',  '2025-07-01', '2026-06-30', TRUE),
  ('11111111-0007-0000-0000-000000000001', '44444444-0004-0000-0000-000000000004', 18000.00, 'subscription', 'annual',  '2025-07-01', '2026-06-30', TRUE),
  ('11111111-0010-0000-0000-000000000001', '44444444-0005-0000-0000-000000000004', 36000.00, 'subscription', 'annual',  '2025-06-15', '2026-06-14', TRUE),
  ('11111111-0011-0000-0000-000000000001', '44444444-0006-0000-0000-000000000004', 28800.00, 'subscription', 'annual',  '2025-05-01', '2026-04-30', TRUE),
  ('11111111-0001-0000-0000-000000000001', NULL,                                   1200.00,  'expansion',    'monthly', '2025-08-01', NULL,          TRUE);
