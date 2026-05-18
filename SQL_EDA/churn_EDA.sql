-- Data Injection
SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';



CREATE TABLE telecom (
    customerID          VARCHAR(20) PRIMARY KEY,
    gender              VARCHAR(10),
    SeniorCitizen       INT,
    Partner             VARCHAR(5),
    Dependents          VARCHAR(5),
    tenure              INT,
    PhoneService        VARCHAR(5),
    MultipleLines       VARCHAR(20),
    InternetService     VARCHAR(20),
    OnlineSecurity      VARCHAR(20),
    OnlineBackup        VARCHAR(20),
    DeviceProtection    VARCHAR(20),
    TechSupport         VARCHAR(20),
    StreamingTV         VARCHAR(20),
    StreamingMovies     VARCHAR(20),
    Contract            VARCHAR(30),
    PaperlessBilling    VARCHAR(5),
    PaymentMethod       VARCHAR(50),
    MonthlyCharges      DECIMAL(10, 4),
    TotalCharges        DECIMAL(12, 4),
    Churn               VARCHAR(5)
);

LOAD DATA LOCAL INFILE '/Users/prashantsinghchauhan/Downloads/GA_/Capstone/WA_Fn-UseC_-Telco-Customer-Churn.csv'
INTO TABLE telecom
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    customerID, gender, SeniorCitizen, Partner, Dependents, tenure, 
    PhoneService, MultipleLines, InternetService, OnlineSecurity, 
    OnlineBackup, DeviceProtection, TechSupport, StreamingTV, 
    StreamingMovies, Contract, PaperlessBilling, PaymentMethod, 
    MonthlyCharges, @totalcharges, Churn
)
-- DATA Handling 
SET TotalCharges = IF(@totalcharges = '' OR @totalcharges IS NULL, 0, @totalcharges);

-- Verifying BLANKS CONVERSION 
select COUNT(TotalCharges) from telecom
where TotalCharges = 0;

-- Checking NULLS
SELECT COUNT(*) FROM telecom
WHERE NULL;

-- Checking for Duplicates in primary key column 
SELECT customerID 
FROM telecom
GROUP BY customerID 
HAVING COUNT(*) > 1; 

-- Remove all whitespace and invisible characters from Churn column
UPDATE telecom 
SET Churn = TRIM(REPLACE(REPLACE(REPLACE(Churn, '\r', ''), '\n', ''), ' ', ''));

-- EDA 

-- OVERALL CHURN RATE
SELECT COUNT(*) AS total_customer , 
SUM( CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END ) AS churned_customer,
ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) /COUNT(*), 2) AS Churn_Rate
FROM telecom;

-- Creating view since we are about to use this a lot. 
CREATE VIEW telecom_churn AS 
SELECT *, CASE
WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS churn_flag
FROM telecom;


-- CHURN RATE BY CONTRACT TYPE 
SELECT 
    Contract,
    COUNT(*) AS Total_Customers,
    SUM(churn_flag) AS Churned,
    ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) AS Churn_Rate_Percentage
FROM telecom_churn
GROUP BY Contract
ORDER BY Churn_Rate_Percentage DESC;

-- CHURN RATE BY PAYMENT METHOD 
SELECT
	PaymentMethod, 
    COUNT(*) AS Total_Customers,
    SUM(churn_flag) as Churned_customers, 
    ROUND((SUM(churn_flag) / COUNT(*))*100, 2) AS Churn_Rate_Percentage
    FROM telecom_churn
    GROUP BY PaymentMethod
    ORDER BY Churn_Rate_Percentage DESC;
    
    
-- CHURN RATE BY INTERNET SERVICES 
SELECT 
InternetService, 
SUM(churn_flag) as Churned_customer,
ROUND((SUM(churn_flag) / COUNT(*))*100,2) AS Churn_Rate_Percentage
FROM telecom_churn
GROUP BY InternetService
ORDER BY InternetService DESC;

-- AGGREGATION OVER FEATURES 
-- AVG OVER MONTHLY CHARGES
SELECT 
AVG(MonthlyCharges) as avg_monthly_charges, Churn
FROM telecom_churn
GROUP BY Churn ;



-- AVG MONTHLY CHARGES FOR SENIOR CITIZEN  
SELECT 
AVG(MonthlyCharges), 
CASE WHEN SeniorCitizen = 1 THEN 'Senior' ELSE 'Under 60' END AS Seniority
FROM telecom_churn
GROUP BY SeniorCitizen;
































