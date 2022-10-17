


-----------------------------------W�NDOW FUNCT�ONS------------------------------- 

--->Window Function ile Group by aras�ndaki fark 
--->Window Function types 
--->Window Function syntax and Keywords
--->Window Frames
--->How to apply Window Function

--birden �ok sorguda elde edebilce�imiz agg de�erlerini tek bir sorguda elde ediyoruz sadece agg i�lemlerinde de�il sat�rlara numaralnad�rma i�lemi de yap�yor.
--s�ralanm�� sat�r de�erleri aras�ndan istedi�imizi alabiliyoruz.
--bize sa�lad��� esnekli�in temel sebebi group by gibi gruplama yapmay�p, gruplama yap�ld�ktan sonraki de�erleri sat�rlar�n kar��na getiriyor.
--Asl�nda bize bir pencere a��yor.Tablonun yap�s�n� bozmuyor.
--window Function i�inde order yap�labiliyor.
--Performans a��s�ndan ise [Group by] da grouplanm�� i�lemleri arkada temporary table olarak tutuyor ve onun �zerinden i�lemler yap�yor
--Fakat WF tablonun yap�s�nda herhangi de�i�iklik yapmad��� i�in daha h�zl� sonu� alabiliyoruz



--GROUP BY--> distinct kullanm�yoruz, distinct'i zaten kendi i�inde yap�yor
--Window Funct.--> optioanal olarak yapabiliyoruz.
--GROUP BY -->  aggregate mutlaka gerekli,
--Window Funct.> aggregate optional
--GROUP BY --> Ordering invalid
--Window Funct.--> ordering valid
--GROUP BY --> performans� d���k
--Window Funct.--> performansl�

--WINDOW FUNCTION:
--Veri setinde mevcut sat�rla bir �ekilde ili�kili olan bir dizi sat�rda bir i�lem ger�ekle�tirmemizi sa�lar.
--Group by fonksiyonundan farkl� olarak di�er sat�rlardaki verileri de hesaplamaya dahil edebiliriz.
--Hareketli ortalama-k�m�latif toplam gibi i�lemleri bu fonksiyonlarla grup baz�nda kolayca yapabiliriz.

--WINDOW FUNCTIONlarda
--3 farkl� bile�en kullan�l�r;
--PARTITION BY : Veriyi gruplara ay�r�r. Opsiyoneldir.
--ORDER BY : Her bir grup i�in sat�rlar�n s�ralamas�n� yapmay� sa�lar. Zorunludur.
--ROW_veya_RANGE : Veri gruplar�n�n t�m verisi ile de�il belirli bir alandaki verileri i�in hesaplama yapabilmemizi sa�lar. 
--�zellikle hareketli ortalama hesaplayabilmek i�in �ok kullan��l�d�r. Opsiyoneldir.

--Hepsi Current Row'a kadar olan b�l�m� grupluyor.
--Unbounded Preceding (�ncesi s�n�rland�r�lmam��):  current row'a kadar olan b�l�mde fonksiyonu uygula.
--Unbounded Following (sonras� s�n�rland�r�lmam��) : current row'dan sonuna kadar olan b�l�mde fonksiyonu uygula.


--�ki tip WINDOW fonksiyonu tan�mlanm��t�r.
-- Ranking Window Functions
--  Aggregate Window Functions



---Differences with WF & Group by
-----Write a query that returns the total stock amount of each product in the stock table.

--->>Group by 
SELECT product_id ,SUM(quantity) TOTAL_QUANT�TY
FROM product.stock
GROUP BY 
        product_id
ORDER BY  1


---yukar�daki query ile ayn� sonucu almak i�in dist�nct kullanabiliriz.
---->>WF
SELECT product_id ,
                 SUM(quantity) OVER (PARTITION BY product_id) TOTAL_QUANT�TY
FROM product.stock

SELECT DISTINCT product_id ,
                 SUM(quantity) OVER (PARTITION BY product_id) TOTAL_QUANT�TY
FROM product.stock


-- GROUP BY DAK� G�B� S�TUN KISITLAMASI YOK..
SELECT * ,
                 SUM(quantity) OVER (PARTITION BY product_id) TOTAL_QUANT�TY
FROM product.stock
 

