-- SQL Database Design and Data Warehousing Portfolio
-- Curated MySQL examples from CIS467: Data Management, Data Warehousing
-- and Data Visualization.

-- ============================================================
-- 1. Safety Operations Analysis
-- ============================================================
-- Business question:
-- Which locations have high safety incident rates relative to headcount?

USE safety;

-- Lost time incidents as a percent of location headcount.
SELECT
    l.location_id,
    l.division,
    l.headcount,
    COUNT(i.incident_id) AS total_lti,
    ROUND(COUNT(i.incident_id) / l.headcount, 4) AS lti_percent
FROM locations AS l
JOIN lti AS i
    ON l.location_id = i.location_id
GROUP BY
    l.location_id,
    l.division,
    l.headcount
HAVING COUNT(i.incident_id) / l.headcount > 0.25
ORDER BY lti_percent DESC;

-- Near miss incidents for one division, ranked by incident rate.
SELECT
    l.location_id,
    l.division,
    l.headcount,
    COUNT(n.incident_id) AS total_nmi,
    ROUND(COUNT(n.incident_id) / l.headcount, 4) AS nmi_percent
FROM locations AS l
JOIN nmi AS n
    ON l.location_id = n.location_id
WHERE l.division = 'PK'
GROUP BY
    l.location_id,
    l.division,
    l.headcount
HAVING COUNT(n.incident_id) / l.headcount > 0.25
ORDER BY nmi_percent DESC
LIMIT 6 OFFSET 4;

-- Locations with above-average headcount.
SELECT
    location_id,
    division,
    state,
    city,
    headcount
FROM locations
WHERE headcount >= (
    SELECT AVG(headcount)
    FROM locations
)
ORDER BY headcount DESC;


-- ============================================================
-- 2. Expense Data Warehouse
-- ============================================================
-- Business question:
-- How can travel expense records be transformed into an analytics-ready
-- warehouse table for departmental and employee spending analysis?

USE expense;

DROP TABLE IF EXISTS expense_dw;

CREATE TABLE expense_dw AS
SELECT
    t.employee,
    t.trip_id,
    e.first_name,
    e.last_name,
    d.dept_name,
    r.reason_description,
    t.start_date,
    t.end_date,
    COUNT(ex.expense_seq) AS total_line_items,
    ROUND(SUM(ex.gross_amount), 2) AS total_gross_amount,
    ROUND(SUM(COALESCE(ex.tax, 0)), 2) AS total_tax_amount,
    ROUND(SUM(ex.gross_amount + COALESCE(ex.tax, 0)), 2) AS total_net_amount
FROM trips AS t
JOIN employees AS e
    ON e.ssn = t.employee
JOIN dept_codes AS d
    ON d.dept_id = e.dept
JOIN reason_codes AS r
    ON r.reason_code = t.reason_code
JOIN expenses AS ex
    ON ex.employee = t.employee
   AND ex.trip_id = t.trip_id
GROUP BY
    t.employee,
    t.trip_id,
    e.first_name,
    e.last_name,
    d.dept_name,
    r.reason_description,
    t.start_date,
    t.end_date;

-- Department spending summary.
SELECT
    dept_name,
    COUNT(*) AS trip_count,
    ROUND(SUM(total_net_amount), 2) AS total_spending,
    ROUND(AVG(total_net_amount), 2) AS average_trip_cost
FROM expense_dw
GROUP BY dept_name
ORDER BY total_spending DESC;

-- Travel reason categories with meaningful trip volume.
SELECT
    reason_description,
    COUNT(*) AS trip_count,
    ROUND(AVG(total_net_amount), 2) AS average_trip_cost,
    ROUND(SUM(total_net_amount), 2) AS total_spending
FROM expense_dw
GROUP BY reason_description
HAVING COUNT(*) >= 5
ORDER BY average_trip_cost DESC;

-- Trips with above-average total cost.
SELECT
    employee,
    trip_id,
    first_name,
    last_name,
    dept_name,
    reason_description,
    total_net_amount
FROM expense_dw
WHERE total_net_amount > (
    SELECT AVG(total_net_amount)
    FROM expense_dw
)
ORDER BY total_net_amount DESC;

-- Highest-spending employees.
SELECT
    dept_name,
    employee,
    first_name,
    last_name,
    ROUND(SUM(total_net_amount), 2) AS employee_total_spending
FROM expense_dw
GROUP BY
    dept_name,
    employee,
    first_name,
    last_name
