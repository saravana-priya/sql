# 📊 E-commerce Sales Analytics with BigQuery

An end-to-end SQL-based data analytics project using Google BigQuery, built on the `thelook_ecommerce` public dataset. This project demonstrates core data engineering and analytics skills — from raw data exploration to dimensional modeling, KPI reporting, geospatial analysis, and window function logic.

---

## 🧰 Tools & Technologies
- **Google BigQuery** (SQL)
- **BigQuery Public Dataset**: `bigquery-public-data.thelook_ecommerce`
- **Window Functions**, **CTEs**, **Geospatial SQL**

---

## 📁 Project Structure

```
📦 ecommerce-sales-analytics/
├── 01_exploration_queries.sql         -- Initial EDA and sales insights
├── 02_transformation_queries.sql      -- Cleaned tables, star schema, and denormalized table
├── 03_kpi_queries.sql                 -- Business KPIs using clean schema
├── 04_window_and_yoy_queries.sql      -- Ranking, ROW_NUMBER, LAG/LEAD (YoY comparison)
└── README.md                          -- Project overview
```

---

## 🔍 Key Features

### ✅ 1. Data Exploration
- Monthly revenue trends
- Top-selling products
- Customer acquisition (new vs returning)

### ✅ 2. Data Modeling
- Created dimension and fact tables using clean SQL logic
- Built star schema and a fully denormalized reporting table

### ✅ 3. Business KPIs
- Total revenue, order volume, AOV, CLTV
- Sales by category, region, and product
- New vs returning customer trends

### ✅ 4. Geospatial Analytics
- Revenue by customer proximity to NYC or SF
- Sales distribution by city/state
- Worked with BigQuery `GEOGRAPHY` data and `ST_DISTANCE`

### ✅ 5. Advanced SQL (Window Functions)
- `RANK()` for top products by category
- `ROW_NUMBER()` for first transaction each day
- `LAG()` and `LEAD()` for year-over-year sales comparison

---

## 📊 Example KPIs Generated

| KPI | Description |
|-----|-------------|
| 💰 Revenue | Monthly & yearly sales totals |
| 🛍️ AOV | Average Order Value |
| 🧍 CLTV | Customer Lifetime Value |
| 🌍 Geo Sales | Sales by distance from NYC |
| ⏱️ YoY Growth | % revenue change year-over-year |
| 🔝 Product Rank | Best-selling product per category |

---

## 🚀 Getting Started

1. Open [Google BigQuery Console](https://console.cloud.google.com/bigquery)
2. Pin the public dataset: `bigquery-public-data.thelook_ecommerce`
3. Replace `mydatapipelineproject.dpl` in scripts with your GCP project and dataset
4. Run each SQL script in order for full pipeline

---

## 📌 Notes
- This project is designed to highlight practical, job-ready SQL skills.
- Easily adaptable to any other retail or sales dataset.
- Ideal for GCP Data Engineers, Analysts, and BI professionals.

---

## 👩‍💻 Author

**Saravana Priya**  
*Google Certified Professional Data Engineer*  
📍 India | 💼 Open to GCP roles in Europe  
🔗 [LinkedIn](www.linkedin.com/in/saravana-priya)  
🌐 [GitHub](https://github.com/saravana-priya)
