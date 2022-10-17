---joins--


SELECT  A.product_name, A.category_id,
        B.category_id, B.category_name
FROM product.product AS A
INNER JOIN 
    product.category AS B
ON A.category_id = B.category_id
ORDER BY
    A.category_id

SELECT  A.product_name, A.category_id,
        B.category_id, B.category_name
FROM product.product A,
    product.category B
WHERE A.category_id = B.category_id
ORDER BY
    A.category_id

----list employees of stores with their store information

select *
from sale.store

select *
from sale.staff

select A.first_name,A.last_name,B.store_name
from sale.staff as A,sale.store as B
where A.store_id=B.store_id

---other method

SELECT first_name, last_name, store_name
FROM sale.staff
INNER JOIN sale.store
ON sale.staff.store_id = sale.store.store_id
ORDER BY sale.staff.store_id


--Write a query that returns streets. The third character of the streets is numerical.
--street s�tununda soldan ���nc� karakterin rakam oldu�u kay�tlar� getiriniz.

select street
from sale.customer

select street, SUBSTRING(street, 3,1) as third_char---SUBSTRING(street, 3,1) 3.karakterden ba�la bir karakter getir demek
from sale.customer
WHERE ISNUMERIC(SUBSTRING(street, 3,1)) =1

select street, SUBSTRING(street, 3,1) as third_char, ISNUMERIC(SUBSTRING(street, 3,1)) isnumerical
from sale.customer
WHERE ISNUMERIC(SUBSTRING(street, 3,1)) 


------ LEFT JOIN ------

-- Write a query that returns products that have never been ordered
--Select product ID, product name, orderID

SELECT *
FROM product.product


SELECT * 
FROM sale.orders


SELECT * 
FROM sale.order_item



SELECT	A.product_id, B.order_id, A.product_name
FROM	product.product A
		LEFT JOIN
		sale.order_item B
		ON	A.product_id = B.product_id
WHERE	order_id IS NULL
ORDER BY B.product_id


--Report the stock status of the products that product id greater than 310 in the stores.
--PRODUCT_�D S� 310DAN B�Y�K OLANLARIN STOK B�LG�S�.
--Expected columns: Product_id, Product_name, Store_id, quantity


SELECT COUNT (DISTINCT product_id)
FROM product.stock
WHERE	product_id > 310



SELECT COUNT (DISTINCT product_id)
FROM product.product
WHERE	product_id > 310



SELECT	A.product_id, B.*
FROM	product.product A
		LEFT JOIN 
		product.stock B
		ON	A.product_id = B.product_id
WHERE	A.product_id > 310



--SELECT	A.product_id, B.*
--FROM	product.product A
--		LEFT JOIN 
--		product.stock B
--		ON	A.product_id = B.product_id
--WHERE	B.product_id > 310


------ RIGHT JOIN ------

--Report (AGAIN WITH RIGHT JOIN) the stock status of the products that product id greater than 310 in the stores.


SELECT	A.product_id, B.*
FROM	product.stock A
		RIGHT JOIN 
		product.product B
		ON	A.product_id = B.product_id
WHERE	B.product_id > 310


--//////

---Report the orders information made by all staffs.
--t�m �al��anlar�n sipari� bilgisini getir.
--Expected columns: Staff_id, first_name, last_name, all the information about orders

select *
from sale.staff

select *
from sale.orders


SELECT *
FROM	sale.staff



SELECT	COUNT (DISTINCT staff_id)
FROM	sale.orders

SELECT A.staff_id, A.first_name, A.last_name, B.*
FROM sale.staff A
     RIGHT JOIN 
	 sale.orders B
	 ON A.staff_id = B.staff_id
ORDER BY 4


--burada 4 ki�i hi� sat�� yapmam��.
SELECT	A.staff_id, B.order_id
FROM	sale.staff A
		LEFT JOIN
		sale.orders B
		ON	A.staff_id = B.staff_id
ORDER BY 2
--


------ FULL OUTER JOIN ------

--Write a query that returns stock and order information together for all products . (TOP 100)
--Expected columns: Product_id, store_id, quantity, order_id, list_price




SELECT COUNT (DISTINCT product_id)
FROM	product.product

SELECT COUNT (DISTINCT product_id)
FROM	product.stock

SELECT COUNT (DISTINCT product_id)
FROM	sale.order_item


SELECT	DISTINCT A.product_id, A.product_name, B.product_id, C.product_id
FROM	product.product A
		FULL OUTER JOIN 
		product.stock B
		ON	A.product_id = B.product_id
		FULL OUTER JOIN
		sale.order_item C
		ON A.product_id = C.product_id
ORDER BY B.product_id, C.product_id


