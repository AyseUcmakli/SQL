


-----------------------------------WÝNDOW FUNCTÝONS------------------------------- 

--->Window Function ile Group by arasýndaki fark 
--->Window Function types 
--->Window Function syntax and Keywords
--->Window Frames
--->How to apply Window Function

--birden çok sorguda elde edebilceðimiz agg deðerlerini tek bir sorguda elde ediyoruz sadece agg iþlemlerinde deðil satýrlara numaralnadýrma iþlemi de yapýyor.
--sýralanmýþ satýr deðerleri arasýndan istediðimizi alabiliyoruz.
--bize saðladýðý esnekliðin temel sebebi group by gibi gruplama yapmayýp, gruplama yapýldýktan sonraki deðerleri satýrlarýn karþýna getiriyor.
--Aslýnda bize bir pencere açýyor.Tablonun yapýsýný bozmuyor.
--window Function içinde order yapýlabiliyor.
--Performans açýsýndan ise [Group by] da grouplanmýþ iþlemleri arkada temporary table olarak tutuyor ve onun üzerinden iþlemler yapýyor
--Fakat WF tablonun yapýsýnda herhangi deðiþiklik yapmadýðý için daha hýzlý sonuç alabiliyoruz



--GROUP BY--> distinct kullanmýyoruz, distinct'i zaten kendi içinde yapýyor
--Window Funct.--> optioanal olarak yapabiliyoruz.
--GROUP BY -->  aggregate mutlaka gerekli,
--Window Funct.> aggregate optional
--GROUP BY --> Ordering invalid
--Window Funct.--> ordering valid
--GROUP BY --> performansý düþük
--Window Funct.--> performanslý

--WINDOW FUNCTION:
--Veri setinde mevcut satýrla bir þekilde iliþkili olan bir dizi satýrda bir iþlem gerçekleþtirmemizi saðlar.
--Group by fonksiyonundan farklý olarak diðer satýrlardaki verileri de hesaplamaya dahil edebiliriz.
--Hareketli ortalama-kümülatif toplam gibi iþlemleri bu fonksiyonlarla grup bazýnda kolayca yapabiliriz.

--WINDOW FUNCTIONlarda
--3 farklý bileþen kullanýlýr;
--PARTITION BY : Veriyi gruplara ayýrýr. Opsiyoneldir.
--ORDER BY : Her bir grup için satýrlarýn sýralamasýný yapmayý saðlar. Zorunludur.
--ROW_veya_RANGE : Veri gruplarýnýn tüm verisi ile deðil belirli bir alandaki verileri için hesaplama yapabilmemizi saðlar. 
--Özellikle hareketli ortalama hesaplayabilmek için çok kullanýþlýdýr. Opsiyoneldir.

--Hepsi Current Row'a kadar olan bölümü grupluyor.
--Unbounded Preceding (öncesi sýnýrlandýrýlmamýþ):  current row'a kadar olan bölümde fonksiyonu uygula.
--Unbounded Following (sonrasý sýnýrlandýrýlmamýþ) : current row'dan sonuna kadar olan bölümde fonksiyonu uygula.


--Ýki tip WINDOW fonksiyonu tanýmlanmýþtýr.
-- Ranking Window Functions
--  Aggregate Window Functions



---Differences with WF & Group by
-----Write a query that returns the total stock amount of each product in the stock table.

--->>Group by 
SELECT product_id ,SUM(quantity) TOTAL_QUANTÝTY
FROM product.stock
GROUP BY 
        product_id
ORDER BY  1


---yukarýdaki query ile ayný sonucu almak için distýnct kullanabiliriz.
---->>WF
SELECT product_id ,
                 SUM(quantity) OVER (PARTITION BY product_id) TOTAL_QUANTÝTY
FROM product.stock

SELECT DISTINCT product_id ,
                 SUM(quantity) OVER (PARTITION BY product_id) TOTAL_QUANTÝTY
FROM product.stock


