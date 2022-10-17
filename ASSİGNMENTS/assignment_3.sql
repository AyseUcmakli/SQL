

------------------DISCOUNT EFFECTS-------------
--Generate a report including product IDs and discount effects on whether the increase in the 
--discount rate positively impacts the number of orders for the products.

--In this assignment, you are expected to generate a solution using SQL with a logical approach. 

--Sample Result:
--Product_id	   Discount Effect
--1	                  Positive
--2	                  Negative
--3                   Negative
--4	                  Neutral

--SOLUTION:
--Ýndirim oranýný artýrmak sipariþ sayýsýna nasýl etki etmiþ ?
--Discount rate arttýkça sipariþ verilen product quantity de artmýþ mý?



--buradan bir numaralý ürün ile ilgili sipariþ bilgisinin olmadýðýný gördük.
select * 
from sale.order_item 
where product_id = 1

--burayý incelediðimizde her sipariþin sipariþ  miktarýnýn farklý olduðunu 
--ayný zamanda indirim oranýnýnda þipariþ sayýsý ile anlamlý bir iliþki içinde olmadýðýný gördük.
SELECT DISTINCT B.product_id, B.product_name, C.order_id, C.quantity, C.discount
FROM  product.product B, sale.order_item C
WHERE B.product_id = C.product_id
GROUP BY  B.product_id, B.product_name, C.order_id, C.quantity, C.discount


--ürünlerin indirimlere göre sipariþ sayýsýný hesapladýk.
SELECT DISTINCT  A.product_id, discount, SUM(quantity) OVER(PARTITION BY A.product_id, discount ORDER BY discount)as num_ordr_each_discnt
FROM product.product A
JOIN sale.order_item B
ON A.product_id =B.product_id

--ürünlerin indirim oranlarýnýný arttýkça (ilk ve son fiyatlarý baz alýnarak ) satýlan ürün miktarýnýn deðiþimine göre bir sýnýflama yaptýk.
-- normalde her indirim  aralýðýnda farklý sonuçlar almamýza ragmen ilk ve son deðerleri baz aldýðýmýz için çok saðlýklý bir sonuç elde edemedik. 

WITH T1 AS
     (
		SELECT DISTINCT  A.product_id, discount, SUM(quantity) OVER(PARTITION BY A.product_id, discount ORDER BY discount)as num_ordr_each_discnt
		FROM product.product A
		JOIN sale.order_item B
		ON A.product_id =B.product_id
       )
SELECT DISTINCT T1.product_id,
		CASE 
			WHEN LAST_VALUE(num_ordr_each_discnt) OVER(PARTITION BY product_id ORDER BY discount) > FIRST_VALUE(num_ordr_each_discnt) OVER(PARTITION BY product_id ORDER BY T1.discount) THEN 'Positive'
			WHEN LAST_VALUE(num_ordr_each_discnt) OVER(PARTITION BY product_id ORDER BY discount) < FIRST_VALUE(num_ordr_each_discnt) OVER(PARTITION BY product_id ORDER BY T1.discount) THEN 'Negative'
			WHEN LAST_VALUE(num_ordr_each_discnt) OVER(PARTITION BY product_id ORDER BY discount) = FIRST_VALUE(num_ordr_each_discnt) OVER(PARTITION BY product_id ORDER BY T1.discount) THEN 'Neutral' 
		END AS Discount_Effect
FROM T1
ORDER BY 1
------
--þimdi ise indirimlerin oranýna göre bir karþýlaþtýrma yapalým.böylece ilk veridekinden daha iyi bir sonuç elde edebiliriz.

WITH T1 AS
(
SELECT DISTINCT  A.product_id,discount, SUM(quantity) OVER(PARTITION BY A.product_id, discount ORDER BY discount)as num_ordr_each_discnt
FROM product.product A
JOIN sale.order_item B
ON A.product_id =B.product_id
),T2 AS
(
SELECT *,
		CASE
			WHEN discount = 0.05 THEN   FIRST_VALUE(num_ordr_each_discnt) OVER (PARTITION BY product_id ORDER BY discount)
			WHEN discount = 0.07 THEN   LAG(num_ordr_each_discnt) OVER (PARTITION BY product_id ORDER BY discount)
			WHEN discount = 0.10 THEN   LAG(num_ordr_each_discnt) OVER (PARTITION BY product_id ORDER BY discount)
			WHEN discount = 0.20 THEN   LAG(num_ordr_each_discnt) OVER (PARTITION BY product_id ORDER BY discount)
        END AS prev_discnt
FROM T1
) 


SELECT *,
		CASE
			WHEN discount = 0.05 THEN  'Uninterpretable'
			WHEN prev_discnt < num_ordr_each_discnt  THEN   'Pozitive'
			WHEN prev_discnt > num_ordr_each_discnt  THEN   'Negative'
			WHEN prev_discnt = num_ordr_each_discnt  THEN   'Neutral'
		END AS Discount_Effect
FROM T2



----------THE OTHER SOLUTIONS--
-----1)
WITH T1 AS
(
SELECT product_id, discount, SUM(quantity) total_quantity
FROM	sale.order_item
GROUP BY	
		product_id, discount
), T2 AS
(
SELECT	product_id, discount, total_quantity,
		FIRST_VALUE(total_quantity) OVER (PARTITION BY product_id ORDER BY discount) AS first_dis_quantity,
		LAST_VALUE(total_quantity) OVER (PARTITION BY product_id ORDER BY discount ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_dis_quantity
FROM	T1
), T3 AS
(
SELECT	*,  1.0 * (last_dis_quantity - first_dis_quantity) / first_dis_quantity AS increase_rate
FROM	T2
)
SELECT	product_id,
		CASE WHEN	increase_rate BETWEEN -0.10 AND 0.10 THEN 'NEUTRAL'
			WHEN	increase_rate > 0.10 THEN 'POSITIVE'
			ELSE	'NEGATIVE'
		END	AS discount_affect
FROM	T3


-----2)
WITH T1 AS
(
SELECT DISTINCT product_id, discount,
	SUM(quantity) qty_per_discount,
	LEAD(SUM(quantity)) OVER (PARTITION BY product_id ORDER BY discount) other_disc_qty
FROM sale.order_item
GROUP BY product_id, discount
), T2 AS
(
SELECT product_id, qty_per_discount, other_disc_qty,
	CASE
		WHEN (other_disc_qty - qty_per_discount) > 0 THEN 1
		WHEN (other_disc_qty - qty_per_discount) < 0 THEN -1
		ELSE 0
		END AS diff_qty
FROM T1
)
SELECT product_id, SUM(diff_qty) qty_difference,
	CASE
		WHEN SUM(diff_qty) > 0 THEN 'POSITIVE'
		WHEN SUM(diff_qty) < 0 THEN 'NEGATIVE'
		ELSE 'NEUTRAL'
	END AS discount_effect
FROM T2
GROUP BY product_id