------->>>>Types of WindowFunction(Analytic functions)
---->>Analaytic Aggregate functions--MIN()--MAX()--SUM()--AVG()--COUNT()
---->>Analytic Navigation Functions--FIRST_VALUE()--LAST_VALUE()--LEAD()--LAG()
---->>Analytic Numbering Functions--ROW_NUMBER()--RANK()--DENSE_RANK()--NT�LE()--PERCENT_RANK()

---SYNTAX:
/*
SELECT {COLUMNS}, FUNCTION() OVER(PARTITION By .... ORDER BY...WINDOW FRAME) --baz� durumlarda order by zorunlu olacak.
FROM TABLE1;
*/
--Window frame; yazmak zorunda de�iliz default u : UNBOUNDED PRECEDING AND CURRENT ROW
--rows between ....1 PRECED�NG AND CURRENT ROW
--range between .... 
--ROW_veya_RANGE : Veri gruplar�n�n t�m verisi ile de�il belirli bir alandaki verileri i�in hesaplama yapabilmemizi sa�lar.
-- �zellikle hareketli ortalama hesaplayabilmek i�in �ok kullan��l�d�r. Opsiyoneldir.

PARTITION 
UNBOUNDED PRECEDING --(�ncesi s�n�rland�r�lmam��):  current row'a kadar olan b�l�mde fonksiyonu uygula.
-->N PRECEDING
.
. 
-->CURRENT ROW 
. 
. 
-->M FOLLOWING 
UNBOUNDED FOLLOWING --(sonras� s�n�rland�r�lmam��) : current row'dan sonuna kadar olan b�l�mde fonksiyonu uygula.

--ex. 1 PRECEDING AND 1 FOLLOWING --> CURRENT ROW 1. SATIR OLSUN 1. SATIRDAN �NCES� YOK SONRASI 2. SATIR. YAN� ��LEME 1 VE 2. SATIRI DAH�L EDECEK
--daha sonra 2. sat�ra gecti ve 2 den �ncesi 1. sat�r ve 2. sat�rdan sonras� 3. sat�r .yani i�leme 1 2 3 sta�rlar� dahil edecek. Window function sat�r sat�r i�lem yap�yor.
--Hareketli ortalama-k�m�latif toplam gibi i�lemleri bu fonksiyonlarla grup baz�nda kolayca yapabiliriz.


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id

SELECT	DISTINCT brand_id, model_year
		, COUNT(*) OVER() NOTHING --hi�bir gruplama yapmadan t�m sat�rlar� say
		, COUNT(*) OVER(PARTITION BY brand_id)
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year)--k�m�latif i�lem yapt�rd�.
FROM	product.product




SELECT	brand_id, model_year
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year)
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)--DEFAULT FRAME
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM	product.product


--
--BRAND_�D LER� MODEL_YEAR A G�RE K�M�LAT�F TOPLADI.
--�imdiden ba�la bir sonraki k�r�l�ma kadar say.8-20-28-41 �eklinde.. yani k�m�latif olarak
SELECT	brand_id, model_year
		, COUNT (*) OVER(PARTITION BY brand_id ORDER BY model_year RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM	product.product



--�nceden ba�la bir sonraki k�r�l�ma kadar say.yani tamam�n�n toplam�k�r�l�m�n toplam�
--her brand i�in toplam yani 41
SELECT	brand_id, model_year
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	product.product
order by brand_id, model_year
----> ROW �LR RANGE ARASINDAK� FARK ;
--i�lem olarak bir fark yok ama keywordlerle range kullan�yoruz, specific de�er giriyorsak da row function kullan�yoruz.



----bir �nceki ve bir sonraki sat�rlar�n istenen k�r�l�mda toplam�n�  getirir. 
SELECT	brand_id, model_year
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) 
FROM	product.product
order by brand_id, model_year



--------Query Time----------
-- Write a query that returns average product prices of brands. 
SELECT	*,
		AVG(list_price) OVER (PARTITION BY brand_id)
FROM	product.product
 

--OVER i�lemi i�indeki ORDER BY --> window fonksiyonu uygularken dikkate alaca�� order by'd�r.
--Query sonundaki ORDER BY --> SELECT i�lemi neticesindeki sonucun order by'�d�r

--------Query Time----------
-- What is the cheapest product price for each category?
SELECT	DISTINCT category_id,
		MIN (list_price) OVER (PARTITION BY category_id)