SELECT	DISTINCT A.product_id, A.product_name, B.*, C.product_id
FROM	product.product A
		FULL OUTER JOIN 
		product.stock B
		ON	A.product_id = B.product_id
		FULL OUTER JOIN
		sale.order_item C
		ON A.product_id = C.product_id
ORDER BY B.product_id, C.product_id


------ CROSS JOIN ------

/*
In the stocks table, there are not all products held on the product table and you 
want to insert these products into the stock table.
You have to insert all these products for every three stores with �0� quantity.
Write a query to prepare this data.

*/
--443 numaral�yeni �r�n� her 3 ma�azaya da eklemek...
/*
1	443
2	443
3	443
1	444
2	444
3	444
*/


SELECT	DISTINCT A.store_id, B.product_id, 0 as quantity
FROM	product.stock A
		CROSS JOIN
		product.product B
WHERE	B.product_id NOT IN (SELECT product_id FROM product.stock)



---
SELECT *, 0 AS quantitative
FROM (SELECT DISTINCT product_id FROM  product.product) AS A
      CROSS JOIN 
(SELECT DISTINCT store_id FROM product.stock) AS B
WHERE A.product_id NOT IN (select product_id from product.stock)


------ SELF JOIN ------

--Write a query that returns the staffs with their managers.
--Expected columns: staff first name, staff last name, manager name

SELECT	A.*, B.staff_id, B.first_name, B.last_name
FROM	sale.staff A, sale.staff B
WHERE	A.manager_id = B.staff_id
 


SELECT	A.*, B.staff_id, B.first_name, B.last_name
FROM	sale.staff A
		LEFT JOIN 
		sale.staff B
		ON	A.manager_id = B.staff_id

--Hem staff'ler hem manager'ler ayn� sales.staffs tablosu i�indeler.
--Bu tablo kendi kendine ili�ki i�erisinde. bu tabloda iki tane s�tun birbiri ile ayn� bilgiyi ta��yor.
--Burda staff_id ile manager_id birbiri ile ili�ki i�inde. her staff'in bir manageri var ve bu manager ayn� zamanda bir staff..
--Mesela staff_id si 2 olan Charles'�n manager_id'si 1,  yani staff_id'si 1 olan ki�i Charles'�n manageri demektir.

------------------------

--VIEWS


CREATE VIEW v_sample_summary AS
SELECT	A.customer_id, COUNT(B.order_id) cnt_order
FROM	sale.customer A, SALE.orders B
WHERE	A.customer_id = B.customer_id
AND		A.city = 'Charleston'
GROUP BY A.customer_id


SELECT *
FROM	v_sample_summary



--Ge�ici tablo

SELECT	*
INTO	#v_sample_sum_2
FROM	v_sample_summary

--SQL'�N KEND� ���NDEK� ��LEM SIRASI:

--FROM : hangi tablolara gitmem gerekiyor?
--WHERE : o tablolardan hangi verileri �ekmem gerekiyor?
--GROUP BY : bu bilgileri ne �ekilde gruplayay�m?
--SELECT : neleri getireyim ve hangi aggragate i�lemine tabi tutay�m.
--HAVING : yukardaki sorgu sonucu ��kan tablo �zerinden nas�l bir filtreleme yapay�m (mesela list_price>1000)
--Gruplama yapt���m�z ayn� sorgu i�inde bir filtreleme yapmak istiyorsak HAVING kullanaca��z
--HAVING kullanmadan; HAVING'ten yukar�s�n� al�p ba�ka bir SELECT sorgusunda WHERE �art� ile de bu filtrelemeyi yapabiliriz.
--ORDER BY : ��kan sonucu hangi s�ralama ile getireyim? 
--Soruda average veya toplam gibi aggregate i�lemi gerektirecek bir istek varsa hemen "GROUP BY" kullanmam gerekti�ini anlamal�y�m.
--Bir sayma i�lemi, bir grupland�rma bir aggregate i�lemi yap�yorsan isimle de�il ID ile yap. ID'ler her zaman birer defa ge�er (Unique�tir), isimler tekrar edebilir (�r: bir ka� product'a ayn� isim verilmi� olabilir)
--SELECT sat�r�nda yazd���n s�tunlar�n hepsi GROUP BY'da olmas� gerekiyor!
--HAVING ile sadece aggregate etti�imiz s�tuna ko�ul verebiliriz!
--HAVING�de kulland���n s�tun, aggregate te kulland���n s�tunla ayn� olmal�.

select brand_name,avg(list_price) as new
from product.product a, product.brand b
where a.brand_id=b.brand_id
and a.model_year>2016
group by brand_name
having avg(list_price)>1000
order by avg(list_price);

--same method with join
select brand_name,avg(list_price) as new
from product.product a
join product.brand b
on a.brand_id=b.brand_id
and a.model_year>2016
group by brand_name
having avg(list_price)>1000
order by
avg(list_price);




