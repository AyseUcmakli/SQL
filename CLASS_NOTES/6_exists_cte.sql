
--EXISTS komutu, belirtilen bir alt sorguda herhangi bir veri varlýðýný test etmek için kullanýlýr.
--WHERE bloðunda kullanmýþ olduðumuz IN ifadesinin kullanýmýna benzer olarak, EXISTS ve NOT EXISTS 
--ifadeleri de alt sorgudan getirilen deðerlerin içerisinde bir deðerin olmasý veya olmamasý durumunda iþlem yapýlmasýný saðlar.
--EXISTS: alt sorguda istenilen þartlarýn yerine getirildiði durumlarda ilgili kaydýn listelenmesini saðlar.
--NOT EXITS : EXISTS‘in tam tersi olarak alt sorguda istenilen þartlarýn saðlanmadýðý durumlarda ilgili kaydýn listelenmesini saðlar


--Write a query that returns a list of States where 'Apple - Pre-Owned iPad 3 - 32GB - White' product is not ordered
--'Apple - Ýkinci El iPad 3 - 32GB - Beyaz' ürününün sipariþ edilmediði Durumlarýn listesini döndüren bir sorgu yazýn

SELECT  DISTINCT state
FROM	sale.customer X
WHERE	NOT EXISTS (
					SELECT	D.state
					FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
					WHERE	product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
					AND		A.product_id = B.product_id
					AND		B.order_id = C.order_id
					AND		C.customer_id = D.customer_id
					)
--sorgu boþ döndü.çünkü iç sorgu çalýþtý ve NOT EXISTS için dýþ sorgu çalýþmadý


SELECT  DISTINCT state
FROM	sale.customer X
WHERE	NOT EXISTS (
					SELECT	DISTINCT state
					FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
					WHERE	product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
					AND		A.product_id = B.product_id
					AND		B.order_id = C.order_id
					AND		C.customer_id = D.customer_id
					AND		D.state = X.state
					)

 --customer tablosundan state'leri getiren bir sorgumuz var fakat gelecek olan state'ler WHERE kýsmýndaki koþula göre listelenecek.
--Buna göre: NOT EXIST kullandýðýmýz için; product_name deðeri 'Apple - Pre-Owned iPad 3...' DEÐÝL ÝSE ilgilli state listelenecektir. 

SELECT  DISTINCT state
FROM	sale.customer X
WHERE       EXISTS (
					SELECT	DISTINCT state
					FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
					WHERE	product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
					AND		A.product_id = B.product_id
					AND		B.order_id = C.order_id
					AND		C.customer_id = D.customer_id
					AND		D.state = X.state
					)

SELECT  DISTINCT state
FROM	sale.customer X
WHERE	X.state NOT IN  (
							SELECT	State
							FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
							WHERE	product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
							AND		A.product_id = B.product_id
							AND		B.order_id = C.order_id
							AND		C.customer_id = D.customer_id
							)

--EXIST kullandýðýn zaman; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIÞTIR anlamýna geliyor.
--NOT EXIST ; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIÞTIRMA anlamýna geliyor.
--IN & NOT IN'den farklý olarak EXIST & NOT EXIST'te query ile subquery'i join etmemiz gerekiyor.




--Write a query that returns stock information of the products in Davi techno Retail store.
--The BFLO Store hasn't  got any stock of that products
--Davi techno Retail maðazasýndaki ürünlerin stok bilgilerini döndüren bir sorgu yazýn.
--BFLO Maðazasýnda bu ürünlerin stoðu yok.

SELECT A.*
FROM sale.store A, product.stock B
WHERE A.store_name = 'The BFLO Store'
and B.quantity =0


SELECT Y.*
FROM	sale.store X, product.stock Y
WHERE	X.store_id = Y.store_id
AND		x.store_name = 'Davi techno Retail'
AND		EXISTS
			(
			SELECT	1
			FROM	product.stock A, sale.store B
			WHERE	A.store_id= B.store_id
			AND		B.store_name = 'The BFLO Store'
			AND		A.quantity = 0
			AND		Y.product_id = A.product_id
			)
			
--not exists
SELECT	DISTINCT Y.product_id
FROM	sale.store X, product.stock Y
WHERE	X.store_id = Y.store_id
AND		x.store_name = 'Davi techno Retail'
AND		NOT EXISTS
			(
			SELECT	DISTINCT A.product_id
			FROM	product.stock A, sale.store B
			WHERE	A.store_id= B.store_id
			AND		B.store_name = 'The BFLO Store'
			AND		A.quantity > 0
			AND		Y.product_id = A.product_id
			)



-- SLACK ÇÖZÜM..
select store_name, s1.store_id, product_id, quantity
from sale.store s1, product.stock st1
where s1.store_id = st1.store_id 
and store_name = 'Davi techno Retail'
and product_id in ( select product_id from product.stock where store_id = 2)
and not exists (
				select *
				from sale.store s, product.stock st
				where store_name = 'The BFLO Store' 
				and s.store_id = st.store_id 
				and quantity <> 0 
				and st1.product_id = st.product_id
                )

