SELECT * FROM adashi_staging.savings_savingsaccount;

-- Query to calculate Customer Lifetime Value (CLV) for each customer

SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    -- Calculate account tenure in months
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    -- Count the total number of transactions for the customer
    COUNT(ssa.id) AS total_transactions,
    -- Calculate the estimated CLV: (total transactions / tenure) * 12 * avg profit per transaction
    (COUNT(ssa.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * (0.001 * SUM(ssa.confirmed_amount)) AS estimated_clv
FROM
    users_customuser u
JOIN
    savings_savingsaccount ssa ON u.id = ssa.owner_id
WHERE
    ssa.transaction_status = 'Confirmed' -- Only confirmed transactions
GROUP BY
    u.id
ORDER BY
    estimated_clv DESC;

