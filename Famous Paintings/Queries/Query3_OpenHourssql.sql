/*
Problem #1.2
Find a museum with the longest open hours
*/

SELECT *
     , STR_TO_DATE(open, '%h:%i:%p') AS open_time
     , STR_TO_DATE(close, '%h:%i:%p') AS close_time
     , TIMEDIFF(STR_TO_DATE(close, '%h:%i:%p'), STR_TO_DATE(open, '%h:%i:%p')) AS duration
     , RANK() OVER (ORDER BY TIMEDIFF(STR_TO_DATE(close, '%h:%i:%p'), STR_TO_DATE(open, '%h:%i:%p')) DESC) AS `rank`
FROM museum_hours;