-- GROUP BY DAKÝ GÝBÝ SÜTUN KISITLAMASI YOK..
SELECT * ,
                 SUM(quantity) OVER (PARTITION BY product_id) TOTAL_QUANTÝTY
FROM product.stock
 

------->>>>Types of WindowFunction(Analytic functions)
---->>Analaytic Aggregate functions--MIN()--MAX()--SUM()--AVG()--COUNT()
---->>Analytic Navigation Functions--FIRST_VALUE()--LAST_VALUE()--LEAD()--LAG()
---->>Analytic Numbering Functions--ROW_NUMBER()--RANK()--DENSE_RANK()--NTÝLE()--PERCENT_RANK()

---SYNTAX:
/*
SELECT {COLUMNS}, FUNCTION() OVER(PARTITION By .... ORDER BY...WINDOW FRAME) --bazý durumlarda order by zorunlu olacak.
FROM TABLE1;
*/
--Window frame; yazmak zorunda deðiliz default u : UNBOUNDED PRECEDING AND CURRENT ROW
--rows between ....1 PRECEDÝNG AND CURRENT ROW
--range between .... 
--ROW_veya_RANGE : Veri gruplarýnýn tüm verisi ile deðil belirli bir alandaki verileri için hesaplama yapabilmemizi saðlar.
-- Özellikle hareketli ortalama hesaplayabilmek için çok kullanýþlýdýr. Opsiyoneldir.

PARTITION 
UNBOUNDED PRECEDING --(öncesi sýnýrlandýrýlmamýþ):  current row'a kadar olan bölümde fonksiyonu uygula.
-->N PRECEDING
.
. 
-->CURRENT ROW 
. 
. 
-->M FOLLOWING 
UNBOUNDED FOLLOWING --(sonrasý sýnýrlandýrýlmamýþ) : current row'dan sonuna kadar olan bölümde fonksiyonu uygula.

--ex. 1 PRECEDING AND 1 FOLLOWING --> CURRENT ROW 1. SATIR OLSUN 1. SATIRDAN ÖNCESÝ YOK SONRASI 2. SATIR. YANÝ ÝÞLEME 1 VE 2. SATIRI DAHÝL EDECEK
--daha sonra 2. satýra gecti ve 2 den öncesi 1. satýr ve 2. satýrdan sonrasý 3. satýr .yani iþleme 1 2 3 staýrlarý dahil edecek. Window function satýr satýr iþlem yapýyor.
--Hareketli ortalama-kümülatif toplam gibi iþlemleri bu fonksiyonlarla grup bazýnda kolayca yapabiliriz.


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
		, COUNT(*) OVER() NOTHING --hiçbir gruplama yapmadan tüm satýrlarý say
		, COUNT(*) OVER(PARTITION BY brand_id)
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year)--kümülatif iþlem yaptýrdý.
FROM	product.product




SELECT	brand_id, model_year
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year)
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)--DEFAULT FRAME
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM	product.product


--
--BRAND_ÝD LERÝ MODEL_YEAR A GÖRE KÜMÜLATÝF TOPLADI.
--þimdiden baþla bir sonraki kýrýlýma kadar say.8-20-28-41 þeklinde.. yani kümülatif olarak
SELECT	brand_id, model_year
		, COUNT (*) OVER(PARTITION BY brand_id ORDER BY model_year RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM	product.product



--önceden baþla bir sonraki kýrýlýma kadar say.yani tamamýnýn toplamýkýrýlýmýn toplamý
--her brand için toplam yani 41
SELECT	brand_id, model_year
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	product.product
order by brand_id, model_year
----> ROW ÝLR RANGE ARASINDAKÝ FARK ;
--iþlem olarak bir fark yok ama keywordlerle range kullanýyoruz, specific deðer giriyorsak da row function kullanýyoruz.



----bir önceki ve bir sonraki satýrlarýn istenen kýrýlýmda toplamýný  getirir. 
SELECT	brand_id, model_year
		, COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) 
FROM	product.product
order by brand_id, model_year



