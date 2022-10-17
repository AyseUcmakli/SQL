

----SET OPERATORS 

---------UNION

----UNION & UNION ALL deyimi iki veya daha fazla sorgunun sonu�lar�n� birle�tirmek i�in kullan�r�z.
--Bu iki veya daha fazla sorgu sonucu olu�an de�erler tek bir tablo �zerinde return edilir.
----UNION & UNION ALL deyimi tamamen iki benzer tablonun ilgili kolonlar�n� birle�tirmek i�in kullan�l�r.
----UNION & UNION ALL kullan�rken dikkat! : listelenecek kolonlar�n ayn� t�rde, birbiri ile uygun t�rde veri tiplerine sahip olmas� gerekiyor.
----INTERSECT: UNION gibi iki SELECT ifadesini birle�tirmek i�in kullan�yoruz, ancak INTERSECT ifadesinin d�nd�rd��� veri k�mesi, 
--iki SELECT ifadesinin veri k�melerinin kesi�imi olacakt�r.
----Yani INTERSECT deyimi yaln�zca her iki SELECT deyiminde ortak sat�rlar� d�nd�r�r.


--List the products sold in the cities of Charlotte and Aurora
--103
SELECT	DISTINCT D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Aurora'
UNION
--75
SELECT	DISTINCT D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Charlotte'

