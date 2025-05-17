-- SELECT * FROM adashi_staging.users_customuser;
-- Query to identify customers with both a funded savings plan and a funded investment plan
-- We join the users_customuser, savings_savingsaccount, and plans_plan tables
-- We count the savings and investment plans for each customer and sort by total deposits
SELECT * FROM adashi_staging.users_customuser;
SELECT * FROM adashi_staging.plans_plan;
SELECT * FROM adashi_staging.withdrawals_withdrawal;
SELECT * FROM adashi_staging.savings_savingsaccount;

SET GLOBAL net_read_timeout = 600;
SET GLOBAL net_write_timeout = 600;
SET GLOBAL wait_timeout = 600;
SET GLOBAL interactive_timeout = 600;

SHOW INDEXES FROM savings_savingsaccount;
SHOW INDEXES FROM plans_plan;

CREATE INDEX idx_plan_amount ON plans_plan(amount);
CREATE INDEX idx_plan_is_a_fund ON plans_plan(is_a_fund);

-- Optimized Query: Using Subqueries for Savings and Investment Counts
SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    IFNULL(savings.savings_count, 0) AS savings_count,
    IFNULL(investments.investment_count, 0) AS investment_count,
    IFNULL(savings.total_deposits, 0) + IFNULL(investments.total_deposits, 0) AS total_deposits
FROM
    users_customuser u
LEFT JOIN (
    -- Subquery to calculate the funded savings count and total deposits
    SELECT
        ssa.owner_id,
        COUNT(DISTINCT ssa.id) AS savings_count,
        SUM(ssa.amount) AS total_deposits
    FROM
        savings_savingsaccount ssa
    WHERE
        ssa.amount > 0 -- Only funded savings plans
    GROUP BY
        ssa.owner_id
) savings ON u.id = savings.owner_id
LEFT JOIN (
    -- Subquery to calculate the funded investment count and total deposits
    SELECT
        pp.owner_id,
        COUNT(DISTINCT pp.id) AS investment_count,
        SUM(pp.amount) AS total_deposits
    FROM
        plans_plan pp
    WHERE
        pp.amount > 0 AND pp.is_a_fund = 1 -- Only funded investment plans
    GROUP BY
        pp.owner_id
) investments ON u.id = investments.owner_id
WHERE
    (savings.savings_count > 0 OR investments.investment_count > 0) -- Only customers with funded savings or investment plans
HAVING
    savings_count > 0 AND investment_count > 0 -- Both savings and investment plans
ORDER BY
    total_deposits DESC;

