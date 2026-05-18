-- Weighted Analysis
-- Each factor contributes to a composite churn risk score
DROP VIEW customer_risk_scores;

CREATE VIEW customer_risk_scores AS
    SELECT 
        customerID,
        MonthlyCharges,
        tenure,
        contract,
        InternetService,
        churn,
        (CASE contract 							-- most significant factor for churn rate 
            WHEN 'Month-to-month' THEN 30
            WHEN 'One year' THEN 15
            WHEN 'Two year' THEN 0
        END + CASE
            WHEN tenure <= 6 THEN 30  			-- tenure decides the loyalty of customer
            WHEN tenure <= 12 THEN 20
            WHEN tenure <= 24 THEN 10
            ELSE 0
        END + CASE
			WHEN InternetService = 'Fiber optic' THEN 10 -- third most crucial factor deciding the churn rate. 
            WHEN InternetService = 'DSL' THEN 5
            WHEN InternetService = 'No' THEN 0
            END + CASE
            WHEN MonthlyCharges > 85 THEN 20
            WHEN MonthlyCharges > 65 THEN 10
            ELSE 0
        END + CASE
            WHEN OnlineSecurity = 'No' THEN 5
            ELSE 0
        END + CASE
            WHEN TechSupport = 'No' THEN 5
            ELSE 0
        END) AS risk_score
    FROM
        telecom;
    

WITH risk_category AS (
SELECT *, CASE 
WHEN risk_score >= 80 THEN 'High' 
WHEN risk_score >= 40 AND risk_score <= 80 THEN 'Medium'
WHEN risk_score >= 10 AND risk_score <= 40 THEN 'Low' 
ELSE 'Too low'
END AS category
FROM customer_risk_scores
) 

-- Ready for export
-- SELECT* FROM risk_category;

-- Risk Score Aggregation 
 
SELECT AVG(MonthlyCharges)AS mean_charges, COUNT(category) AS count_of_churned_customer, risk_score, InternetService
FROM risk_category
WHERE churn = 'Yes'
GROUP BY risk_score, InternetService
ORDER BY risk_score DESC;



-- Now we can import this data set for further analysis in pandas. 