--Write a query that returns all customers whose  first or last name is Thomas.  (don't use 'OR')
--Union, UNIQUE de�erleri almad�. Hem isimden hem de soyisimden Thomas'� yakalayan  bir kayd� yaln�z bir kere ge�irdi.

SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'

UNION

SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Thomas'



SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'

UNION ALL

SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Thomas'


---------- INTERSECT
--- Write a quary that returns all brands with products for both 2018 and 2020 model year.
SELECT DISTINCT B.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE model_year = 2018
AND A.brand_id= B.brand_id

INTERSECT

SELECT DISTINCT B.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE model_year = 2020
AND A.brand_id= B.brand_id

----
SELECT DISTINCT B.brand_id, B.brand_name, model_year
FROM product.product A, product.brand B
WHERE model_year = 2018
AND A.brand_id= B.brand_id

INTERSECT

SELECT DISTINCT B.brand_id, B.brand_name, model_year
FROM product.product A, product.brand B
WHERE model_year = 2020
AND A.brand_id= B.brand_id
--YUKARIDAK� QUERY DE BO� SONUC GEL�R..��NK� KES���M BO� OLACAK. MODEL_YEAR LAR FARKLI OLDU�U ���N KE����M YOK.


-- Write a query that returns the first and the last names of the customers who placed orders in all of 2018, 2019, and 2020.
-- 2018,2019 ve 2020 de �R�N sipari� vermi� m��teriler
SELECT DISTINCT A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND YEAR(B.order_date) = 2018
INTERSECT
SELECT DISTINCT A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND YEAR(B.order_date) = 2019
INTERSECT
SELECT DISTINCT A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND YEAR(B.order_date) = 2020

---THE OTHER METHOD
SELECT	customer_id, first_name, last_name
FROM	sale.customer
WHERE	customer_id IN (
						SELECT	DISTINCT customer_id
						FROM	sale.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'
						INTERSECT
						SELECT	DISTINCT customer_id
						FROM	sale.orders
						WHERE	order_date BETWEEN '2019-01-01' AND '2019-12-31'
						INTERSECT
						SELECT	DISTINCT customer_id
						FROM	sale.orders
						WHERE	order_date BETWEEN '2020-01-01' AND '2020-12-31'
						)



------ EXCEPT
---EXCEPT, iki farkl� sql sorgusundan birinin sonu� k�mesinde olup di�erinin sonu� k�mesinde olmayan kay�tlar� listeleyen bir komuttur.
--Write a query that returns the brands have 2018 model products but not 2019 model products.

SELECT	DISTINCT B.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	model_year = 2018
AND		A.brand_id = B.brand_id	
EXCEPT
SELECT	DISTINCT B.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	model_year = 2019
AND		A.brand_id = B.brand_id

-- Write a query that contains only products ordered in 2019 (Result not include products ordered in other years)

SELECT A.product_id, A.product_name
FROM product.product A, sale.orders B, sale.order_item C
WHERE YEAR(B.order_date) = 2019
AND A.product_id = C.product_id
AND C.order_id = B.order_id

EXCEPT

SELECT A.product_id, A.product_name
FROM product.product A, sale.orders B, sale.order_item C
WHERE YEAR(B.order_date) <> 2019
AND A.product_id = C.product_id
AND C.order_id = B.order_id

--OTHER METHOD
WITH T1 AS
(
SELECT	DISTINCT A.product_id
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
AND		YEAR(B.order_date) = 2019
EXCEPT
SELECT	DISTINCT A.product_id
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
AND		YEAR(B.order_date) <> 2019
)
SELECT	A.product_id, A.product_name
FROM	T1, product.product A
WHERE	T1.product_id = A.product_id

-------
--(
--SELECT	DISTINCT A.product_id
--FROM	sale.order_item A, sale.orders B
--WHERE	A.order_id = B.order_id
--AND		YEAR(B.order_date) = 2019

--EXCEPT

--SELECT	DISTINCT A.product_id
--FROM	sale.order_item A, sale.orders B
--WHERE	A.order_id = B.order_id
--AND		YEAR(B.order_date) <> 2019
--)

--UNION ALL
--(
--SELECT	DISTINCT A.product_id
--FROM	sale.order_item A, sale.orders B
--WHERE	A.order_id = B.order_id
--AND		YEAR(B.order_date) = 2019

--EXCEPT

--SELECT	DISTINCT A.product_id
--FROM	sale.order_item A, sale.orders B
--WHERE	A.order_id = B.order_id
--AND		YEAR(B.order_date) <> 2019
--)


---CASE
--SIMPLE CASE EXP.
---- Create  a new column with the meaning of the  values in the Order_Status column. 
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT	order_id, order_status,
		CASE order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			ELSE 'Completed'
		END AS ord_status_mean
FROM	sale.orders

--SEARCH CASE EXP

--CASE ile kar��la�t�rma yapmak : CASE deyimi ile kar��la�t�rma da yapabiliriz.
--�rne�in seyehat bilgilerinin yer ald��� bir tablomuz olsun. Seyahat bilgilerinden bir s�tunda otelde kalma s�resi di�er
--bir s�tunda yolda ge�ecek s�re olsun. Bu iki s�tundan hangisi b�y�k veya hangisi k���k oldu�unu se�ip ayr� bir 
--kolonda t�pk� yeni bir s�tun gibi g�sterebiliriz.
--SELECT VacationHours, SickLeaveHours, 
--             CASE 
--                   WHEN VacationHours > SickLeaveHours THEN VacationHours     
--            ELSE SickLeaveHours 
--            END AS 'B�y�k De�er' 
--FROM HumanResources.Employee



---- Create  a new column with the meaning of the  values in the Order_Status column.
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
SELECT	order_id, order_status,
		CASE
			WHEN order_status = 1 THEN 'Pending'
			WHEN order_status = 2 THEN 'Processing'
			WHEN order_status = 3 THEN 'Rejected'
			ELSE 'Completed'
		END AS ord_status_mean
FROM	sale.orders


-- Create a new column that shows which email service provider ("Gmail", "Hotmail", "Yahoo" or "Other" )

SELECT first_name, last_name, email,
	CASE
		WHEN email LIKE '%gmail.com' THEN 'Gmail'
		WHEN email LIKE '%yahoo.com' THEN 'Yahoo'
		WHEN email LIKE '%hotmail.com' THEN 'Hotmail'
		ELSE 'Other'
	END AS email_service_provider
FROM sale.customer


----homework---
-- If you have extra time you can ask following question.
-- Write a query that gives the first and last names of customers who have ordered products from the computer accessories,
--speakers, and mp4 player categories in the same order.
--Bilgisayar aksesuarlar�ndan �r�n sipari� eden m��terilerin ad ve soyadlar�n� veren bir sorgu yaz�n,
--hoparl�rler ve mp4 oynat�c� kategorileri ayn� s�rada.

 with T1 as (
            SELECT b.order_id,d.first_name,d.last_name,
                    sum(CASE WHEN  category_name= 'Computer Accessories' THEN 1 ELSE 0 END ) AS ctg1,
                    sum(CASE WHEN  category_name= 'mp4 player' THEN 1 ELSE 0 END ) AS ctg2,
                    sum(CASE WHEN  category_name= 'Speakers' THEN 1 ELSE 0 END ) AS ctg3
            FROM product.product a, sale.order_item b, sale.orders c, sale.customer d , product.category e
            WHERE a.product_id = b.product_id 
            and b.order_id = c.order_id 
            and c.customer_id = d.customer_id
            and a.category_id = e.category_id 
            group by b.order_id,d.first_name, d.last_name
            )
            SELECT order_id,first_name, last_name
            FROM T1
            WHERE ctg1>=1 and ctg2>=1  and ctg3>=1 
			

SELECT *
FROM sale.customer

SELECT *
FROM sale.orders

SELECT *
FROM sale.order_item

SELECT*
FROM product.product

SELECT*
FROM product.category

SELECT A.first_name, A.last_name,D.product_name,E.category_id
FROM sale.customer A, sale.orders B, sale.order_item C, product.product D,product.category E
WHERE A.customer_id =B.customer_id
AND B.order_id = C.order_id
AND C.product_id =D.product_id
AND D.category_id = E.category_id
AND E.category_name= 'Computer Accessories' 


WITH T1 AS
         (  SELECT A.first_name, A.last_name,D.product_name,E.category_id
			FROM sale.customer A, sale.orders B, sale.order_item C, product.product D,product.category E
			WHERE A.customer_id =B.customer_id
			AND B.order_id = C.order_id
			AND C.product_id =D.product_id
			AND D.category_id = E.category_id
			AND E.category_name= 'Computer Accessories' 
		  ) 
select 
      sum(CASE WHEN  product_name = 'mp4 player' THEN 1 ELSE 0 END ) AS 
      sum(CASE WHEN  product_name = 'Speakers' THEN 1 ELSE 0 END ) AS 
FROM T1 
  
---  

 with T1 as (
            SELECT b.order_id,d.first_name,d.last_name,
                    sum(CASE WHEN  category_name= 'Computer Accessories' THEN 1 ELSE 0 END ) AS ctg1,
                    sum(CASE WHEN  category_name= 'mp4 player' THEN 1 ELSE 0 END ) AS ctg2,
                    sum(CASE WHEN  category_name= 'Speakers' THEN 1 ELSE 0 END ) AS ctg3
            FROM product.product a, sale.order_item b, sale.orders c, sale.customer d , product.category e
            WHERE a.product_id = b.product_id 
            and b.order_id = c.order_id 
            and c.customer_id = d.customer_id
            and a.category_id = e.category_id 
            group by b.order_id,d.first_name,d.last_name
            )
            SELECT first_name, last_name
            FROM T1
            WHERE ctg1>=1 and ctg2>=1  and ctg3>=1 




--Write a query that returns count of the orders day by day in a pivot table format that has been shipped two days later.

SELECT	
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Sunday' THEN 1 ELSE 0 END ) AS Sunday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Monday' THEN 1 ELSE 0 END )AS Monday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Tuesday' THEN 1 ELSE 0 END )AS Tuesday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS Wednesday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Thursday' THEN 1 ELSE 0 END )AS Thursday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS Friday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Saturday' THEN 1 ELSE 0 END )AS Saturday
FROM	sale.orders
WHERE	DATEDIFF (DAY, order_date, shipped_date) >2


