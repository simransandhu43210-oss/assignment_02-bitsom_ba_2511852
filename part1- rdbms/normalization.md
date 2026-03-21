## 1.1 - ANOMALY ANALYSIS
*Insert Anomaly:*

In the orders_flat.csv dataset, all customer, product, and sales representative data is combined into a single table. This design creates a significant limitation it becomes impossible to record information about a product or customer independently, without an accompanying order.

For instance, suppose the company introduces a new product that has not yet been purchased by any customer. There is no straightforward way to store that product's details, because every row in the table demands values for fields such as order_id, customer_id, and sales_rep_id. To work around this, one would have to fabricate a dummy order record just to hold the product information which directly results in inaccurate and misleading data entries.

This problem arises because product attributes like product_id, product_name, category, and unit_price are tightly coupled with order data, leaving no room to store them independently.


*Update Anomaly:*

Because the same information is duplicated across several rows, a single real-world change can demand edits in multiple places. Take product P004 as an example if its unit_price is revised, that change must be reflected in every row where P004 appears. Should even one row be overlooked, the dataset ends up holding conflicting values for the same product.

The same issue applies to customer information. Fields like customer_email are repeated across every order a customer places. Updating an email address therefore means tracking down and modifying every related row a process that is both tedious and error-prone, significantly raising the risk of data inconsistency.


*Delete Anomaly:*

A further complication emerges when records are removed. Since multiple types of information are bundled into the same table, deleting a single row can inadvertently wipe out data that was never meant to be removed.

Consider a scenario where the only order associated with a particular product is deleted. That product's details including its product_name, category, and unit_price vanish along with it, even though the product itself still exists. The same applies to sales representatives: if a representative is linked to just one order and that order gets deleted, every trace of that representative disappears from the dataset entirely.

This clearly illustrates how a flat table structure can lead to unintended and irreversible loss of important information.


*Normalization Justification:*

At first glance, storing everything in one table may appear convenient. However, the structure of orders_flat.csv reveals the real cost of that simplicity. When customer details, product information, sales representatives, and order records all coexist in the same table, the same data gets repeated endlessly across rows.

More critically, this structure gives rise to the insert, update, and delete anomalies discussed above. Adding a new product forces the creation of an artificial order record. Modifying a price or updating a customer's contact details requires changes across numerous rows, increasing the likelihood of inconsistencies slipping through. And removing a single order can silently erase data about products or representatives that are still relevant.

Normalizing the database into dedicated tables such as customers, products, sales_reps, orders, and order_items ,resolves each of these issues. Each table holds only the data that belongs to its respective entity, while relationships between entities are managed cleanly through primary and foreign keys. This structure eliminates redundancy, strengthens data integrity, and makes future updates far safer and more manageable.

Normalization, therefore, is not an added layer of complexity ,it is a foundational design principle that keeps a database consistent, reliable, and scalable as it continues to grow.