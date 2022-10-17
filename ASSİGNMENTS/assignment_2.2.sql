---assignment_2.2---
/* 
Conversion Rate
Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements 
given by an E-Commerce company. Write a query to return the conversion rate for each Advertisement type.
   a.Create above table (Actions) and insert values,
   b.Retrieve count of total Actions and Orders for each Advertisement Type,
   c.Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.
*/


--**a**--Create above table (Actions) and insert values,
--create Actions table
CREATE TABLE Actions(
                    [Visitor_ID] INT PRIMARY KEY  NOT NULL,
                    [Adv_Type] VARCHAR(10),
                    [Action ] VARCHAR(10)
                    );

--insert values
INSERT INTO Actions(Visitor_ID, Adv_Type, Action ) 
VALUES 
(1,'A','Left'),
(2,'A','Order'),
(3,'B','Left'),
(4,'A','Order'),
(5,'A','Review'),
(6,'A','Left'),
(7,'B','Left'),
(8,'B','Order'),
(9,'B','Review'),
(10,'A','Review');


--controll table and values
select *
from Actions

--**b**--Retrieve count of total Actions and Orders for each Advertisement Type,

--total_count
SELECT Adv_Type,COUNT(Visitor_ID) total_count
FROM Actions
GROUP by Adv_Type

--create new wiew named total_count
CREATE VIEW total_count
AS
SELECT Adv_Type,COUNT(Visitor_ID) total_count
FROM Actions
GROUP by Adv_Type


--total_order
SELECT Adv_Type,COUNT(Visitor_ID) total_order 
FROM Actions
WHERE Action = 'order'
GROUP BY Adv_Type


--create new wiew named total_order
CREATE VIEW total_order
AS
SELECT Adv_Type,COUNT(Visitor_ID) total_order 
FROM Actions
WHERE Action = 'order'
GROUP BY Adv_Type


--control wiew tables
select *
from total_count

select *
from total_order



--**c**--Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.
SELECT A.Adv_Type, ROUND(CAST(B.total_order as float) / A.total_count, 2,1) Conversion_Rate
FROM total_count A, total_order B
WHERE A.Adv_Type =B.Adv_Type


----****-----other method-----****----

SELECT A.Adv_Type,ROUND((order_action*1.0/total_action*1.0),2) as Conversion_Rate
FROM (SELECT Adv_Type,COUNT([Action]) AS order_action
FROM Actions
WHERE Action = 'Order'
GROUP BY [Adv_Type]) A
JOIN
(SELECT Adv_Type,COUNT([Action]) as total_action
FROM actions
GROUP BY [Adv_Type]) B
ON A.Adv_Type = B.Adv_Type

----****-----other method-----****----

SELECT Adv_Type, CAST(1.0*SUM(ISNUMERIC(ISNULL(NULLIF([Action], 'Order'),1))) / COUNT(Adv_Type) AS NUMERIC (3,2)) as Conversion_Rate
FROM Actions
GROUP BY Adv_Type

----****-----other method-----****----

SELECT Actions.Adv_Type, CAST(SUM(IIF(Actions.Action = 'Order', 1, 0))/CAST(COUNT(*) AS NUMERIC(4,2)) AS NUMERIC(4,2)) as Conversion_Rate FROM Actions
GROUP BY Actions.Adv_Type;

----****-----other method-----****----
SELECT * INTO #TABLE1
FROM
( VALUES 			
				(1,'A', 'Left'),
				(2,'A', 'Order'),
				(3,'B', 'Left'),
				(4,'A', 'Order'),
				(5,'A', 'Review'),
				(6,'A', 'Left'),
				(7,'B', 'Left'),
				(8,'B', 'Order'),
				(9,'B', 'Review'),
				(10,'A', 'Review')
			) A (visitor_id, adv_type, actions)
WITH T1 AS
(
SELECT	adv_type, COUNT (*) cnt_action
FROM	#TABLE1
GROUP BY
		adv_type
), T2 AS
(
SELECT	adv_type, COUNT (actions) cnt_order_actions
FROM	#TABLE1
WHERE	actions = 'Order'
GROUP BY
		adv_type
)
SELECT	T1.adv_type, CAST (ROUND (1.0*T2.cnt_order_actions / T1.cnt_action, 2) AS numeric (3,2)) AS Conversion_Rate
FROM	T1, T2
WHERE	T1.adv_type = T2.adv_type
