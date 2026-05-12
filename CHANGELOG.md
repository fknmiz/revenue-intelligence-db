# Changelog

All notable changes to this project are documented here.

## [1.0.0] - 2026-05-12

### Released
- Published **revenue-intelligence-db** as the canonical SQL-first revenue modeling repo in the portfolio.
- Packaged the normalized schema, SaaS seed data, and operator-facing query set into a database story that marketers, RevOps leads, and engineering teams could all read.
- Clarified the product thesis: metric trust depends on data structure, not just dashboard design.

### Why this mattered
- Many organizations talk about CAC, ARR, funnel velocity, and conversion efficiency while quietly disagreeing on the actual joins behind those metrics.
- BI layers often expose the outputs of revenue models without making the underlying logic durable or inspectable.
- This release made the repo useful as a data-modeling artifact, not just a SQL exercise.

## [0.1.0] - 2026-01-31

### Shipped
- Locked the first coherent schema for accounts, campaigns, leads, opportunities, and revenue events.
- Added working query paths for common SaaS metrics so the repo could demonstrate metric explainability end to end.

## [Prototype] - 2025-05-12

### Built
- Built the first revenue model around pipeline shape, lifecycle conversion, and source attribution questions.
- Tested whether the schema could support both finance-style and growth-style reporting without breaking coherence.

## [Design Phase] - 2024-02-01

### Designed
- Treated the repo as a semantic and modeling exercise, not a dashboard backfill.
- Kept normalization and metric clarity ahead of visual polish.
- Chose examples that mirrored the questions real GTM teams ask weekly.

## [Idea Origin] - 2023-03-07

### Observed
- The idea started with a common RevOps problem: lots of dashboards, not enough confidence in the data model beneath them.
- The missing asset was a durable, inspectable revenue schema that people could reason about directly.