------ CTE's ------

--ORDINARY CTE's
--COMMON TABLE ESPRESSIONS (CTE), baþka bir SELECT, INSERT, DELETE veya UPDATE deyiminde baþvurabileceðiniz 
--veya içinde kullanabileceðiniz geçici bir sonuç kümesidir.
--Baþka bir SQL sorgusu içinde tanýmlayabileceðiniz bir sorgudur. Bu nedenle, diðer sorgular CTE'yi bir tablo gibi kullanabilir.
--CTE, daha büyük bir sorguda kullanýlmak üzere yardýmcý ifadeler yazmamýzý saðlar.



---------- Query Time --------------
-- List customers who have an order prior to the last order of a customer
-- named Jerald Berray and are residents of Austin.
-- Jerald Berray isimli müþterinin son sipariþinden önce sipariþ vermiþ
--ve Austin þehrinde ikamet eden müþterileri listeleyin.


WITH T1 AS
(
SELECT	MAX(order_date) last_order_date
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id
AND		A.first_name= 'Jerald'
AND		A.last_name = 'Berray'
)
SELECT	DISTINCT A.customer_id, A.first_name, A.last_name
FROM	sale.customer A, sale.orders B, T1
WHERE	A.customer_id = B.customer_id
AND		T1.last_order_date > B.order_date
AND		A.city = 'Austin'



-- List all customers their orders are on the same dates with Laurel Goldammer.
--Laurel Goldammer ile ayný gün sipariþ veren müþteriler.


WITH T1 AS
(SELECT order_date
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Laurel'
AND A.last_name = 'Goldammer'
)
SELECT DISTINCT A.customer_id, A.first_name, A.last_name, B.order_date
FROM sale.customer A, sale.orders B, T1
WHERE A.customer_id = B.customer_id
AND T1.order_date = B.order_date



WITH T1 AS
(
SELECT B.order_date laurels_order_dates
FROM sale.customer A, sale.orders B
WHERE A.first_name = 'Laurel' AND A.last_name = 'Goldammer'
AND A.customer_id = B.customer_id
), T2 AS
(
SELECT DISTINCT A.customer_id, A.first_name, A.last_name, B.order_date
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
)
SELECT *
FROM	T1, T2
WHERE	T1.laurels_order_dates = T2.order_date


--CTE, Subquery mantýðý ile ayný. Subquery'de içerde bir tablo ile ilgileniyorduk CTE'de yukarda yazýyoruz.
--Sadece WITH kýsmýný yazarsan tek baþýna çalýþmaz. WITH ile belirttiðim query'yi birazdan kullanacaðým demek bu.  Asýl SQL statementimin içinde bunu kullanýyoruz.
--WITH ile yukarda tablo oluþturuyor, aþaðýda da SELECT FROM ile bu tabloyu kullanýyor (
--Recursive CTE mantýðý Python'daki Recursive  Functionlar ile ayný. CTE'nin içinde CTE'nin kendisini kullanýyoruz.


----RECURSIVE CTE's

--create a table with a number in each row

WÝTH T1 AS
(
    SELECT 0 AS NUMBER
	UNION ALL 
	SELECT NUMBER +1
	FROM T1
	WHERE NUMBER < 9
)
SELECT *
FROM T1;


--Write a query that returns all staff with their manager_ids. (Use Recursive CTE)
--ÖDEV

--List the stores whose turnovers are under the average store turnovers in 2018.
WITH T1 AS
(
SELECT	C.store_name, SUM (quantity*list_price*(1-discount)) turnover_of_stores
FROM	sale.order_item A, sale.orders B, sale.store C
WHERE	A.order_id = B.order_id
AND		B.store_id = C.store_id
AND		YEAR (B.order_date) = 2018
GROUP BY
		C.store_id, C.store_name
) , T2 AS
(
SELECT	 AVG(turnover_of_stores) avg_turnover_2018
FROM	 T1
)
SELECT *
FROM	T1, T2
WHERE	T1.turnover_of_stores > T2.avg_turnover_2018


--Subquery in SELECT Statement

--Write a quary that creates a new column named "total price" calculating the total prices of the products on each order.

SELECT order_id, 
		(
			SELECT SUM(list_price)
			FROM	sale.order_item A
			WHERE	A.order_id = B.order_id
		)
FROM	sale.orders B




SELECT DISTINCT  order_id, 
		(
			SELECT SUM(list_price)
			FROM	sale.order_item A
			WHERE	A.order_id = B.order_id
		)
FROM	sale.orders B


--+SUBQUERY TEK BÝR SÜTUN DÖNDÜREBÝLÝR ..ÝKÝ VE DAHA FAZLA SÜTUNDA HATA VERÝR.