--------Query Time----------
-- Write a query that returns average product prices of brands. 
SELECT	*,
		AVG(list_price) OVER (PARTITION BY brand_id)
FROM	product.product
 

--OVER iþlemi içindeki ORDER BY --> window fonksiyonu uygularken dikkate alacaðý order by'dýr.
--Query sonundaki ORDER BY --> SELECT iþlemi neticesindeki sonucun order by'ýdýr

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
--order_item tablosunda kaç farklý ürün var?
SELECT COUNT(product_id)
FROM(
        select distinct product_id 
        FROM sale.order_item
    )A


--Window Function içinde DISTINCT kullanamazsýn.
--Distinct'li iþlem yapmaz. Ancak Window Function ile dönen verinin baþýnda (yani SELECT'ten sonra) DISTINCT kullanabilirsin.


--BURADA 4772 4772 KERE GETÝRDÝ
SELECT COUNT (product_id) OVER()
FROM	sale.order_item

--BURADA ÝSE 4772 SAYISINI TEK BÝR SATIRDA GETÝRÝR
SELECT	DISTINCT COUNT (product_id) OVER()
FROM	sale.order_item

--UNÝQUE PRODUCT SAYISINI 307 YÝ GETÝRÝR.
SELECT COUNT (DISTINCT product_id)
from sale. order_item

--UNÝQUE PRODUCT SAYISINI 307 YÝ GETÝRÝR.YANÝ DÝSTINCT WÝNDOWS FUNS. ÝÇÝNDE KULLANILMALI
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


------------------FIRST VALUE FUNCTÝON-------------
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


---product_id DE BÝR ÖNCEKÝ SATIRDAN ÞÝMDÝKÝ SATIRA KADAR OLAN KISMI GETÝRÝYOR.
-- YANÝ ÖNCEKÝ NEYSE ONU GETÝRMÝÞ OLUYOR.ÇÜNKÜ CURRENT ROW DAHÝL DEÐÝL
SELECT *,
	FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC ROWS BETWEEN 1 PRECEDING AND CURRENT ROW )
FROM product.stock;

---product_id DE  ÞÝMDÝKÝ SATIRDAN SONUNA KADAR  OLAN KISMI GETÝRÝYOR.
---YANÝ HER KIRILIM ÝÇÝN TOPLAM product_id SAYISINI GETÝRÝYOR.
SELECT *,
	FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING )
FROM product.stock;


--Write a query that returns customers and their most valuable order with total amount of it.
--Müþterileri ve en deðerli sipariþlerini toplam tutarýyla birlikte döndüren bir sorgu yazýn.
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
---her ay için ilk sipariþ tarihi
SELECT	DISTINCT YEAR(order_date) year,
		MONTH(order_date) month,
		FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date) first_ord_date
FROM	sale.orders




