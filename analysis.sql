-- 📂 Household Bill Analysis SQL File
-- Dataset Columns: num_rooms, num_people, housearea, is_ac, is_tv, is_flat,
--                  ave_monthly_income, num_children, is_urban, amount_paid

---------------------------------------------------------
-- 1. Total households and total amount paid
---------------------------------------------------------
SELECT 
    COUNT(*) AS total_households,
    SUM(amount_paid) AS total_amount_paid
FROM bill_data;
-- Insight: Gives an overall scale of dataset.

---------------------------------------------------------
-- 2. Average payment by urban vs rural households
---------------------------------------------------------
SELECT 
    CASE WHEN is_urban = 1 THEN 'Urban' ELSE 'Rural' END AS area_type,
    AVG(amount_paid) AS avg_payment
FROM bill_data
GROUP BY area_type;
-- Insight: Helps see payment differences in lifestyle/region.

---------------------------------------------------------
-- 3. Average payment by AC ownership
---------------------------------------------------------
SELECT 
    CASE WHEN is_ac = 1 THEN 'Has AC' ELSE 'No AC' END AS ac_status,
    AVG(amount_paid) AS avg_payment
FROM bill_data
GROUP BY ac_status;
-- Insight: AC households tend to have higher payments.

---------------------------------------------------------
-- 4. Payment ratio (amount_paid / income) by income bucket
---------------------------------------------------------
SELECT 
    CASE 
        WHEN ave_monthly_income < 10000 THEN 'Low (<10k)'
        WHEN ave_monthly_income < 25000 THEN 'Mid (10–25k)'
        ELSE 'High (≥25k)'
    END AS income_bucket,
    AVG(amount_paid/ave_monthly_income) AS avg_payment_ratio
FROM bill_data
GROUP BY income_bucket
ORDER BY avg_payment_ratio DESC;
-- Insight: Lower-income families may spend higher share on bills.

---------------------------------------------------------
-- 5. Top 5 households with highest payment-to-income ratio
---------------------------------------------------------
SELECT 
    num_rooms, num_people, ave_monthly_income, amount_paid,
    ROUND(amount_paid/ave_monthly_income, 3) AS payment_ratio
FROM bill_data
ORDER BY payment_ratio DESC
LIMIT 5;
-- Insight: Spot financially stressed households.

---------------------------------------------------------
-- 6. Average payment by family size bucket
---------------------------------------------------------
SELECT 
    CASE 
        WHEN num_people <= 2 THEN 'Small (1–2)'
        WHEN num_people <= 4 THEN 'Medium (3–4)'
        ELSE 'Large (5+)' END AS family_size,
    AVG(amount_paid) AS avg_payment
FROM bill_data
GROUP BY family_size
ORDER BY avg_payment DESC;
-- Insight: Bigger families tend to have higher payments.

---------------------------------------------------------
-- 7. Appliance combinations (AC + TV) and their avg payments
---------------------------------------------------------
SELECT 
    CASE 
        WHEN is_ac = 1 AND is_tv = 1 THEN 'AC + TV'
        WHEN is_ac = 1 AND is_tv = 0 THEN 'AC only'
        WHEN is_ac = 0 AND is_tv = 1 THEN 'TV only'
        ELSE 'None' END AS appliance_combo,
    AVG(amount_paid) AS avg_payment
FROM bill_data
GROUP BY appliance_combo;
-- Insight: Households with both AC + TV spend the most.

---------------------------------------------------------
-- 8. Correlation check: Does bigger house area mean higher bills?
---------------------------------------------------------
SELECT 
    ROUND(CORR(housearea, amount_paid), 3) AS correlation_area_payment
FROM bill_data;
-- Insight: Positive correlation suggests larger homes = higher bills.

---------------------------------------------------------
-- 9. Top 5 largest houses and their payments
---------------------------------------------------------
SELECT 
    housearea, num_rooms, num_people, amount_paid
FROM bill_data
ORDER BY housearea DESC
LIMIT 5;
-- Insight: Large houses → see if payment aligns with size.

---------------------------------------------------------
-- 10. Average children count vs payment
---------------------------------------------------------
SELECT 
    num_children,
    AVG(amount_paid) AS avg_payment
FROM bill_data
GROUP BY num_children
ORDER BY num_children;
-- Insight: Families with more kids may have higher bills.
