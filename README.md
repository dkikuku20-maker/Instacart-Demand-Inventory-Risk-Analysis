
# 📊 Instacart Demand & Inventory Risk Analysis

## Overview

Analyzed 30M+ Instacart transactions to understand product demand, customer behavior, and inventory risk.
Extended SQL analysis into Python to engineer product-level features and build a risk scoring model for prioritizing inventory decisions.

---

## Problem

Warehouse operations need to:

* understand demand patterns
* identify repeat purchase behavior
* prioritize products at risk of stockouts

This project focuses on moving from descriptive analysis to **decision-oriented insights**.

---

## Data

Instacart Market Basket Analysis dataset (Kaggle)

Key tables used:

* `orders`
* `order_products_prior`
* `products`
* `departments`
* `aisles`

---

## Approach

### 1. SQL Analysis (Data Understanding)

Built core business metrics:

* **Demand**

  * Top products and departments
  * Average basket size (~10 items)

* **Customer Behavior**

  * Reorder rate by department
  * Identification of habit-driven categories (dairy, produce)

* **Time Patterns**

  * Peak ordering: Sunday afternoon, Monday morning
  * Replenishment cycle: ~9–12 days

* **Market Basket Analysis**

  * Identified frequently co-purchased products
  * Found “anchor products” (e.g., bananas)

* **Inventory Risk Signals**

  * Combined demand, reorder rate, and purchase timing to identify sensitive products

---

### 2. Feature Engineering (Python)

Created product-level dataset with:

* `total_units` → demand
* `reorder_rate` → customer loyalty
* `avg_days_between_orders` → purchase timing

Constructed a **proxy target (`at_risk`)** using top quartile thresholds across these features.

---

### 3. Modeling

#### Logistic Regression

* Initial model failed due to class imbalance
* Applied `class_weight="balanced"`
* Improved recall for at-risk products (~99%)

#### Random Forest

* Captured non-linear relationships
* Achieved near-perfect performance
* Identified **data leakage** (target derived from features)

👉 Reframed model as a **risk ranking system**, not a predictive model.

---

### 4. Risk Scoring

Used model probabilities to rank products by risk:

* Prioritized products with:

  * consistent demand
  * high reorder behavior
  * longer purchase cycles

Example high-risk categories:

* eggs, milk, staples
* fresh produce
* daily consumption items

---

## Key Insights

* Demand is driven by **perishable, routine-based products**
* Customers follow a consistent **~10-day replenishment cycle**
* **Behavioral features (timing, loyalty)** are more informative than raw demand
* Stockout risk is highest for:

  * high-loyalty products
  * with less frequent but consistent purchase patterns
* Product substitution is limited for certain categories (e.g., milk variants)

---

## Feature Importance

Random Forest results:

* avg_days_between_orders → ~43%
* reorder_rate → ~29%
* total_units → ~27%

👉 Purchase timing is the strongest driver of operational risk.

---

## Limitations

* No true stockout labels or inventory levels
* Risk model is **proxy-based**, not predictive
* Potential bias due to feature-derived target (data leakage)

---

## Outcome

Developed a **product-level risk scoring approach** that:

* prioritizes inventory monitoring
* highlights operationally sensitive products
* supports decision-making beyond descriptive analytics

---

## Next Steps

* Demand forecasting (time-based modeling)
* Integration with inventory levels
* True stockout prediction

---

## Tech Stack

* SQL (SQL Server)
* Python (pandas, numpy, matplotlib)
* scikit-learn (Logistic Regression, Random Forest)

---
## Dataset

Data sourced from the Instacart Market Basket Analysis dataset:

https://www.kaggle.com/datasets/psparks/instacart-market-basket-analysis

This dataset includes anonymized transactional data such as orders, product metadata, and prior purchase history, enabling analysis of demand patterns, customer behavior, and product relationships.
