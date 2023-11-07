drop table if exists TestMax;
CREATE TABLE TestMax (
    Year1 INT,
    Max1 INT,
    Max2 INT,
    Max3 INT
);
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87),
    (2002,103,19,88),
    (2003,21,23,89),
    (2004,27,28,91);

-----
select Year1, iif(max1>max2 and max1>max3, max1,iif(max2>max1 and max2>max3,max2,iif(max3>max1 and max3>max2,max3,null))) MaxVak from TestMax
-----
select Year1, case
				when max1>max2 and max1>max3 then max1
				when max2>max1 and max2>max3 then max2
				when max3>max1 and max3>max2 then max3
			else null end maxval
from testmax
-----
select year1, max(maxval) as maxval from (
select Year1, max1, max2, max3 from testmax) as a
unpivot(
maxval for maxcoulmn in (max1,max2,max3)
) as unp
group by year1
----
select year1, max(maxval) as maxval 
from(
select year1,max1 as maxval from testmax
union all
select year1,max2 as maxval from testmax
union all 
select year1, max3 as maxval from testmax
) a
group by year1
----
;with cte as(
select year1,max1 as maxval from testmax
union all
select year1,max2 as maxval from testmax
union all 
select year1, max3 as maxval from testmax
) select year1, max(maxval) from cte
group by year1