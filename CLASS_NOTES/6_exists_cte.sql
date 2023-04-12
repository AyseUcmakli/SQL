
--EXISTS komutu, belirtilen bir alt sorguda herhangi bir veri varl���n� test etmek i�in kullan�l�r.
--WHERE blo�unda kullanm�� oldu�umuz IN ifadesinin kullan�m�na benzer olarak, EXISTS ve NOT EXISTS 
--ifadeleri de alt sorgudan getirilen de�erlerin i�erisinde bir de�erin olmas� veya olmamas� durumunda i�lem yap�lmas�n� sa�lar.
--EXISTS: alt sorguda istenilen �artlar�n yerine getirildi�i durumlarda ilgili kayd�n listelenmesini sa�lar.
--NOT EXITS : EXISTS�in tam tersi olarak alt sorguda istenilen �artlar�n sa�lanmad��� durumlarda ilgili kayd�n listelenmesini sa�lar


--Write a query that returns a list of States where 'Apple - Pre-Owned iPad 3 - 32GB - White' product is not ordered
--'Apple - �kinci El iPad 3 - 32GB - Beyaz' �r�n�n�n sipari� edilmedi�i Durumlar�n listesini d�nd�ren bir sorgu yaz�n

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
--sorgu bo� d�nd�.��nk� i� sorgu �al��t� ve NOT EXISTS i�in d�� sorgu �al��mad�


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

 --customer tablosundan state'leri getiren bir sorgumuz var fakat gelecek olan state'ler WHERE k�sm�ndaki ko�ula g�re listelenecek.
--Buna g�re: NOT EXIST kulland���m�z i�in; product_name de�eri 'Apple - Pre-Owned iPad 3...' DE��L �SE ilgilli state listelenecektir. 

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

--EXIST kulland���n zaman; subquery herhangi bir sonu� d�nd�r�rse �stteki query'i �ALI�TIR anlam�na geliyor.
--NOT EXIST ; subquery herhangi bir sonu� d�nd�r�rse �stteki query'i �ALI�TIRMA anlam�na geliyor.
--IN & NOT IN'den farkl� olarak EXIST & NOT EXIST'te query ile subquery'i join etmemiz gerekiyor.




--Write a query that returns stock information of the products in Davi techno Retail store.
--The BFLO Store hasn't  got any stock of that products
--Davi techno Retail ma�azas�ndaki �r�nlerin stok bilgilerini d�nd�ren bir sorgu yaz�n.
--BFLO Ma�azas�nda bu �r�nlerin sto�u yok.

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



-- SLACK ��Z�M..
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
--COMMON TABLE ESPRESSIONS (CTE), ba�ka bir SELECT, INSERT, DELETE veya UPDATE deyiminde ba�vurabilece�iniz 
--veya i�inde kullanabilece�iniz ge�ici bir sonu� k�mesidir.
--Ba�ka bir SQL sorgusu i�inde tan�mlayabilece�iniz bir sorgudur. Bu nedenle, di�er sorgular CTE'yi bir tablo gibi kullanabilir.
--CTE, daha b�y�k bir sorguda kullan�lmak �zere yard�mc� ifadeler yazmam�z� sa�lar.



---------- Query Time --------------
-- List customers who have an order prior to the last order of a customer
-- named Jerald Berray and are residents of Austin.
-- Jerald Berray isimli m��terinin son sipari�inden �nce sipari� vermi�
--ve Austin �ehrinde ikamet eden m��terileri listeleyin.


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
--Laurel Goldammer ile ayn� g�n sipari� veren m��teriler.


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


--CTE, Subquery mant��� ile ayn�. Subquery'de i�erde bir tablo ile ilgileniyorduk CTE'de yukarda yaz�yoruz.
--Sadece WITH k�sm�n� yazarsan tek ba��na �al��maz. WITH ile belirtti�im query'yi birazdan kullanaca��m demek bu.  As�l SQL statementimin i�inde bunu kullan�yoruz.
--WITH ile yukarda tablo olu�turuyor, a�a��da da SELECT FROM ile bu tabloyu kullan�yor (
--Recursive CTE mant��� Python'daki Recursive  Functionlar ile ayn�. CTE'nin i�inde CTE'nin kendisini kullan�yoruz.


----RECURSIVE CTE's

--create a table with a number in each row

W�TH T1 AS
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
--�DEV

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


--+SUBQUERY TEK B�R S�TUN D�ND�REB�L�R ..�K� VE DAHA FAZLA S�TUNDA HATA VER�R.