FROM	product.product


--------Query Time----------
-- How many different product in the product table?
SELECT DISTINCT
      COUNT(*) OVER() NOTHING
FROM product.product


-- How many different product in the order_item table?
--order_item tablosunda ka� farkl� �r�n var?
SELECT COUNT(product_id)
FROM(
        select distinct product_id 
        FROM sale.order_item
    )A


--Window Function i�inde DISTINCT kullanamazs�n.
--Distinct'li i�lem yapmaz. Ancak Window Function ile d�nen verinin ba��nda (yani SELECT'ten sonra) DISTINCT kullanabilirsin.


--BURADA 4772 4772 KERE GET�RD�
SELECT COUNT (product_id) OVER()
FROM	sale.order_item

--BURADA �SE 4772 SAYISINI TEK B�R SATIRDA GET�R�R
SELECT	DISTINCT COUNT (product_id) OVER()
FROM	sale.order_item

--UN�QUE PRODUCT SAYISINI 307 Y� GET�R�R.
SELECT COUNT (DISTINCT product_id)
from sale. order_item

--UN�QUE PRODUCT SAYISINI 307 Y� GET�R�R.YAN� D�STINCT W�NDOWS FUNS. ���NDE KULLANILMALI
SELECT COUNT (product_id)
FROM (
      SELECT DISTINCT product_id OVER()
      FROM sale. order_item
	  )


-- Write a query that returns how many products are in each order
SELECT DISTINCT order_id,
	SUM(quantity) OVER(partition by order_id) AS total_product
FROM sale.order_item


------ How many different product are in each brand in each category?
SELECT	DISTINCT category_id, brand_id, COUNT (product_id) OVER (PARTITION BY category_id, brand_id)
FROM	product.product
ORDER BY category_id, brand_id


------------------FIRST VALUE FUNCT�ON-------------
--------Query Time----------
--Write a query that returns one of the most stocked product in each store.
SELECT *
FROM	product.stock
ORDER BY
		store_id, quantity DESC

--result
SELECT	DISTINCT store_id,
		FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC)
FROM	product.stock


---product_id DE B�R �NCEK� SATIRDAN ��MD�K� SATIRA KADAR OLAN KISMI GET�R�YOR.
-- YAN� �NCEK� NEYSE ONU GET�RM�� OLUYOR.��NK� CURRENT ROW DAH�L DE��L
SELECT *,
	FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC ROWS BETWEEN 1 PRECEDING AND CURRENT ROW )
FROM product.stock;

---product_id DE  ��MD�K� SATIRDAN SONUNA KADAR  OLAN KISMI GET�R�YOR.
---YAN� HER KIRILIM ���N TOPLAM product_id SAYISINI GET�R�YOR.
SELECT *,
	FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING )
FROM product.stock;


--Write a query that returns customers and their most valuable order with total amount of it.
--M��terileri ve en de�erli sipari�lerini toplam tutar�yla birlikte d�nd�ren bir sorgu yaz�n.
SELECT	A.customer_id, first_name, last_name, B.order_id,
		SUM(quantity*list_price* (1-discount)) total_amount
FROM	sale.customer A, sale.orders B, sale.order_item C
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
GROUP BY
		A.customer_id, first_name, last_name, B.order_id
ORDER BY
		1,5 DESC
--
WITH T1 AS
(
	SELECT	A.customer_id, first_name, last_name, B.order_id,
			SUM(quantity*list_price* (1-discount)) total_amount
	FROM	sale.customer A, sale.orders B, sale.order_item C
	WHERE	A.customer_id = B.customer_id
	AND		B.order_id = C.order_id
	GROUP BY
			A.customer_id, first_name, last_name, B.order_id
)
SELECT	DISTINCT customer_id, first_name, last_name,
		FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY total_amount DESC) most_val_order
		, FIRST_VALUE(total_amount) OVER (PARTITION BY customer_id ORDER BY total_amount DESC) total_amount
FROM	T1


---Write a query that returns first order date by month
---her ay i�in ilk sipari� tarihi
SELECT	DISTINCT YEAR(order_date) year,
		MONTH(order_date) month,
		FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date) first_ord_date
FROM	sale.orders




