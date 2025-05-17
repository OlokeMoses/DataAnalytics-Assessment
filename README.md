DataAnalytics-Assessment/
│
├── Assessment_Q1.sql       # Solution to Question 1: User Savings and Investment Data Analysis
├── Assessment_Q2.sql       # Solution to Question 2: Categorizing Customers Based on Transaction Frequency
├── Assessment_Q3.sql       # Solution to Question 3: Identifying Inactive Accounts
├── Assessment_Q4.sql       # Solution to Question 4: Customer Lifetime Value Calculation
│
└── README.md               # This file

Per-Question Explanations
Assessment_Q1.sql: User Savings and Investment Data Analysis
In this query, I aimed to calculate the number of funded savings and investment accounts for each customer and their total deposits in both categories.
The query joins the users_customuser table with subqueries that calculate the count of savings and investment accounts as well as their corresponding total deposits. 
The results are filtered to show only customers who have both funded savings and investments. The query is sorted by total deposits in descending order.

Approach:
LEFT JOIN: Used to include all users, even those without any savings or investments.
IFNULL: Ensured that users with no savings or investment data had a count of 0.
Subqueries: Used to calculate the counts and totals for savings and investments separately, which were then joined on the user_id.

Challenges:
Aggregating data from two different sources (savings and investments) required subqueries. 
Ensuring the correct join logic between them and the user data was a bit tricky.

Handling NULL values and ensuring they are counted correctly (using IFNULL) 
posed a challenge when joining tables that may have missing data.

Assessment_Q2.sql: Categorizing Customers Based on Transaction Frequency
This query categorizes customers based on their transaction frequency. 
I calculates the average number of transactions per customer per month and categorizes them as
'High Frequency,' 'Medium Frequency,' or 'Low Frequency.'

Approach:
Subquery: Calculated the transactions per customer using COUNT(id) 
and the difference in transaction dates to get the number of transactions per month.

CASE statement: Used to categorize customers based on their average transaction frequency.
JOIN: Combined the transaction data with user details to produce the final output.

Challenges:
The calculation of average transactions per month was tricky due to varying transaction dates. 
I used DATEDIFF(MAX(transaction_date), MIN(transaction_date)) to account for the number of months 
between the earliest and latest transactions.
Ensuring the correct grouping and accurate categorization based on the frequency thresholds was a little complex when the data had gaps or fewer transactions.

Assessment_Q3.sql: Identifying Inactive Accounts
This query identifies accounts with no inflow transactions in the last 365 days. It joins the savings and investment plans, checks for confirmed transactions, and calculates the inactivity days for each account.

Approach:
JOIN: Combined plans_plan and savings_savingsaccount tables to get the transaction details of each plan.
DATEDIFF: Used to calculate the number of days since the last transaction for each account.
HAVING clause: Filtered accounts that had no transactions in the last 365 days.

Challenges:
Ensuring that the query only considers valid (confirmed) transactions with positive amounts was challenging. I used ssa.confirmed_amount > 0 and ssa.transaction_status = 'Confirmed' to filter out invalid transactions.
Handling accounts that might not have had any transactions in the last year but were still included in the results required precise logic in the HAVING clause.
Assessment_Q4.sql: Customer Lifetime Value Calculation
This query calculates the Customer Lifetime Value (CLV) for each customer. It takes into account the total number of confirmed transactions and the tenure (in months) of each customer.

Approach:
Customer Tenure: Used TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) to calculate the number of months a customer has been active.
Transaction Count: Used COUNT(ssa.id) to calculate the total number of transactions for each customer.
Estimated CLV: Used the formula (COUNT(ssa.id) / tenure_months) * 12 * avg_profit_per_transaction to estimate the CLV, where the profit per transaction is fixed at 0.1% of the transaction amount.

Challenges:
The formula for CLV required a multiplier for profit per transaction. While a fixed rate (0.1%) was used here, dynamically adjusting it based on 
real transaction data would make the CLV calculation more accurate.
Ensuring accurate handling of confirmed transactions (ssa.transaction_status = 'Confirmed') and avoiding transactions with invalid amounts was a challenge.

Challenges
General Challenges Across Queries:
Handling NULL Values: Ensuring that NULL values were properly handled (especially in aggregated columns like savings_count and investment_count) required the use of functions like IFNULL and COALESCE.
Data Aggregation: Aggregating data from different tables (e.g., savings_savingsaccount and plans_plan) while ensuring consistency across subqueries required careful attention to JOIN logic.
Performance Concerns: Some of the queries (especially those involving COUNT(DISTINCT) and SUM) could become slow on large datasets. I used indexes (CREATE INDEX) to optimize these queries, 
but performance may still be an issue with very large datasets.

Query Optimization:
Some queries could benefit from further optimization, especially those involving large joins and aggregates. Using indexed views or materialized views could help reduce query execution 
time for repeated tasks like transaction frequency categorization.

