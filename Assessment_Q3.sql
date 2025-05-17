-- Query to flag active accounts with no inflow transactions in the last 365 days
SELECT
    pp.id AS plan_id,
    ssa.owner_id,
    -- Determine plan type: 'Savings' for savings plan and 'Investment' for investment plan
    CASE
        WHEN pp.is_regular_savings = 1 THEN 'Savings'
        ELSE 'Investment'
    END AS type,
    -- Get the last transaction date
    MAX(ssa.transaction_date) AS last_transaction_date,
    -- Calculate the number of days since the last transaction
    DATEDIFF(CURDATE(), MAX(ssa.transaction_date)) AS inactivity_days
FROM
    plans_plan pp
JOIN
    savings_savingsaccount ssa ON pp.id = ssa.plan_id
WHERE
    -- Filter for active plans (not deleted)
    pp.is_deleted = 0
    -- Only consider confirmed transactions
    AND ssa.transaction_status = 'Confirmed'
    -- Only consider inflow transactions (confirmed_amount > 0)
    AND ssa.confirmed_amount > 0
GROUP BY
    pp.id, ssa.owner_id
HAVING
    -- Filter for accounts with no inflow transactions in the last 365 days
    inactivity_days > 365;
