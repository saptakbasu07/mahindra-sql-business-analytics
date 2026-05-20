# Mahindra Automotive SQL Business Analytics

## Project Overview

This project simulates a real-world business analytics environment for Mahindra Automotive using PostgreSQL and SQL.

The project focuses on:
- Sales analytics
- Customer analytics
- Dealer performance
- Financing analysis
- EV growth trends
- Delivery delay analysis
- Service analytics

---

## Dataset

The dataset contains:
- Customers
- Orders
- Vehicles
- Dealerships
- Financing
- Service records
- Test drives

---

## SQL Concepts Used

- JOINs
- CTEs
- Window Functions
- Aggregations
- Ranking Functions
- Cohort Analysis
- Retention Analysis
- Time-Series Analytics

---

## Business Problems Solved

- Which vehicle models generate highest revenue?
- Which dealers have highest delivery delays?
- Which states contribute highest sales?
- Which customers are repeat buyers?
- Which vehicle categories depend most on financing?
- Which models require frequent servicing?

---

## Key Insights

- SUVs generated the highest overall revenue.
- EV sales showed strong yearly growth trends.
- Some dealerships exceeded 30-day average delivery delays.
- Premium vehicles showed high financing dependency.
- Customer retention through servicing remained strong.

---

## Sample SQL Query

```sql
WITH revenue AS (
    SELECT 
        vehicle_id,
        SUM(final_price) AS total_revenue
    FROM orders
    WHERE order_status='Delivered'
    GROUP BY vehicle_id
)

SELECT 
    v.model_name,
    r.total_revenue
FROM revenue r
JOIN vehicles v
USING(vehicle_id)
ORDER BY total_revenue DESC;
```

---

## Project Structure

```text
mahindra-sql-business-analytics/

├── data/
├── sql/
├── screenshots/
└── README.md
```

---



---

## Tech Stack

- PostgreSQL
- SQL
- GitHub

---

## Author

Saptak Basu# Mahindra Automotive SQL Business Analytics

## Project Overview

This project simulates a real-world business analytics environment for Mahindra Automotive using PostgreSQL and SQL.

The project focuses on:
- Sales analytics
- Customer analytics
- Dealer performance
- Financing analysis
- EV growth trends
- Delivery delay analysis
- Service analytics

---

## Dataset

The dataset contains:
- Customers
- Orders
- Vehicles
- Dealerships
- Financing
- Service records
- Test drives

---

## SQL Concepts Used

- JOINs
- CTEs
- Window Functions
- Aggregations
- Ranking Functions
- Cohort Analysis
- Retention Analysis
- Time-Series Analytics

---

## Business Problems Solved

- Which vehicle models generate highest revenue?
- Which dealers have highest delivery delays?
- Which states contribute highest sales?
- Which customers are repeat buyers?
- Which vehicle categories depend most on financing?
- Which models require frequent servicing?

---

## Key Insights

- SUVs generated the highest overall revenue.
- EV sales showed strong yearly growth trends.
- Some dealerships exceeded 30-day average delivery delays.
- Premium vehicles showed high financing dependency.
- Customer retention through servicing remained strong.

---

## Sample SQL Query

```sql
WITH revenue AS (
    SELECT 
        vehicle_id,
        SUM(final_price) AS total_revenue
    FROM orders
    WHERE order_status='Delivered'
    GROUP BY vehicle_id
)

SELECT 
    v.model_name,
    r.total_revenue
FROM revenue r
JOIN vehicles v
USING(vehicle_id)
ORDER BY total_revenue DESC;
```

---

## Project Structure

```text
mahindra-sql-business-analytics/

├── data/
├── screenshots/
├── sql/
└── README.md
```

---



---

## Tech Stack

- PostgreSQL
- SQL
- GitHub

---

## Author

Saptak Basu