------------------LAST VALUE FUNCT�ON-------------
--Write a query that returns most stocked product in each store. (Use Last_Value)
SELECT	DISTINCT store_id,
		FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC),--RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		LAST_VALUE (product_id) OVER (PARTITION BY store_id ORDER BY quantity, product_id desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	product.stock
--firSt value ve last value kullanarak ayn� de�eri elde ettik.


SELECT *
FROM	product.stock
ORDER BY
		store_id, quantity asc






------------------LAG() FUNCT�ON-------------(Analytic Navigation Functions)
--RETURNS THE VALUE �N PREV�OUS ROWS FOR EACH ROW OF SORTED COLUMN VALUES.

--------Query Time----------
--Write a query that returns the order date of the one previous sale of each staff (use the LAG function)
--her �al��an�n bir �nceki sipari� tarihi

SELECT A.staff_id, A.first_name,A.last_name, B.order_id, B.order_date
FROM sale.staff A, sale.orders B
WHERE A.staff_id =B.staff_id


SELECT	A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LAG(order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) prev_order_date
FROM	sale.staff A, sale.orders B
WHERE	A.staff_id = B.staff_id  


------------------LEAD() FUNCT�ON-------------(Analytic Navigation Functions)
--RETURNS THE VALUE �N NEXT ROWS FOR EACH ROW OF SORTED COLUMN VALUES.

--Write a query that returns the order date of the one next sale of each staff (use the lead function)
SELECT	A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LEAD (order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) prev_order_date
FROM	sale.staff A, sale.orders B
WHERE	A.staff_id = B.staff_id



----------------------Analytic Numbering Functions--ROW_NUMBER()--RANK()--DENSE_RANK()--NT�LE()--PERCENT_RANK()--------------
-- Ranking Window Functions :
--kay�t seti i�inde derecelendirme fonksiyonlar�d�r. Bunlar:

---------ROW_NUMBER
-- kay�t setinin herbir b�l�m�ne atamak �zere 1 'den ba�layarak s�ral� giden bir say� �retir.

-----------RANK & DENSE_RANK
--RANK fonksiyonu ile b�l�mlendirilmi� kay�t setindeki her bir b�l�me bir rank numaras� verilir.
--Bu kay�t setinde alt b�l�m i�indeki her kay�t ayn� rank numaras�na sahiptir. Bu numaraland�rma yine 1'den ba�lar.
--Ancak ROW_NUMBER fonksiyonunda oldu�u gibi ardarda gelen bir s�raland�rma ile gitmek zorunda de�ildir. 
--Bir b�l�m i�inde birden fazla kay�t varsa rank numaralar�nda atlamalar olacakt�r.

-- ------NTILE
-- NTILE fonksiyonu SELECT ifadenizde WHERE ko�uluna uyan kay�tlar� OVER ve ORDER BY ile belirtilen s�ralamaya
-- g�re dizilmi� �ekilde sizin parametre olarak ge�ece�iniz bir say�ya b�lerek her b�l�me bir s�ra numaras� verir.

---cume_d�st
--degerlerin ne oldugunu de�il de�erlerin hangi sat�rda oldu�unu �nemsiyor.
--oldugu sat�r say�s�n� toplam sat�ra b�l�yoruz.
--CUME_DIST() = row_number/total_rows

--percent_rank
-- bir sat�rdaki degerin o sutun i�inde yuzde kacl�k dilimden dajha b�y�k oldugunu g�steriyor
--yinelenen degerler i�in en kucuk index s�ras�n� al�yoruz
--PERCENT_RANK() = (row_number-1)/(total_rows-1)


--------Query Time----------
--Assign an ordinal number to the product prices for each category in ascending order

select category_id, list_price
from product.product
order by 1,2


select category_id, list_price,
   row_number() over (PARTITION BY category_id order by category_id) as ord_numbr
from product.product

--her kategorideki en d���k �r�n fiyat�n� getir.
SELECT *
FROM(
	SELECT category_id, list_price,
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) as ord_number
FROM product.product
	) A
WHERE ord_number = 1

--her kategorideki en d���k 3 �r�n fiyat�n� getir.
SELECT *
FROM(
		SELECT category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) as ord_number
FROM product.product
	) A
WHERE ord_number < 4

--------RANK vs. DENSE_RANK