---THE OTHER METHOD---
select DISTINCT(DATENAME(DW,order_date)) day_name,
CASE 
WHEN DATENAME(DW,order_date) = 'Monday' THEN (SELECT COUNT(order_id) FROM sale.orders WHERE DATENAME(DW,order_date) = 'Monday')
WHEN DATENAME(DW,order_date) = 'Friday' THEN (SELECT COUNT(order_id) FROM sale.orders WHERE DATENAME(DW,order_date) = 'Friday')
WHEN DATENAME(DW,order_date) = 'Saturday' THEN (SELECT COUNT(order_id) FROM sale.orders WHERE DATENAME(DW,order_date) = 'Saturday')
WHEN DATENAME(DW,order_date) = 'Sunday' THEN (SELECT COUNT(order_id) FROM sale.orders WHERE DATENAME(DW,order_date) = 'Sunday')
WHEN DATENAME(DW,order_date) = 'Thursday' THEN (SELECT COUNT(order_id) FROM sale.orders WHERE DATENAME(DW,order_date) = 'Thursday')
WHEN DATENAME(DW,order_date) = 'Tuesday' THEN (SELECT COUNT(order_id) FROM sale.orders WHERE DATENAME(DW,order_date) = 'Tuesday')
WHEN DATENAME(DW,order_date) = 'Wednesday' THEN (SELECT COUNT(order_id) FROM sale.orders WHERE DATENAME(DW,order_date) = 'Wednesday')
END as count_of_orders
from sale.orders
WHERE shipped_date = DATEADD(DAY,2,order_date)


