

--weekly-9
--Answer the following questions according to SampleRetail Database

--Report cumulative total turnover by months in each year in pivot table format.
--Pivot tablo formatýnda her yýl aylara göre kümülatif toplam ciroyu raporlayýn.

SELECT *
FROM
(
SELECT	distinct YEAR (A.order_date) ord_year, MONTH(A.order_date) ord_month,
SUM(quantity*list_price) OVER (PARTITION BY YEAR (A.order_date) ORDER BY YEAR (A.order_date), MONTH(A.order_date)) turnover
FROM	sale.orders A, sale.order_item B
WHERE	A.order_id = B.order_id
) A
PIVOT
(
MAX(turnover)
FOR ord_year
IN ([2018],[2019],[2020])
)
PIVOT_TA





--What percentage of customers purchasing a product have purchased the same product again?
--Bir ürünü satýn alan müþterilerin yüzde kaçý ayný ürünü tekrar satýn aldý?

SELECT *
FROM sale.order_item

SELECT *
FROM sale.orders

SELECT*
FROM sale.customer

---ALTERNATIVE-1

WITH T1 AS
(
SELECT  product_id,
		SUM(CASE WHEN  counts >=2 THEN 1 ELSE 0 END) AS customer_counts ,
		COUNT(customer_id) AS totl_customer
FROM
      (
		SELECT  DISTINCT  b.product_id,  a.customer_id,
		COUNT(a.customer_id) OVER(PARTITION BY b.product_id, a.customer_id ) AS counts
		FROM sale.orders a, sale.order_item b
		WHERE  a.order_id = b.order_id
		) AS X
GROUP BY product_id )
SELECT product_id, CAST(1.0*customer_counts/totl_customer AS NUMERIC(3,2)) per_of_cust_pur
FROM T1;


----- ---ALTERNATIVE-2

SELECT	soi.product_id,
		CAST(1.0*(COUNT(so.customer_id) - COUNT(DISTINCT so.customer_id))/COUNT(so.customer_id) AS DECIMAL(3,2)) per_of_cust_pur
FROM	sale.order_item soi, sale.orders so
		WHERE	soi.order_id = so.order_id		
GROUP BY soi.product_id;



----- From the following table of user IDs, actions, and dates, write a query to return the publication and cancellation rate for each user.
---ALTERNATIVE-1
CREATE TABLE User_Actions (
[User_id] INT NOT NULL,
[Action] VARCHAR(25) NOT NULL,
[Date] DATE NOT NULL
);
--Now inserting the values as below.
INSERT INTO User_Actions(User_id, Action, Date)
VALUES
(1, 'Start', '1-1-22'),
(1, 'Cancel', '1-2-22'),
(2, 'Start', '1-3-22'),
(2, 'Publish', '1-4-22'),
(3, 'Start', '1-5-22'),
(3, 'Cancel', '1-6-22'),
(1, 'Start', '1-7-22'),
(1, 'Publish', '1-8-22')


WITH T1 AS
(
SELECT  User_id, Action, COUNT(Action) cnt_act,
	SUM(COUNT(Action)) OVER (PARTITION BY user_id) total_act_per_id
FROM User_Actions
GROUP BY User_id, Action
)
SELECT User_id, CAST(1.0 * cnt_act / total_act_per_id AS NUMERIC(4,2)) AS publish_rate
FROM T1
WHERE Action = 'Publish'

---let's see all actions' rates
WITH T1 AS
(
SELECT  User_id, Action, COUNT(Action) cnt_act,
	SUM(COUNT(Action)) OVER (PARTITION BY user_id) total_act_per_id
FROM User_Actions
GROUP BY User_id, Action
)
SELECT User_id, Action, CAST(1.0 * cnt_act / total_act_per_id AS NUMERIC(4,2)) AS action_rate
FROM T1

