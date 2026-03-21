## *Architecture Recommendation*

For a fast-growing food delivery startup handling GPS logs, customer reviews, payment transactions, and menu images, I would recommend a Data Lakehouse architecture.

A pure Data Warehouse is immediately ruled out because it only handles structured, pre-defined tabular data. GPS location streams arrive as time-series coordinates with irregular intervals, menu images are binary blobs, and customer reviews are free-form text — none of these fit neatly into a relational schema without significant pre-processing that introduces both latency and data loss.

A plain Data Lake would store all four data types without complaint, but it lacks the reliability guarantees that payment transaction data specifically requires. Financial records need ACID compliance — if a write fails mid-transaction, the partial record must be rolled back, not persisted. A raw data lake offers no such guarantee, making it unsuitable as the single source of truth for billing.

A Lakehouse resolves both limitations simultaneously. It stores GPS logs, review text, and menu images in their native formats without forced schema conversion, while layering Delta Lake or Apache Iceberg on top of the payment data to enforce ACID transactions and schema validation. This dual capability is precisely what a multi-data-type startup needs.

Additionally, a Lakehouse supports incremental ingestion at scale. New GPS pings or review batches are appended without rewriting existing partitions, and historical payment data remains queryable through columnar optimizations. One unified platform replacing a separate warehouse and lake reduces infrastructure cost and operational overhead during the critical growth phase.