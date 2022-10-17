
----------- ADVANCE GROUPÝNG OPERATÝONS--------------

--having--


--Product tablosunda birden fazla satýrda bulunan product id deðeri olup olmadýðýný kontrol ediniz.
--HAVING ÝLE AGGREGATE ETTÝÐÝMÝZ SÜTUNA FÝLTRELEME YAPIYORUZ!
--HAVING’DE KULLANDIÐIN SÜTUN, AGGREGATE TE KULLANDIÐIN SÜTUN ÝSMÝYLE AYNI OLMALI!

--Write a query that checks if any product id is repeated in more than one row in the product table.
--tekrar eden product_id deðeri var mý

SELECT	product_id, COUNT(*) AS cnt_prod_id
FROM	product.product
GROUP BY
		product_id
HAVING
		COUNT(*) > 1  -- having ile 1 den büyük deger var mý? yani unique deger var mý diye bakacaðýz.

SELECT product_id, COUNT(product_id)
FROM product.product
GROUP BY 
        product_id
HAVING 
        COUNT(product_id) > 1 -- buradan 

--producttaki tüm satýrlarý sayalým
SELECT COUNT(*) AS cnt_prod_id
FROM product.product

--1	NAME	BRAND	CATEGORY	MODEL	
--1	NAM		BR		CAT			MOD	
--1	N		B		C			M


SELECT	product_name, COUNT(*) AS cnt_prod_name
FROM	product.product
GROUP BY
		product_name
HAVING
		COUNT(*) > 1



--Write a query that returns category ids with a maximum list price above 4000 or a minimum list price below 500.
SELECT	category_id, MAX(list_price) MAX_PRC, MIN(list_price) MIN_PRC
FROM	product.product
GROUP BY 
		category_id
HAVING
		MAX(list_price) > 4000 
		OR 
		MIN(list_price) < 500


SELECT category_id, MIN(list_price) AS min_price, MAX(list_price) AS max_price 
-- Grupladýðýmýz þey "category_id" olduðu için SELECT'te onu getiriyoruz. Group By'da Select'te yazdýðýn sütunlar muhakkak olmalý.
FROM product.product
-- ana tablo içinde herhangi bir kýsýtlamam var mý yani WHERE iþlemi var mý? yok. O zaman Group By ile devam ediyorum.
-- Ana tablo içinde herhangi bir kýsýtlama yapmayacaksan WHERE satýrý kullanmayacaksýn demektir.
GROUP BY
          category_id
HAVING
          MIN(list_price) < 500 
	OR 
	MAX(list_price) > 4000;
--GROUP BY ve aggregate neticesinde çýkan tabloyu yukardaki conditionlara göre filtreleyip getirdik. HAVING’in yaptýðý iþ budur.
-- Dikkat! soruyu iyi okumalýsýn. soruda “veya” dediði için OR kullandýk.
-- and koþul

--SELECT	category_id, MAX(list_price) MAX_PRC, MIN(list_price) MIN_PRC
--FROM	product.product
--GROUP BY 
--		category_id
--HAVING
--		MAX(list_price) > 4000 AND MIN(list_price) < 500




--SELECT	category_id, MAX(list_price) MAX_PRC, MIN(list_price) MIN_PRC
--FROM	product.product
--GROUP BY 
--		category_id
--HAVING
--		(MAX(list_price) > 4000 
--		OR 
--		MIN(list_price) < 500)
--		AND
--		MODEL_YEAR < 2020




--Find the average product prices of the brands.
--As a result of the query, the average prices should be displayed in descending order.

SELECT	B.brand_name, AVG(list_price) AVG_PRC_BY_BRND
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
GROUP BY
		B.brand_name
ORDER BY 
		AVG_PRC_BY_BRND DESC


--Write a query that returns BRANDS with an average product price of more than 1000.
SELECT brand_name, AVG(list_price) avg_prc_by_brnd
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
GROUP BY 
         B.brand_name
HAVING 
         AVG(list_price) > 1000
ORDER BY 
         avg_prc_by_brnd DESC


---Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)
--ürün baþýna ödenen net miktar
select *, quantity*list_price*(1-discount) net_amount
from sale.order_item

select order_id, SUM(quantity*list_price*(1-discount))  net_amount
from sale.order_item


SELECT order_id,SUM(quantity*list_price*(1-discount))
FROM [sale].[order_item] 
GROUP BY order_id

--Her bir state' in aylýk sipariþ sayýsý
SELECT[state], YEAR(B.order_date) ORD_YEAR, MONTH(B.order_date) ORD_MONTH
FROM sale.customer  A, sale.orders B
WHERE A.customer_id = B.customer_id
GROUP BY [state], YEAR(B.order_date),MONTH(B.order_date)
ORDER BY [state], ORD_YEAR, ORD_MONTH


SELECT	order_id, order_date, YEAR(ORDER_DATE) ORD_YEAR, MONTH(order_date) ORD_MONTH
FROM	sale.orders


---SUMMARY TABLE

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary
FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year


--GROUPING SETS

--Ayný sorguda hem markalara ait net amount bilgisini, 
--Kategorilere ait net amount bilgisini
--Tüm veriye ait net amout bilgisini,
--Marka ve kategori kýrýlýmýnda net amount bilgisini getiriniz.

SELECT	Brand, Category, SUM(total_sales_price) net_amount
FROM	sale.sales_summary
GROUP BY
		GROUPING SETS (
						(Brand),
						(category),
						(),
						(Brand, Category)
						)
ORDER BY 1



---ROLLUP
SELECT	Brand, Category, SUM(total_sales_price) net_amount
FROM	sale.sales_summary
GROUP BY
		ROLLUP(Brand, Category)
ORDER BY 2


---CUBE

SELECT	Brand, Category, SUM(total_sales_price) net_amount
FROM	sale.sales_summary
GROUP BY
		CUBE(Brand, Category)
ORDER BY 2




SELECT	Brand, Category, model_year, SUM(total_sales_price) net_amount
FROM	sale.sales_summary
GROUP BY
		CUBE(Brand, Category, Model_Year)
ORDER BY 2
