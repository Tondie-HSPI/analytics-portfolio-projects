-- SQL Database Design Portfolio
-- Sample MySQL queries for business-style expense analysis.
-- These queries are intended for a local schema with tables similar to:
-- employees, dept_codes, account_codes, expenses, reimbursements, trips, and reason_codes.

-- 1. Review total expense amount by department.
SELECT
    d.dept_name,
    COUNT(*) AS expense_count,
    ROUND(SUM(e.amount), 2) AS total_expense_amount,
    ROUND(AVG(e.amount), 2) AS average_expense_amount
FROM expenses e
JOIN employees emp
    ON e.employee_id = emp.employee_id
JOIN dept_codes d
    ON emp.dept_code = d.dept_code
GROUP BY d.dept_name
ORDER BY total_expense_amount DESC;

-- 2. Identify the highest-cost expense accounts.
SELECT
    a.account_name,
    COUNT(*) AS transaction_count,
    ROUND(SUM(e.amount), 2) AS total_spend
FROM expenses e
JOIN account_codes a
    ON e.account_code = a.account_code
GROUP BY a.account_name
ORDER BY total_spend DESC;

-- 3. Compare reimbursed and unreimbursed expenses.
SELECT
    CASE
        WHEN r.reimbursement_id IS NULL THEN 'Not reimbursed'
        ELSE 'Reimbursed'
    END AS reimbursement_status,
    COUNT(*) AS expense_count,
    ROUND(SUM(e.amount), 2) AS total_amount
FROM expenses e
LEFT JOIN reimbursements r
    ON e.expense_id = r.expense_id
GROUP BY reimbursement_status;

-- 4. Find trips with the largest total expense amount.
SELECT
    t.trip_id,
    t.destination,
    MIN(e.expense_date) AS first_expense_date,
    MAX(e.expense_date) AS last_expense_date,
    ROUND(SUM(e.amount), 2) AS total_trip_expense
FROM trips t
JOIN expenses e
    ON t.trip_id = e.trip_id
GROUP BY t.trip_id, t.destination
ORDER BY total_trip_expense DESC
LIMIT 10;

-- 5. Flag expense reason categories with high average cost.
SELECT
    rc.reason_description,
    COUNT(*) AS expense_count,
    ROUND(AVG(e.amount), 2) AS average_amount,
    ROUND(SUM(e.amount), 2) AS total_amount
FROM expenses e
JOIN reason_codes rc
    ON e.reason_code = rc.reason_code
GROUP BY rc.reason_description
HAVING AVG(e.amount) > 100
ORDER BY average_amount DESC;