------------------LAST VALUE FUNCTÝON-------------
--Write a query that returns most stocked product in each store. (Use Last_Value)
SELECT	DISTINCT store_id,
		FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC),--RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		LAST_VALUE (product_id) OVER (PARTITION BY store_id ORDER BY quantity, product_id desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	product.stock
--firSt value ve last value kullanarak ayný deðeri elde ettik.


SELECT *
FROM	product.stock
ORDER BY
		store_id, quantity asc






------------------LAG() FUNCTÝON-------------(Analytic Navigation Functions)
--RETURNS THE VALUE ÝN PREVÝOUS ROWS FOR EACH ROW OF SORTED COLUMN VALUES.

--------Query Time----------
--Write a query that returns the order date of the one previous sale of each staff (use the LAG function)
--her çalýþanýn bir önceki sipariþ tarihi

SELECT A.staff_id, A.first_name,A.last_name, B.order_id, B.order_date
FROM sale.staff A, sale.orders B
WHERE A.staff_id =B.staff_id


SELECT	A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LAG(order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) prev_order_date
FROM	sale.staff A, sale.orders B
WHERE	A.staff_id = B.staff_id  


------------------LEAD() FUNCTÝON-------------(Analytic Navigation Functions)
--RETURNS THE VALUE ÝN NEXT ROWS FOR EACH ROW OF SORTED COLUMN VALUES.

--Write a query that returns the order date of the one next sale of each staff (use the lead function)
SELECT	A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LEAD (order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) prev_order_date
FROM	sale.staff A, sale.orders B
WHERE	A.staff_id = B.staff_id



----------------------Analytic Numbering Functions--ROW_NUMBER()--RANK()--DENSE_RANK()--NTÝLE()--PERCENT_RANK()--------------
-- Ranking Window Functions :
--kayýt seti içinde derecelendirme fonksiyonlarýdýr. Bunlar:

---------ROW_NUMBER
-- kayýt setinin herbir bölümüne atamak üzere 1 'den baþlayarak sýralý giden bir sayý üretir.

-----------RANK & DENSE_RANK
--RANK fonksiyonu ile bölümlendirilmiþ kayýt setindeki her bir bölüme bir rank numarasý verilir.
--Bu kayýt setinde alt bölüm içindeki her kayýt ayný rank numarasýna sahiptir. Bu numaralandýrma yine 1'den baþlar.
--Ancak ROW_NUMBER fonksiyonunda olduðu gibi ardarda gelen bir sýralandýrma ile gitmek zorunda deðildir. 
--Bir bölüm içinde birden fazla kayýt varsa rank numaralarýnda atlamalar olacaktýr.

-- ------NTILE
-- NTILE fonksiyonu SELECT ifadenizde WHERE koþuluna uyan kayýtlarý OVER ve ORDER BY ile belirtilen sýralamaya
-- göre dizilmiþ þekilde sizin parametre olarak geçeceðiniz bir sayýya bölerek her bölüme bir sýra numarasý verir.

---cume_dýst
--degerlerin ne oldugunu deðil deðerlerin hangi satýrda olduðunu önemsiyor.
--oldugu satýr sayýsýný toplam satýra bölüyoruz.
--CUME_DIST() = row_number/total_rows

--percent_rank
-- bir satýrdaki degerin o sutun içinde yuzde kaclýk dilimden dajha büyük oldugunu gösteriyor
--yinelenen degerler için en kucuk index sýrasýný alýyoruz
--PERCENT_RANK() = (row_number-1)/(total_rows-1)


--------Query Time----------
--Assign an ordinal number to the product prices for each category in ascending order

select category_id, list_price
from product.product
order by 1,2


select category_id, list_price,
   row_number() over (PARTITION BY category_id order by category_id) as ord_numbr
from product.product

--her kategorideki en düþük ürün fiyatýný getir.
SELECT *
FROM(
	SELECT category_id, list_price,
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) as ord_number
FROM product.product
	) A
WHERE ord_number = 1

--her kategorideki en düþük 3 ürün fiyatýný getir.
SELECT *
FROM(
		SELECT category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) as ord_number
FROM product.product
	) A
WHERE ord_number < 4

--------RANK vs. DENSE_RANK

SELECT category_id, list_price,
        ROW_NUMBER() OVER( ORDER BY list_price) RN,--ROW_NUMBER sýrayla numaralandýrýr.
		RANK () OVER( ORDER BY list_price) RNK,--RANK SATIR NUMARASINI VERÝR. AYNI ÇIKTILAR  AYNI NUMARA SONRAKÝ BULUNULAN SATIR NUMARASI.
		DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price) DNS_RNK --DENSE RANK SIRA NUMARASINI VERÝR.AYNI ÇIKTILAR  AYNI NUMARA SONRAKÝ SIRADAKÝ SATIR NUMARASI
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


--GÜNLERE GÖRE ÜRÜN SAYILARI
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
--RANK fonksiyonu ile tekrar eden satýrlara ayný numaralar verilir ve kullanýlmayan numaralar geçilir.
--DENSE_RANK fonksiyonunda ayný deðere sahip satýrlara ayný deðer veriliyor ama sýralama algoritmasýnda hiç bir rakam atlanmýyor.
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
