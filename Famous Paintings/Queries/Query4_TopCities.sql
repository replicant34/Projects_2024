/*
Problem #3
Find the most attractive museum wise city and contry, which contain the most museums
*/

WITH cte_country AS (
    SELECT country, COUNT(1) AS country_count
         , RANK() OVER (ORDER BY COUNT(1) DESC) AS country_rnk
    FROM museum
    GROUP BY country
),
cte_city AS (
    SELECT city, COUNT(1) AS city_count
         , RANK() OVER (ORDER BY COUNT(1) DESC) AS city_rnk
    FROM museum
    GROUP BY city
)
SELECT cte_country.country, cte_city.city
FROM cte_country
CROSS JOIN cte_city
WHERE cte_country.country_rnk = 1
  AND cte_city.city_rnk = 1;
