WITH cte_trail1 AS (
    SELECT 
        t1.Hut1 AS start_hut, 
        h1.Name AS start_hut_name,
        h1.Altitude AS start_hut_altitude, 
        t1.Hut2 AS end_hut
    FROM table2 t1
    JOIN table1 h1 ON t1.Hut1 = h1.ID
),
cte_trail2 AS (
    SELECT 
        t2.*, 
        h2.Name AS end_hut_name, 
        h2.Altitude AS end_hut_altitude,
        CASE 
            WHEN t2.start_hut_altitude > h2.Altitude THEN 1 
            ELSE 0 
        END AS altitude_flag
    FROM cte_trail1 t2
    JOIN table1 h2 ON h2.ID = t2.end_hut
),
cte_final AS (
    SELECT 
        CASE 
            WHEN altitude_flag = 1 THEN start_hut 
            ELSE end_hut 
        END AS start_hut,
        CASE 
            WHEN altitude_flag = 1 THEN start_hut_name 
            ELSE end_hut_name 
        END AS start_hut_name,
        CASE 
            WHEN altitude_flag = 1 THEN end_hut 
            ELSE start_hut 
        END AS end_hut,
        CASE 
            WHEN altitude_flag = 1 THEN end_hut_name 
            ELSE start_hut_name 
        END AS end_hut_name
    FROM cte_trail2
)
SELECT 
    c1.start_hut_name AS start_point,
    c1.end_hut_name AS middle_point,
    c2.end_hut_name AS end_point
FROM cte_final c1
JOIN cte_final c2 ON c1.end_hut = c2.start_hut;

