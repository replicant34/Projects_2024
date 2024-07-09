/*
Problem #1.2
Find out which museums are open on the weekends
And specify museum and location
*/

SELECT m.name AS museum_name, m.city
FROM museum_hours hours1
JOIN museum m ON m.museum_id = hours1.museum_id
WHERE hours1.day = 'Saturday'
AND EXISTS (
    SELECT 1
    FROM museum_hours hours2
    WHERE hours1.museum_id = hours2.museum_id
    AND hours2.day = 'Sunday'
);
            
/*
As a result we extracted all museums from the table which work on the weekends
*/