SELECT category_id, list_price,
        ROW_NUMBER() OVER( ORDER BY list_price) RN,--ROW_NUMBER s�rayla numaraland�r�r.
		RANK () OVER( ORDER BY list_price) RNK,--RANK SATIR NUMARASINI VER�R. AYNI �IKTILAR  AYNI NUMARA SONRAK� BULUNULAN SATIR NUMARASI.
		DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price) DNS_RNK --DENSE RANK SIRA NUMARASINI VER�R.AYNI �IKTILAR  AYNI NUMARA SONRAK� SIRADAK� SATIR NUMARASI
FROM product.produCt                           


----Assign a rank number and dense_rank number to the product prices for each category in ascending order.
SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY  list_price) AS CAT_PRC_N,
		RANK () OVER (PARTITION BY category_id ORDER BY  list_price) AS PRICE_RANK,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY  list_price) AS PRICE_DENSE_RANK
FROM	Product.product


--Write a query that returns both of the followings:
--Average product price.
--The average product price of orders.
SELECT DISTINCT order_id, 
	AVG(list_price) OVER() avg_price_by_table,
	AVG(list_price) OVER(PARTITION BY order_id) avg_price_by_order
FROM sale.order_item



--Which orders' average product price is lower than the overall average price?
WITH T1 AS
    (
	 SELECT DISTINCT order_id, 
	 AVG(list_price) OVER() avg_price_by_table,
	 AVG(list_price) OVER(PARTITION BY order_id) avg_price_by_order
     FROM sale.order_item
	 )
SELECT *
FROM T1
WHERE avg_price_by_table > avg_price_by_order
ORDER BY
		3 DESC

----THE OTHER METHOD
SELECT * 
FROM
      (         
	    SELECT DISTINCT order_id, AVG(list_price) OVER() as avg_total,
        AVG(list_price) OVER(PARTITION BY order_id) as avg_order
        FROM sale.order_item
		) A
WHERE avg_order < avg_total



--Calculate the stores' weekly cumulative number of orders for 2018
SELECT DISTINCT A.store_id, A.store_name,
       DATEPART( WK, order_date)  week_of_order  , 
       COUNT(order_id) OVER(PARTITION BY A.store_id, DATEPART( WK, order_date) ) cnt_order
FROM sale.store A, sale.orders B
WHERE A.store_id=B.store_id
AND YEAR(order_date)=2018
ORDER BY 1,3
 

SELECT DISTINCT A.store_id, A.store_name,
       DATEPART( WK, order_date)  week_of_order  , 
       COUNT(order_id) over(PARTITION BY A.store_id, DATEPART( WK, order_date) ) cnt_order,
	   COUNT(order_id) over(PARTITION BY A.store_id ORDER BY  DATEPART( WK, order_date)) cum_ord_cnt
FROM sale.store A, sale.orders B
WHERE A.store_id=B.store_id
AND YEAR(order_date)=2018
ORDER BY 1,3


--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'

SELECT *
FROM sale.orders A,  sale.order_item B
WHERE A.order_id =B.order_id
AND order_date BETWEEN '2018-03-12' and '2018-04-12'


--G�NLERE G�RE �R�N SAYILARI
SELECT DISTINCT order_date,
       SUM(quantity) OVER (PARTITION BY order_date) daily_product_cnt
FROM sale.orders A,  sale.order_item B
WHERE A.order_id =B.order_id
AND order_date BETWEEN '2018-03-12' and '2018-04-12'


--
WITH T1 AS
(
SELECT	DISTINCT order_date, 
		SUM(quantity) OVER (PARTITION BY order_date) daily_product_cnt
FROM	sale.orders A, sale.order_item B
WHERE	A.order_date BETWEEN  '2018-03-12' and '2018-04-12'
AND		A.order_id = B.order_id
) 
SELECT	order_date, 
		daily_product_cnt,
		AVG(daily_product_cnt) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
FROM	T1


------


WITH T1 AS
(
SELECT	DISTINCT order_date, 
		SUM(quantity) OVER (PARTITION BY order_date) daily_product_cnt
FROM	sale.orders A, sale.order_item B
WHERE	A.order_date BETWEEN  '2018-03-12' and '2018-04-12'
AND		A.order_id = B.order_id
) 
SELECT	order_date, 
		daily_product_cnt,
		AVG(daily_product_cnt) OVER (ORDER BY order_date ROWS BETWEEN CURRENT ROW AND 6 FOLLOWING)
