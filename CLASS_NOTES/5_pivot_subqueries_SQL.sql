-----Session 7


---pivot table----

--Question: Write a query using summary table that returns the total turnover from each category by model year. 
--(in pivot table format)


SELECT Category, Model_Year, SUM(total_sales_price) total_amount
FROM sale.sales_summary
GROUP BY
       Category, Model_Year
ORDER BY 1,2


SELECT *
FROM
(
SELECT Category, Model_Year, total_sales_price
FROM sale.sales_summary 
) a
PIVOT
(
SUM(total_sales_price) 
FOR model_year
IN ([2018],[2019],[2020],[2021])  
) pvt_tbl
--

SELECT *
FROM
(
SELECT	Category, Model_Year, total_sales_price
FROM	sale.sales_summary
) A
PIVOT
(
	SUM(total_sales_price)
	FOR model_year
	IN ([2018], [2019], [2020], [2021])
) as pvt_tbl



--Write a query that returns count of the orders day by day in a pivot table format that has been shipped two days later.
--1)
SELECT order_id, order_date,DATEDIFF(DAY, order_date, shipped_date ) ship_date
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date ) >2


--2)
SELECT order_id, order_date, DATENAME(DW, order_date)
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date ) >2


--3)MESELA cuma verilen sipari�leri g�rebiliriz ya da farkl� bir g�n
SELECT order_id,  DATENAME(DW, order_date) 
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date ) >2


--4)
SELECT COUNT(order_id) as order_cnt, DATENAME(DW, order_date) as order_day
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2
GROUP BY
      DATENAME(DW, order_date)


--5)
SELECT *
FROM 
     (
     SELECT order_id,  DATENAME(DW, order_date) ORDER_WEEKDAY
     FROM sale.orders
     WHERE DATEDIFF(DAY, order_date, shipped_date ) >2
	 ) A
PIVOT
(
     COUNT(order_id)
	 FOR ORDER_WEEKDAY
	 IN ( [Monday], [Tuesday],  [Wednesday], [Thursday], [Friday], [Saturday], [Sunday])
) AS pvt_tbl


---- SUBQUER�ES
----Write a query that shows all employees in the store where Davis Thomas works.
--1)
SELECT staff_id
FROM sale.staff
WHERE first_name = 'Davis'
AND last_name = 'Thomas'

--2)
SELECT *
FROM	sale.staff
WHERE	store_id = (SELECT	store_id
					FROM	sale.staff
					WHERE	first_name = 'Davis'
					AND		last_name = 'Thomas')

-- Write a query that shows the employees for whom Charles Cussona is a first-degree manager.
--(To which employees are Charles Cussona a first-degree manager?)
-- Charles Cussona'n�n birinci dereceden y�netici oldu�u �al��anlar� g�steren bir sorgu yaz�n.
--(Charles Cussona hangi �al��anlar i�in birinci derece y�neticidir?)

--1)
SELECT staff_id
FROM sale.staff
WHERE first_name = 'Charles'
AND last_name = 'Cussona'
 


SELECT *
FROM sale.staff
WHERE manager_id =(SELECT staff_id
                   FROM sale.staff
                   WHERE first_name = 'Charles'
                   AND last_name = 'Cussona')




-- Write a query that returns the customers located where �The BFLO Store' is located.
-- 'The BFLO Store' isimli ma�azan�n bulundu�u �ehirdeki m��terileri listeleyin.
SELECT	city
FROM	sale.store
WHERE	 store_name = 'The BFLO Store'



SELECT *
FROM	SALE.customer
WHERE	city = (SELECT	city
				FROM	sale.store
				WHERE	 store_name = 'The BFLO Store')



--Write a query that returns the list of products that are more expensive than the product named 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
--'Pro-Serisi 49-S�n�f� Full HD D�� Mekan LED TV (G�m��)' adl� �r�nden daha pahal� olan �r�nlerin listesini d�nd�ren bir sorgu yaz�n.


SELECT	list_price 
FROM	product.product
WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'

SELECT *
FROM product.product
WHERE list_price > (SELECT	list_price 
                    FROM	product.product
                    WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')


-- Write a query that returns customer first names, last names and order dates.
-- The customers who are order on the same dates as Laurel Goldammer.
SELECT	order_date
FROM	SALE.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		B.first_name = 'Laurel'
and		B.last_name = 'Goldammer'



SELECT	b.first_name, b.last_name , a.order_date
FROM	sale.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		A.order_date = ANY (
							SELECT	order_date
							FROM	SALE.orders A, sale.customer B
							WHERE	A.customer_id = B.customer_id
							AND		B.first_name = 'Laurel'
							and		B.last_name = 'Goldammer'
						)



	
--List the products that ordered in the last 10 orders in Buffalo city.
--1)
SELECT A.order_id
FROM	sale.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND B.city = 'Buffalo' 

--2)
SELECT TOP 10 order_id
FROM	sale.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND B.city = 'Buffalo' 
ORDER BY order_id DESC

--hocan�n ��z�m�
SELECT	TOP 10 order_id
FROM	sale.customer A, sale.orders B
WHERE	a.city= 'Buffalo'
AND		A.customer_id = B.customer_id
ORDER BY
		order_id DESC

SELECT	DISTINCT A.order_id , B.product_name
FROM	sale.order_item A, product.product B
WHERE	order_id IN (
						SELECT	TOP 10 order_id
						FROM	sale.customer A, sale.orders B
						WHERE	a.city= 'Buffalo'
						AND		A.customer_id = B.customer_id
						ORDER BY
								order_id DESC
						)
AND		A.product_id = B.product_id



--Write a query that returns the list of product names that were made in 2020
--and whose prices are higher than maximum product list price of Receivers Amplifiers category.
--Receivers Amplifiers kategorisindeki en y�ksek fiyatl� �r�nden daha pahal� olan 2020 model �r�nleri getiriniz.

--1)
SELECT	list_price
FROM	product.product A, product.category B
WHERE	A.category_id = B.category_id
AND		b.category_name = 'Receivers Amplifiers'
ORDER BY
		list_price DESC

--2)
SELECT *
FROM	product.product
WHERE	model_year = 2020
AND		list_price > ALL (
						SELECT	list_price
						FROM	product.product A, product.category B
						WHERE	A.category_id = B.category_id
						AND		b.category_name = 'Receivers Amplifiers'
						)
					
--2.YOL
SELECT B.product_name, B.model_year, B.list_price
FROM product.category A, product.product B
WHERE A.category_id = B.category_id
AND B.model_year = 2020
AND B.list_price > 
(
SELECT MAX(A. list_price)
FROM product.product A, product.category B
WHERE A.category_id = B.category_id
AND B.category_name = 'Receivers Amplifiers'
)



---EX�STS
--QUERY N�N �ALI�IP CALI�MADI�INI KONTROL,
--QUERY N�N SORGU D�ND�R�P D�ND�RMED���N� YAN� DE�ER �RET�P �RETMED���N� KONTROL
-- 2.DURUM E��TL�K DURUMLARINDA ��ER�DEK� SORGU �LE E��T OLANLARI ��ER DEMEK.

--NOT EX�STS �CER�DEK� SORGU CALI�MIYORSA SONU� GET�R�R






