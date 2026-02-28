## 📄 Technical Documentation: SKU Sales Performance Pipeline

**Project Objective:** Transform raw transactional data into a stakeholder-ready monthly performance report with competitive ranking and market share analytics.

### 🛠 The Tech Stack

* **Engine:** DuckDB (OLAP Optimized)
* **Language:** SQL (Advanced Window Functions & CTEs)
* **Output:** Excel / CSV

---

### 🧠 Architectural Decisions: "Why DuckDB?"

When choosing a tool for this transformation, I prioritized **speed, scalability, and auditability.**

* **In-Process Efficiency:** Unlike PostgreSQL, DuckDB doesn't require a server. It queries the Excel/CSV files directly, meaning the data never has to leave the local environment—a huge plus for data security and setup speed.
* **Analytical Power:** Standard SQL often struggles with complex "pivoting." I leveraged DuckDB’s advanced `FILTER` clause and `WINDOW FUNCTIONS` to calculate grand totals without losing row-level detail (essential for the "Sales Share %" metric).
* **Memory Management:** DuckDB’s columnar storage engine is designed for exactly this: aggregating large amounts of data (OLAP) far more efficiently than row-based engines like SQLite or traditional spreadsheet software.

---

### 🏗 Data Pipeline Phases

#### 1. Transformation Layer (The Pivot)

I used **Conditional Aggregation** to "bucket" raw transactions into monthly columns. This converted a "long" dataset into a "wide" reporting format.

* *Key Logic:* `SUM(units) FILTER (WHERE month = 1)`

#### 2. Analytical Layer (The Market Share)

To calculate the "Share of Sales," I used **Window Functions**. This allowed me to divide individual SKU performance by the company-wide total in a single pass.

* *Key Logic:* `SUM(jan_sales) OVER ()`

#### 3. Presentation Layer (The "Enchantment")

Data is only useful if it's readable. I implemented a formatting layer using `printf` and `CASE` statements to ensure that:

* Large numbers have **thousands-separators** (e.g., 10,000 vs 10000).
* Percentages are rounded and concatenated with a `%` symbol for **immediate visual clarity.**

---

### 📈 Q1 Performance Insights
Market Leader: SKU D dominates the quarter with a 34% total sales share, peaking in March with 28,423 units.

Early Momentum: SKU E showed the strongest start in January (37% share), but lost momentum as the quarter progressed.

## 📊 Interactive Dashboard
Click the image below to view the interactive analysis on Tableau Public.

[![FastGrowingTrees Analytics Dashboard](https://public.tableau.com/static/images/Tr/TreeCompanyProductRevenueAnalytics2024/UnitsSoldin2024/1_rss.png)](https://public.tableau.com/views/TreeCompanyProductRevenueAnalytics2024/UnitsSoldin2024)

*Dashboard highlights include Q1 Units Sold, Revenue Trends, and SKU-level Market Share.*

## Tree Product Highest Profits 2024
Click the image below to view the visualization on Datawraper
[![Tree Product Highest Profits 2024](https://datawrapper.dwcdn.net/P2bHc/full.png)](https://datawrapper.dwcdn.net/P2bHc/1/)

> 💡 **Click the chart above** to view the interactive version with detailed tooltips and hover effects.

### 📈 Scalability Note

While this report was generated for the current dataset, the code is scalable or  **idempotent**. If the input data scales from 1,000 to 1,000,000 rows, this pipeline will execute with the same logic and high performance, whereas a standard Excel-only approach would likely face significant latency or crashes.

💎 Support the Flow

If this SQL code helped you in anyway, please consider supporting:

[![GitHub Sponsor](https://img.shields.io/badge/Sponsor-GitHub-EA4AAA?style=for-the-badge&logo=github-sponsors)](https://github.com/sponsors/IdaAkiwumi)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-00457C?style=for-the-badge&logo=paypal)](https://www.paypal.com/paypalme/iakiwumi)
