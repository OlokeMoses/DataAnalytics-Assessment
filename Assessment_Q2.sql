
-- Query to categorize customers based on their transaction frequency
SELECT
    -- Categorize based on the average transactions per month
    CASE
        WHEN t.transactions_per_month >= 10 THEN 'High Frequency'
        WHEN t.transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(DISTINCT u.id) AS customer_count,
    AVG(t.transactions_per_month) AS avg_transactions_per_month
FROM (
    -- Subquery: Calculate the number of transactions per month for each customer
    SELECT
        owner_id,
        -- Calculate the transactions per month for each customer
        COUNT(id) / DATEDIFF(MAX(transaction_date), MIN(transaction_date)) * 30 AS transactions_per_month
    FROM
        savings_savingsaccount
    GROUP BY
        owner_id
) t
JOIN
    users_customuser u ON t.owner_id = u.id
GROUP BY
    frequency_category;  -- Group by the frequency category

