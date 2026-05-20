# 📉 Customer Churn Analysis & Retention Strategy
### IBM Telco Dataset — End-to-End Data Science & Business Intelligence Project


## 📌 Overview

This project is a full-stack business intelligence case study on customer churn in the telecom industry, built on the IBM Telco Customer Churn dataset. It covers the entire data pipeline — from raw SQL ingestion and exploratory data analysis, through machine learning modeling, to a polished executive-facing BI report with strategic retention recommendations.

The analysis surfaces a **26% churn rate** (vs. a 15% industry benchmark), estimates **$3M+ in annual preventable revenue loss**, and identifies the key drivers — contract type, tenure, fiber optic service, and lack of tech support — that together account for the majority of churn risk.

---

## 🗂️ Project Structure

```
├── SQL/
│   ├── churn_EDA.sql               # Data ingestion, cleaning, and exploratory queries
│   ├── weighted_churn_scoring.sql  # Composite risk scoring model (weighted features)
│   └── WIndowFunc.sql              # Cohort analysis, window functions, and ranking
│
├── Notebooks/
│   ├── Cluster_analysis.ipynb      # K-Means clustering by risk score and charges
│   ├── Logistical_modeling.ipynb   # Logistic Regression with confusion matrix
│   └── Random_forest.ipynb         # Random Forest with feature importance
│
└── Report/
    └── Churn.pdf                   # Full BI report — findings, visuals, and strategy
     |__ Churn.pptx                 # A full presentation with integrated from tableau 
```

---

## 📊 Dataset

| Field | Detail |
|---|---|
| Source | IBM Telco Customer Churn (Kaggle) |
| Customers | 7,043 |
| Features | 21 |
| Target | `Churn` (Yes / No) |
| Churn Rate | 26.5% |
| Secondary Dataset | IBM Extended (geo + demographics) |

**Key features used:** `tenure`, `Contract`, `MonthlyCharges`, `InternetService`, `TechSupport`, `OnlineSecurity`, `PaymentMethod`, `TotalCharges` 

---

## 🔍 Key Findings

### Churn Drivers

| Driver | Impact |
|---|---|
| Month-to-month contract | 67% churn rate — highest of any segment |
| Tenure < 12 months | 30-point risk score premium; most vulnerable window |
| Fiber optic internet | 2x churn rate vs DSL customers |
| No tech support | Reduces customer lifecycle by 52%; costs ~$1,458/customer |
| High monthly charges (>$85) | 20-point risk score premium |
| Electronic check payment | 45% of churned customers used this method |

### Financial Impact
- Estimated annual revenue loss: **$3M+**
- Acquiring a new customer costs **5x more** than retaining one
- A 10% improvement in retention adds ~**$150K/year** in recovered revenue
- Retained customers generate **2x the lifetime value** of newly acquired ones

---

## 🛠️ SQL Pipeline

### `churn_EDA.sql`
- Creates and loads the `telecom` table with proper type handling for blank `TotalCharges`
- Builds a reusable `telecom_churn` VIEW with a `churn_flag` binary column
- Runs churn rate analysis by contract type, payment method, internet service, and seniority

### `weighted_churn_scoring.sql`
- Engineers a composite `risk_score` from five weighted features:
  - Contract type (0–30 pts), tenure band (0–30 pts), internet service (0–10 pts), monthly charges (0–20 pts), missing support services (0–10 pts)
- Categorises customers into High / Medium / Low / Too Low risk tiers
- Exports risk-scored dataset for downstream Python analysis

### `WIndowFunc.sql`
- Cohort-level churn rate and average charges by tenure band (0–1 yr, 1–2 yr, 2–3 yr, 3+ yr)
- Cumulative revenue from top 20 highest-paying churners using `SUM() OVER`
- `RANK()` of high-value churners by monthly charges, partitioned by contract type
- Identifies **potentially churnable non-churners** by joining cohort risk tiers with above-average charges

---

## 🤖 Machine Learning Pipeline

### Models

| Model | Accuracy | Precision (Churn) | Recall | F1 (Weighted) |
|---|---|---|---|---|
| Logistic Regression | 0.67 | 0.64 | 0.69 | 0.67 |
| Random Forest | **0.79** | **0.64** | **0.79** | **0.78** |

**Random Forest outperforms** on overall accuracy and recall — better at catching actual churners, which is the priority for retention campaigns.

### Top Features (Random Forest)
1. `tenure` — strongest single predictor
2. `MonthlyCharges`
3. `contract_Two year`
4. `InternetService_Fiber optic`
5. `contract_One year`

### Cluster Analysis (K-Means)
Customers were clustered on `risk_score` and `MonthlyCharges`, revealing three behavioural segments that map to retention intervention priority.

---

## 📈 Retention Strategy Framework

| Initiative | Target Segment | Mechanism |
|---|---|---|
| Contract migration incentives | Month-to-month customers | Discounts for upgrading to annual/two-year |
| Improved onboarding (first 180 days) | Tenure < 6 months | Early value delivery to reduce early churn |
| Tech support bundling | Fiber optic, no support | Bundle support into plans; shown to double lifecycle |
| Predictive risk alerts | High risk-score customers | Trigger proactive outreach before decision point |
| Loyalty rewards | 12–36 month customers | Tenure-based benefits to prevent mid-life churn |
| Flexible pricing / AI retention offers | High monthly charge customers | Usage-based, personalised retention offers |

---

## ⚙️ Setup & Usage

### Prerequisites
```
Python 3.10+
MySQL 8.0+
Jupyter Notebook
```

### Python dependencies
```bash
pip install pandas numpy scikit-learn matplotlib seaborn
```

### SQL — load the data
```sql
SET GLOBAL local_infile = 1;
-- Update the file path in churn_EDA.sql to your local CSV location, then run:
SOURCE sql/churn_EDA.sql;
SOURCE sql/weighted_churn_scoring.sql;
SOURCE sql/WIndowFunc.sql;
```

### Notebooks — run in order
```
1. Cluster_analysis.ipynb
2. Logistical_modeling.ipynb
3. Random_forest.ipynb
```

---


## 📁 Data Sources

- **Primary:** [IBM Telco Customer Churn — Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)  
  Used for: EDA, SQL analysis, all ML modeling
- **Secondary:** [IBM Telco Extended Dataset — Kaggle](https://www.kaggle.com/datasets/yeanzc/telco-customer-churn-ibm-dataset)  
  Used for: Geographic churn density mapping in Tableau

All visualisations, dashboards, feature importance plots, confusion matrices, and the BI report were independently produced by the author using Python and Tableau.

---



## 👤 Author

**Prashant Singh Chauhan**  
Business Intelligence & Data Science — Capstone Project

---

*Dataset licensed under open terms on Kaggle. No proprietary data was used.*
