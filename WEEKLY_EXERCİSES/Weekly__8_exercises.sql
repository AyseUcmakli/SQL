---- RDB&SQL Exercise-2 Student

----1. By using view get the average sales by staffs and years using the AVG() aggregate function
--wiew kullanarak, AVG() toplama iþlevini kullanarak personele ve yýllara göre ortalama satýþlarý alýn.

SELECT *
FROM sale.staff

SELECT *
FROM sale.orders

SELECT *
FROM sale.order_item

SELECT DISTINCT A.staff_id, B.order_date,C.*, SUM(C.quantity)
FROM sale.staff A , sale.orders B,sale.order_item C
WHERE A.staff_id = B.staff_id
AND B.order_id  = C.order_id
GROUP BY 
GROUPING SETS(
             (A.staff_id , B.order_date),
			 (A.staff_id ),
			 ( B.order_date),
			 ()
);



SELECT DISTINCT A.staff_id, B.order_date,AVG(C.quantity) AS AVG_SALES
FROM sale.staff A , sale.orders B,sale.order_item C
WHERE A.staff_id = B.staff_id
AND B.order_id  = C.order_id
GROUP BY A.staff_id, B.order_date
ORDER BY A.staff_id











----2. Select the annual amount of product produced according to brands (use window functions).
----2. Markalara göre üretilen yýllýk ürün miktarýný seçin (WÝNDOW fonksiyonlarýný kullanýn).
--https://towardsdatascience.com/a-guide-to-advanced-sql-window-functions-f63f2642cbf9--

SELECT *
FROM product.brand

SELECT *
FROM product.product

SELECT *
FROM product.stock

--ÇÖZÜM

SELECT DISTINCT A.brand_name, B.model_year, SUM(C.quantity) OVER(PARTITION BY B.model_year ORDER BY A.brand_name) AS annual_amount
FROM product.brand A,product.product B, product.stock C
WHERE A.brand_id =B.brand_id
AND B.product_id =C.product_id


--trials--
SELECT DISTINCT A.brand_name,  B.model_year ,SUM(C.quantity) AS SUM_COUNT
FROM product.brand A,product.product B, product.stock C
WHERE A.brand_id =B.brand_id
AND B.product_id =C.product_id
GROUP BY --A.brand_name,  B.model_year
  GROUPING SETS(
             (A.brand_name ,B.model_year),
			 (A.brand_name ),
			 (B.model_year),
			 ()
);



----3. Select the least 3 products in stock according to stores.
--Maðazalara göre stokta bulunan en az olan 3 ürünü seçin.
SELECT *
FROM sale.store

SELECT *
FROM product.stock

SELECT *
FROM product.product
----
SELECT A.store_id, A.store_name, B.product_name, C.quantity
INTO #temp_quantity_table
FROM sale.store A, product.stock C, product.product B
WHERE A.store_id = C.store_id
AND C.product_id = B.product_id
AND quantity = 1
ORDER BY A.store_id, C.quantity ASC
SELECT TOP 3 * FROM #temp_quantity_table WHERE store_id=1
UNION
SELECT TOP 3 * FROM #temp_quantity_table WHERE store_id=2
UNION
SELECT TOP 3 * FROM #temp_quantity_table WHERE store_id=3
---

--WITH T1 AS
--( SELECT A.product_id,B.product_name,A.store_id,SUM(A.quantity) OVER(PARTITION BY A.product_id,A.store_id) as amount_in_store
--FROM product.stock A,product.product B WHERE A.product_id = B.product_id ),T2 AS
--(SELECT *,ROW_NUMBER() OVER(PARTITION BY store_id ORDER BY amount_in_store) AS rank_store
--FROM T1
--WHERE amount_in_store <> 0)
--SELECT *
--FROM T1,T2
--WHERE T1.store_id = T2.store_id
--AND T2.rank_store IN (1,2,3)


---
SELECT store_id, product_name, TotalQuantity
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY store_id ORDER BY store_id, TotalQuantity) AS RowNumber
    FROM(SELECT store_id, s.product_id, product_name, SUM(quantity) as TotalQuantity
         FROM product.stock AS s JOIN product.product AS p ON s.product_id=p.product_id
           GROUP BY store_id, s.product_id, product_name
             HAVING SUM(quantity) > 0) AS SUBQ1) AS SUBQ2
WHERE RowNumber BETWEEN 1 AND 3;



----4. Return the average number of sales orders in 2020 sales
-- her günün ortalama sipariþ sayýsý
SELECT AVG(num_ord) Avg_numoforder_perday
FROM
		(
		SELECT	COUNT(order_id) num_ord, order_date
		FROM	sale.orders
		WHERE	YEAR(order_date) = 2020
		GROUP BY
				order_date
		) A


----

		SELECT *
FROM
		(
		SELECT	count(order_id) as num_ord, DATENAME(DW, order_date) ORDER_WEEKDAY
		FROM	sale.orders
		WHERE	YEAR(order_date)=2020
		GROUP BY DATENAME(DW, order_date)
		) A
PIVOT
(
	avg(num_ord)
	FOR	ORDER_WEEKDAY
	IN ( [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday],[Sunday])
) AS PVT_TBL

----5. Assign a rank to each product by list price in each brand and get products with rank less than or equal to three.
SELECT *
FROM(SELECT *, DENSE_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) AS [rank]
       FROM product.product) AS SUBQ1
WHERE [rank] <= 3;


---the other method

