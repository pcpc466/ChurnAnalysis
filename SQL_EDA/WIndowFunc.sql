
--  Cohort Analysis

-- AVG CHARGES & CHURN RATE OVER COHORT TENURE 
SELECT 
CASE 
WHEN tenure <=  12 THEN '0-1 Years'
WHEN tenure <= 24 THEN '1-2 Years'
WHEN tenure <= 36 THEN '2-3 Years' 
ELSE '3+ years' END AS tenure_cohort, 
ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) AS Churn_Rate_Percentage,
AVG(MonthlyCharges) AS avg_monthly_charges
FROM telecom_churn
GROUP BY tenure_cohort;


 -- top 20 highest paying churner
SELECT 
customerID, tenure,
SUM(TotalCharges) OVER (ORDER BY tenure DESC) AS cum_revenue 
FROM telecom
WHERE churn = 'Yes'
LIMIT 20;

-- Customer with high-revenue grouped by tenure duration
SELECT
    customerID,
    MonthlyCharges,
    Contract,
    tenure,
    RANK() OVER (ORDER BY MonthlyCharges DESC) AS charge_rank,
    AVG(MonthlyCharges) OVER (PARTITION BY Contract) AS avg_charge_by_contract
FROM telecom
WHERE Churn = 'Yes'
ORDER BY MonthlyCharges DESC
LIMIT 20;

-- Cohort Risk Score

WITH cohort AS (
SELECT customerID, tenure, MonthlyCharges, 
CASE 
WHEN tenure < 6 THEN 'Very High Risk'
WHEN tenure < 12 THEN 'High Risk'
WHEN tenure < 24 THEN 'Moderate Risk'
WHEN tenure < 48 THEN 'Low Risk'
ELSE 'Loyal Customer' 
END AS risk_score
FROM telecom
WHERE Churn = 'No'
)

SELECT c.customerID, t.MonthlyCharges, t.InternetService
FROM telecom t
JOIN cohort c ON t.customerID = c.customerID
WHERE c.risk_score = 'Very High Risk' 

GROUP BY t.InternetService, c.customerID
HAVING t.MonthlyCharges > (SELECT AVG(MonthlyCharges) FROM telecom)
ORDER BY t.MonthlyCharges DESC;

-- These are the potential churnable customer that can on the basis of monthly charges and cohort period. 