FROM	T1


WITH T1 AS
(
SELECT	DISTINCT order_date, 
		SUM(quantity) OVER (PARTITION BY order_date) daily_product_cnt
FROM	sale.orders A, sale.order_item B
WHERE	A.order_date BETWEEN  '2018-03-12' and '2018-04-12'
AND		A.order_id = B.order_id
) 
SELECT	order_date, 
		daily_product_cnt,
		AVG(daily_product_cnt) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING)
FROM	T1



----Write a query that returns the highest daily turnover amount for each week on a yearly basis.
with t1 as
		(
		select distinct order_date,
				datepart(week,order_date) [num_week_of_year],
				sum(quantity*list_price*(1-discount)) over (partition by order_date) daily_turnover
		from sale.order_item A,sale.orders B
		where A.order_id = B.order_id
)
select distinct year(order_date) as [year],
		num_week_of_year,
		max(daily_turnover) over(partition by year(order_date),num_week_of_year) highest_dailiy_turnover_of_week
from t1

--List customers whose have at least 2 consecutive orders are not shipped.
--List customers whose orders are not shipped at least 2 consecutive  .

with #t1 as
(
select customer_id,order_date,shipped_date,
case
when shipped_date  is null and ( 
	  lead(shipped_date) over(partition by customer_id order by order_date) is null and
	  lag(shipped_date) over(partition by customer_id order by order_date) is null)
	  then 2 else 0
end as [binary]
from [sale].[orders]
)
select distinct #t1.customer_id,C.first_name,C.last_name,#t1.shipped_date, sum(#t1.[binary]) over (partition by #t1.customer_id) num_of_not_shipped_atleast2_consecutive
from #t1,sale.customer C
where #t1.customer_id = C.customer_id
and #t1.binary <> 0


-----SQL_Scripts_Window_Function
create table employee
( emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);
COMMIT;


select * from employee;

-- Using Aggregate function as Window Function
-- Without window function, SQL will reduce the no of records.
select dept_name, max(salary) max_salary
from employee
group by dept_name;

-- By using MAX as an window function, SQL will not reduce records but the result will be shown corresponding to each record.
select *, max(salary) over(partition by dept_name) as max_salary
from employee ;

-- row_number(), rank() and dense_rank()
--RANK fonksiyonu ile tekrar eden sat�rlara ayn� numaralar verilir ve kullan�lmayan numaralar ge�ilir.
--DENSE_RANK fonksiyonunda ayn� de�ere sahip sat�rlara ayn� de�er veriliyor ama s�ralama algoritmas�nda hi� bir rakam atlanm�yor.
select *, row_number() over(partition by dept_name order by emp_id) as rn
from employee 
;


-- Fetch the first 2 employees from each department to join the company.
select* from
 	 (
	select*,
	row_number() over(partition by dept_name order by emp_id) as rn
	from employee 
	) x
where x.rn < 3;


-- Fetch the top 3 employees in each department earning the max salary.
select * from (
	select e.*,
	rank() over(partition by dept_name order by salary desc) as rnk
	from employee e) x
where x.rnk < 4;


-- Checking the different between rank, dense_rnk and row_number window functions:

select*,
rank() over(partition by dept_name order by salary desc) as rnk,
dense_rank() over(partition by dept_name order by salary desc) as dense_rnk,
row_number() over(partition by dept_name order by salary desc) as rn
from employee;



-- lead and lag

-- fetch a query to display if the salary of an employee is higher, lower or equal to the previous employee.
select e.*,
lag(salary) over(partition by dept_name order by emp_id) as prev_empl_sal,
case when e.salary > lag(salary) over(partition by dept_name order by emp_id) then 'Higher than previous employee'
     when e.salary < lag(salary) over(partition by dept_name order by emp_id) then 'Lower than previous employee'
	 when e.salary = lag(salary) over(partition by dept_name order by emp_id) then 'Same than previous employee' end as sal_range
from employee e;

-- Similarly using lead function to see how it is different from lag.
select e.*,
lag(salary) over(partition by dept_name order by emp_id) as prev_empl_sal,
lead(salary) over(partition by dept_name order by emp_id) as next_empl_sal
from employee e;
