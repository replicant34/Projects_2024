/*
Problem #1
Find out which museums are open on the weekends
*/

select * 
from museum_hours hours1
where day = 'Saturday'
and exists (select 1 from museum_hours hours2
			where hours1.museum_id = hours2.museum_id
            and hours2.day = 'Sunday')
            
/*
As a result we extracted all museums from the table which work on the weekends
*/