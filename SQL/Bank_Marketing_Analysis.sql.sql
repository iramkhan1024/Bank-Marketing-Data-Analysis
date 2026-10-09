use ihub_project

select * from banks

--- 1. Complex Queries:
----- Top Jobs by Balance:Write a query to find the top 5 job types with the highest average balance.----

select top(5) job,AVG(balance) as avg_balance from banks
group by job
order by avg_balance desc


----- Campaign Success Rate: Use joins to calculate the success rate of the campaign for different education levels.-----

SELECT

SELECT
    education,
    COUNT(*) AS Total_Clients,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS Successful_Clients,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Success_Rate
FROM banks
GROUP BY education;



----2. Views:
---- Client Summary View: Create a view that summarizes key information for each client, including average balance, number of loans, and contact details.----

CREATE VIEW Client_Summary AS
SELECT
    age,
    job,
    marital,
    education,
    balance,
    (CASE WHEN housing='yes' THEN 1 ELSE 0 END +
     CASE WHEN loan='yes' THEN 1 ELSE 0 END) AS number_of_loans,
    contact
FROM banks;

SELECT * FROM Client_Summary;

----- Campaign Performance View: Create a view that shows the performance of the campaign by month, including the number of contacts and success rate.---
CREATE VIEW Campaign_Performance AS
SELECT
    month,
    COUNT(*) AS total_contacts,
    SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS successful_contacts,
    ROUND(
        SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS success_rate
FROM banks
GROUP BY month;

--- Indexes:---
---- Index Creation: Create indexes on columns that are frequently queried (e.g., age, job, marital) to optimize query performance.---

---Index on Age----

CREATE INDEX idx_age
ON banks(age);

--Index on Job---

CREATE INDEX idx_job
ON banks(job);

---Index on Marital---

CREATE INDEX idx_marital
ON banks(marital);

--- Stored Procedures:-----
---- Update Balance Procedure: Create a stored procedure to update the balance of clients based on their transaction history----

CREATE PROCEDURE Update_Balance
    @Age INT,
    @NewBalance INT
AS
BEGIN
    UPDATE banks
    SET balance = @NewBalance
    WHERE age = @Age;
END;
GO