---- now let's get two additional columns to see publish rate and cancel rate seperately for each id.
WITH T1 AS
(
SELECT  User_id, Action, COUNT(Action) cnt_act,
	SUM(COUNT(Action)) OVER (PARTITION BY user_id) total_act_per_id
FROM User_Actions
GROUP BY User_id, Action
), T2 AS
(
SELECT User_id, Action, CAST(1.0 * cnt_act / total_act_per_id AS NUMERIC(4,2)) AS action_rate
FROM T1
)
SELECT DISTINCT User_id,
	CASE WHEN action = 'Publish' THEN action_rate END AS publish_rate,
	CASE WHEN action = 'Cancel' THEN action_rate END AS cancel_rate
FROM T2

--- let's exclude null values to get a better result.
WITH T1 AS
(
SELECT  User_id, Action, COUNT(Action) cnt_act,
	SUM(COUNT(Action)) OVER (PARTITION BY user_id) total_act_per_id
FROM User_Actions
GROUP BY User_id, Action
), T2 AS
(
SELECT User_id, Action, CAST(1.0 * cnt_act / total_act_per_id AS NUMERIC(4,2)) AS action_rate
FROM T1
), T3 AS
(
SELECT DISTINCT User_id,
	CASE WHEN action = 'Publish' THEN action_rate END AS publish_rate,
	CASE WHEN action = 'Cancel' THEN action_rate END AS cancel_rate
FROM T2
)
SELECT *
FROM T3
WHERE publish_rate IS NOT NULL OR cancel_rate IS NOT NULL


---ALTERNATIVE-2
SELECT	soi.product_id,
		CAST(1.0*(COUNT(so.customer_id) - COUNT(DISTINCT so.customer_id))/COUNT(so.customer_id) AS DECIMAL(3,2)) per_of_cust_pur
FROM	sale.order_item soi, sale.orders so
		WHERE	soi.order_id = so.order_id		
GROUP BY soi.product_id

---ALTERNATIVE-3
WITH T1 AS
(
SELECT  product_id,
SUM(CASE WHEN  counts >=2 THEN 1 ELSE 0 END) AS customer_counts ,
COUNT(customer_id) AS totl_customer
FROM
(
SELECT  DISTINCT  b.product_id,  a.customer_id,
COUNT(a.customer_id) OVER(PARTITION BY b.product_id, a.customer_id ) AS counts
FROM sale.orders a, sale.order_item b
WHERE  a.order_id = b.order_id) AS X
GROUP BY product_id )
SELECT product_id, CAST(1.0*customer_counts/totl_customer AS NUMERIC(3,2)) per_of_cust_pur
FROM T1;



----- From the following table of user IDs, actions, and dates, write a query to return the publication and cancellation rate for each user.
------Aþaðýdaki kullanýcý kimlikleri, eylemler ve tarihler tablosundan, her kullanýcý için yayýn ve iptal oranýný döndürmek için bir sorgu yazýn.

CREATE TABLE pubcanx (
					User_id int,
					Action varchar(255),
					Date varchar(255)
					);
--select *
--from pubcan
INSERT INTO pubcanx (User_id, Action, Date)

VALUES

(1,'Start','1-1-20'),
(1,'Cancel','1-2-20'),
(2,'Start','1-3-20'),
(2,'Publish','1-4-20'),
(3,'Start','1-5-20'),
(3,'Cancel','1-6-20'),
(1,'Start','1-7-20'),
(1,'Publish','1-8-20')





-------------
CREATE VIEW View_Ass_2 AS

SELECT	User_id, Start, Publish, Cancel
FROM (
	SELECT
			User_id,
			SUM(CASE WHEN Action = 'Start' THEN 1 ELSE 0 END) AS Start,
			SUM(CASE WHEN Action = 'Publish' THEN 1 ELSE 0 END) AS Publish,
			SUM(CASE WHEN Action = 'Cancel' THEN 1 ELSE 0 END) AS Cancel
	FROM pubcanx
	GROUP BY User_id
	) AS A
;

---------------


SELECT *
FROM pubcanx

select *
from View_Ass_2

SELECT
		User_id,
		CAST((1.0 * Publish / Start) AS NUMERIC(2,1)) AS 'Publish_rate',
		CAST((1.0 * Cancel / Start) AS NUMERIC(2,1)) AS 'Cancel_rate'
FROM View_Ass_2

