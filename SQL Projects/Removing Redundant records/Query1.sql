WITH cte AS (
    SELECT *, 
           CONCAT(SKU_1, SKU_2, SKU_3) AS ID,
           CASE 
               WHEN SKU_1 < SKU_2 THEN CONCAT(SKU_1, SKU_2, SKU_3) 
               ELSE CONCAT(SKU_2, SKU_1, SKU_3) 
           END AS Sorted_ID
    FROM `SQL Projects`.`sample_dataset`
),
cte_rn AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Sorted_ID ORDER BY Sorted_ID) AS rn
    FROM cte
)
SELECT *
FROM cte_rn;
WHERE rn = 1