ORDER BY employee_total_spending DESC;


-- ============================================================
-- 3. Film Rental Performance Data Warehouse
-- ============================================================
-- Business question:
-- Which film titles generate the most revenue and how should inventory,
-- marketing, and recommendation decisions be prioritized?

USE sakila;

DROP TABLE IF EXISTS dw_film_performance;

CREATE TABLE dw_film_performance AS
SELECT
    f.film_id,
    f.title,
    f.release_year,
    f.rating,
    f.length,
    f.rental_rate,
    c.name AS category_name,
    COUNT(DISTINCT cust.customer_id) AS customer_count,
    ROUND(
        COUNT(DISTINCT CASE WHEN cust.active = 1 THEN cust.customer_id END)
        / NULLIF(COUNT(DISTINCT cust.customer_id), 0),
        2
    ) AS active_customer_rate,
    COUNT(DISTINCT fa.actor_id) AS actor_count,
    COUNT(DISTINCT i.inventory_id) AS inventory_count,
    COUNT(DISTINCT i.store_id) AS stores_stocking_count,
    COUNT(DISTINCT r.rental_id) AS rental_count,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    ROUND(AVG(p.amount), 2) AS average_payment,
    MIN(r.rental_date) AS first_rental_date,
    MAX(r.rental_date) AS last_rental_date,
    ROUND(
        AVG(
            CASE
                WHEN r.return_date IS NULL THEN NULL
                ELSE DATEDIFF(r.return_date, r.rental_date)
            END
        ),
        2
    ) AS average_days_out,
    ROUND(
        COUNT(DISTINCT r.rental_id) / NULLIF(COUNT(DISTINCT i.inventory_id), 0),
        2
    ) AS rentals_per_copy
FROM film AS f
JOIN film_category AS fc
    ON fc.film_id = f.film_id
JOIN category AS c
    ON c.category_id = fc.category_id
LEFT JOIN film_actor AS fa
    ON fa.film_id = f.film_id
LEFT JOIN inventory AS i
    ON i.film_id = f.film_id
LEFT JOIN rental AS r
    ON r.inventory_id = i.inventory_id
LEFT JOIN payment AS p
    ON p.rental_id = r.rental_id
LEFT JOIN customer AS cust
    ON cust.customer_id = r.customer_id
GROUP BY
    f.film_id,
    f.title,
    f.release_year,
    f.rating,
    f.length,
    f.rental_rate,
    c.name;

-- Highest-revenue films.
SELECT
    film_id,
    title,
    category_name,
    total_revenue,
    rental_count
FROM dw_film_performance
ORDER BY total_revenue DESC
LIMIT 25;

-- Films with strong revenue per rental.
SELECT
    film_id,
    title,
    category_name,
    rental_count,
    total_revenue,
    ROUND(total_revenue / NULLIF(rental_count, 0), 2) AS revenue_per_rental
FROM dw_film_performance
WHERE rental_count >= 20
ORDER BY revenue_per_rental DESC
LIMIT 25;

-- Above-average revenue performers.
SELECT
    film_id,
    title,
    category_name,
    total_revenue
FROM dw_film_performance
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM dw_film_performance
)
ORDER BY total_revenue DESC;

-- Understocked high-demand films.
SELECT
    film_id,
    title,
    category_name,
    inventory_count,
    rental_count,
    rentals_per_copy,
    total_revenue
FROM dw_film_performance
WHERE rental_count >= 20
  AND inventory_count <= 3
ORDER BY rentals_per_copy DESC;

-- Reusable classification logic for portfolio segmentation.
DROP FUNCTION IF EXISTS fn_film_segment;

DELIMITER $$

CREATE FUNCTION fn_film_segment(p_film_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_revenue DECIMAL(10, 2);
    DECLARE v_segment VARCHAR(20);

    SELECT IFNULL(total_revenue, 0)
    INTO v_revenue
    FROM dw_film_performance
    WHERE film_id = p_film_id;

    SET v_segment = CASE
        WHEN v_revenue >= 750 THEN 'Blockbuster'
        WHEN v_revenue >= 150 THEN 'Steady'
        ELSE 'Long Tail'
    END;

    RETURN v_segment;
END $$

DELIMITER ;

SELECT
    film_id,
    title,
    total_revenue,
    fn_film_segment(film_id) AS segment
FROM dw_film_performance
ORDER BY title
LIMIT 25;
