
CREATE DATABASE RFM_SegmentSales
COLLATE Latin1_General_CI_AS;

select * from dbo.sales_data_sample

--CHecking unique values
select distinct status from [dbo].[sales_data_sample] --Nice one to plot
select distinct YEAR_ID from [dbo].[sales_data_sample]
select distinct PRODUCTLINE from [dbo].[sales_data_sample] ---Nice to plot
select distinct COUNTRY from [dbo].[sales_data_sample] ---Nice to plot
select distinct DEALSIZE from [dbo].[sales_data_sample] ---Nice to plot
select distinct TERRITORY from [dbo].[sales_data_sample] ---Nice to plot

select distinct MONTH_ID from [dbo].[sales_data_sample]
where YEAR_ID = 2005

---ANALYSIS
----Let's start by grouping sales by productline
select PRODUCTLINE, sum(sales) Revenue
from [dbo].[sales_data_sample]
group by PRODUCTLINE
order by 2 desc

----Let's start by grouping sales by year
select YEAR_ID, sum(sales) Revenue
from [dbo].[sales_data_sample]
group by YEAR_ID
order by 2 desc

----Let's start by grouping sales by deal size
select  DEALSIZE,  sum(sales) Revenue
from [dbo].[sales_data_sample]
group by  DEALSIZE
order by 2 desc


----What was the best month for sales in a specific year? How much was earned that month? 
select  MONTH_ID, sum(sales) Revenue, count(ORDERNUMBER) Frequency
from [dbo].[sales_data_sample]
where YEAR_ID = 2003 --change year to see the rest
group by  MONTH_ID
order by 2 desc


--November seems to be the month, what product do they sell in November, Classic I believe
select  MONTH_ID, PRODUCTLINE, sum(sales) Revenue, count(ORDERNUMBER) Frequency
from [dbo].[sales_data_sample]
where YEAR_ID = 2003 and MONTH_ID = 11 --change year to see the rest
group by  MONTH_ID, PRODUCTLINE
order by 3 desc

--RFM ANALYS�S
---*Recency   : last order date
---*Frequency :count of total orders
---*Monetary  :total spend

select*
from sales_data_sample

--
SELECT  CUSTOMERNAME ,
		sum(SALES) MonetaryValue,
		avg(SALES) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date
from [dbo].[sales_data_sample]
group by CUSTOMERNAME


---
SELECT  CUSTOMERNAME ,
		sum(SALES) MonetaryValue,
		avg(SALES) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,--Her m��teri i�in sipari� say�s�n� bulur.
		max(ORDERDATE) last_order_date,--Her m��terinin en son yap�lan sipari�in tarihini bulur.
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date--T�m m��terilerin sipari� verdi�i tarihin en yenisini bulur.
from [dbo].[sales_data_sample]
group by CUSTOMERNAME


--- m��terilerin toplam sat��, ortalama sat��, sipari� say�s�, en son sipari� tarihi ve genel olarak en yeni sipari� tarihini g�sterir. 

select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
from [dbo].[sales_data_sample]
group by CUSTOMERNAME


-- m��teri baz�nda RFM analizine dayal� istatistiksel bilgileri i�eren bir tablo olu�turur ve bu tablodan t�m s�tunlar� se�er

;with rfm as -- "rfm" ad�nda bir ge�ici tablo (Common Table Expression - CTE) olu�turur
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	from [dbo].[sales_data_sample]
	group by CUSTOMERNAME
)
SELECT r.* FROM rfm r -- Olu�turulan rfm ge�ici tablosundan t�m s�tunlar� se�er.



--RFM analizi sonu�lar�na dayal� olarak m��terileri Recency, Frequency ve MonetaryValue �zelliklerine g�re d�rt e�it gruba b�ler.
;with rfm as -- "rfm" ad�nda bir ge�ici tablo (Common Table Expression - CTE) olu�turur
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	from [dbo].[sales_data_sample]
	group by CUSTOMERNAME
)
SELECT r.* ,
       NTILE(4) OVER (order by Recency desc) rfm_recency,--Recency de�erlerini b�y�kten k����e s�ralayarak her m��teriyi d�rt e�it gruba b�ler (d�rt kuartile).
	   NTILE(4) OVER (order by Frequency) rfm_frequency,--Frequency de�erlerini k���kten b�y��e s�ralayarak her m��teriyi d�rt e�it gruba b�ler.
	   NTILE(4) OVER (order by MonetaryValue) rfm_monetary--MonetaryValue de�erlerini k���kten b�y��e s�ralayarak her m��teriyi d�rt e�it gruba b�ler.
FROM rfm r

---NEXT
;with rfm as -- "rfm" ad�nda bir ge�ici tablo (Common Table Expression - CTE) olu�turur
(
	SELECT 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	FROM [dbo].[sales_data_sample]
	GROUP BY CUSTOMERNAME
),--Yukar�da rfm ad�nda ge�ici tablo(CTE)olu�turdu.
rfm_calc as
(
SELECT r.* ,
       NTILE(4) OVER (order by Recency desc) rfm_recency,--Recency de�erlerini b�y�kten k����e s�ralayarak her m��teriyi d�rt e�it gruba b�ler (d�rt kuartile).
	   NTILE(4) OVER (order by Frequency) rfm_frequency,--Frequency de�erlerini k���kten b�y��e s�ralayarak her m��teriyi d�rt e�it gruba b�ler.
	   NTILE(4) OVER (order by MonetaryValue) rfm_monetary--MonetaryValue de�erlerini k���kten b�y��e s�ralayarak her m��teriyi d�rt e�it gruba b�ler.
FROM rfm r
)--Ard�ndan, rfm_calc ad�nda bir ba�ka CTE olu�turulur. Bu CTE, rfm tablosundan gelen verileri kullanarak her bir m��teriyi Recency,
--Frequency ve MonetaryValue de�erlerine g�re d�rt e�it gruba b�len NTILE fonksiyonu kullan�larak RFM segmentlerini hesaplar.
SELECT c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell
FROM rfm_calc c
--Bu son sorgu, rfm_calc tablosundan gelen verilerle birlikte her bir m��terinin RFM h�cre de�erini (rfm_cell) i�eren sonu� k�mesini d�nd�r�r. 
--RFM h�cre de�eri, Recency, Frequency ve MonetaryValue de�erlerinin toplam�d�r.
--Bu de�er, m��teriyi belirli bir segmente yerle�tirmek i�in kullan�labilir. 

--NEXT
;with rfm as -- "rfm" ad�nda bir ge�ici tablo (Common Table Expression - CTE) olu�turur
(
	SELECT 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	FROM [dbo].[sales_data_sample]
	GROUP BY CUSTOMERNAME
),--Yukar�da rfm ad�nda ge�ici tablo(CTE)olu�turdu.
rfm_calc as
(
SELECT r.* ,-- ifadesi, rfm tablosundaki t�m s�tunlar� se�er.
       NTILE(4) OVER (order by Recency desc) rfm_recency,--Recency de�erlerini b�y�kten k����e s�ralayarak her m��teriyi d�rt e�it gruba b�ler (d�rt kuartile).
	   NTILE(4) OVER (order by Frequency) rfm_frequency,--Frequency de�erlerini k���kten b�y��e s�ralayarak her m��teriyi d�rt e�it gruba b�ler.
	   NTILE(4) OVER (order by MonetaryValue) rfm_monetary--MonetaryValue de�erlerini k���kten b�y��e s�ralayarak her m��teriyi d�rt e�it gruba b�ler.
FROM rfm r
)
SELECT c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
       cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary  as varchar)rfm_cell_string
FROM rfm_calc c


---NEXT
--IF OBJECT_ID('tempdb..#rfm') IS NOT NULL DROP TABLE #rfm; BU KISIM ALTERNAT�F Y�NTEM

DROP TABLE IF EXISTS #rfm--E�er #rfm ad�nda bir ge�ici tablo zaten varsa, bu tabloyu siler. 
                          --Bu, her sorgu �al��t���nda temiz bir ba�lang�� sa�lamak i�in yap�l�r.
;with rfm as 
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	from [dbo].[sales_data_sample]
	group by CUSTOMERNAME
),
rfm_calc as
(

	select r.*,-- ifadesi, rfm tablosundaki t�m s�tunlar� se�er.
		NTILE(4) OVER (order by Recency desc) rfm_recency,
		NTILE(4) OVER (order by Frequency) rfm_frequency,
		NTILE(4) OVER (order by MonetaryValue) rfm_monetary
	from rfm r
)
select 
	c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary  as varchar)rfm_cell_string
into #rfm
from rfm_calc c
--SELECT ... INTO #rfm ...: Bu k�s�m, rfm_calc tablosundan gelen verilerle birlikte, her bir m��terinin RFM h�cre de�erini (rfm_cell)
--i�eren sonu� k�mesini olu�turur ve bu verileri #rfm ad�ndaki ge�ici tabloya ekler. Ayr�ca, rfm_recency, rfm_frequency, 
--ve rfm_monetary de�erlerini birle�tirerek bir karakter dizesi olu�turup rfm_cell_string ad�nda bir s�tun olu�turur.


--KONTROL EDEL�M..
SELECT *
FROM #rfm





----Who is our best customer (this could be best answered with RFM)
DROP TABLE IF EXISTS #rfm--E�er #rfm ad�nda bir ge�ici tablo zaten varsa, bu tabloyu siler. 
                         --Bu, her sorgu �al��t���nda temiz bir ba�lang�� sa�lamak i�in yap�l�r.
;with rfm as 
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	from [dbo].[sales_data_sample]
	group by CUSTOMERNAME
),
rfm_calc as
(

	SELECT r.*,
		NTILE(4) OVER (order by Recency DESC) rfm_recency,
		NTILE(4) OVER (order by Frequency) rfm_frequency,
		NTILE(4) OVER (order by MonetaryValue) rfm_monetary
	from rfm r
)
SELECT 
	c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary  as varchar)rfm_cell_string
INTO #rfm
FROM rfm_calc c

SELECT CUSTOMERNAME , rfm_recency, rfm_frequency, rfm_monetary,
	CASE
		WHEN rfm_cell_string in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) THEN 'lost_customers'  --lost customers
		WHEN rfm_cell_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' -- (Big spenders who haven�t purchased lately) slipping away
		WHEN rfm_cell_string in (311, 411, 331) THEN 'new customers'
		WHEN rfm_cell_string in (222, 223, 233, 322) THEN 'potential churners'
		WHEN rfm_cell_string in (323, 333,321, 422, 332, 432) THEN 'active' --(Customers who buy often & recently, but at low price points)
		WHEN rfm_cell_string in (433, 434, 443, 444) THEN 'loyal'
	END rfm_segment

FROM #rfm
 

SELECT*
FROM sales_data_sample
--What products are most often sold together? 
WITH OrderProducts AS (
    SELECT
        ORDERNUMBER,
        STRING_AGG(PRODUCTLINE, ',') WITHIN GROUP (ORDER BY PRODUCTLINE) AS CombinedProducts
    FROM
        [dbo].[sales_data_sample]
    GROUP BY
        ORDERNUMBER
    HAVING
        COUNT(DISTINCT PRODUCTLINE) > 1
)
SELECT
    DISTINCT CombinedProducts,
    COUNT(*) AS OccurrenceCount
FROM
    OrderProducts
GROUP BY
    CombinedProducts
ORDER BY
    OccurrenceCount DESC;




----A�ag�daki sorgu 'Shipped' durumundaki sipari�lerin her birinin sipari� numaras�n� ve her bir sipari�in ka� defa tekrarland���n�
----i�eren bir sonu� k�mesini d�nd�r�r. rn s�tunu, her bir sipari�in tekrar say�s�n� g�sterir.
SELECT ORDERNUMBER, count(*) rn-- ORDERNUMBER s�tununu ve bu s�tundaki de�erlerin ka� defa tekrarland���n� sayan bir sayac� (rn) i�erir.
FROM [dbo].[sales_data_sample]
WHERE STATUS = 'Shipped'
GROUP BY ORDERNUMBER

--
--SELECT * FROM [dbo].[sales_data_sample] WHERE ORDERNUMBER= 10411

--NEXT
--Bu SQL sorgusu, [dbo].[sales_data_sample] tablosundan "Shipped" (g�nderilmi�) durumundaki sipari�leri i�eren ve her bir sipari�
--numaras�n�n ka� defa tekrarland���n� sayan bir alt sorgu i�erir. Daha sonra, bu alt sorgunun sonucunda elde edilen ge�ici tablo 
--veya sonu� k�mesi �zerinde rn (row number) de�eri 3 olan sipari� numaralar�n� se�er.
SELECT ORDERNUMBER FROM
   (
	SELECT ORDERNUMBER, count(*) rn-- ORDERNUMBER s�tununu ve bu s�tundaki de�erlerin ka� defa tekrarland���n� sayan bir sayac� (rn) i�erir.(row number)
	FROM [dbo].[sales_data_sample]
	WHERE STATUS = 'Shipped'
	GROUP BY ORDERNUMBER
	)m--olu�turulan ge�ici tabloya bir takma ad (alias) verir
WHERE rn = 3


--NEXTT
SELECT ',' + PRODUCTCODE
FROM [dbo].[sales_data_sample]
WHERE ORDERNUMBER IN(
	SELECT ORDERNUMBER FROM
	   (
		SELECT ORDERNUMBER, count(*) rn-- ORDERNUMBER s�tununu ve bu s�tundaki de�erlerin ka� defa tekrarland���n� sayan bir sayac� (rn) i�erir.(row number)
		FROM [dbo].[sales_data_sample]
		WHERE STATUS = 'Shipped'
		GROUP BY ORDERNUMBER
		)m--olu�turulan ge�ici tabloya bir takma ad (alias) verir
	WHERE rn = 2
	)
	FOR XML PATH('')--SQL sorgusunda, sonu� k�mesini bir XML belgesine d�n��t�rmek i�in kullan�l�r. Bu ifade, 
	                --sorgu sonu�lar�n� XML format�nda birle�tirilmi� bir dize olarak d�nd�rmeye olanak tan�r.

--NEXTTT
SELECT stuff(  --STUFF fonksiyonu ise ba�taki virg�l� kald�rarak d�zg�n birle�mi� bir dize elde etmeye yard�mc� olur.

	(SELECT ',' + PRODUCTCODE
	 FROM [dbo].[sales_data_sample]
	 WHERE ORDERNUMBER IN
	      (
		   SELECT ORDERNUMBER FROM
		   (
			SELECT ORDERNUMBER, count(*) rn-- ORDERNUMBER s�tununu ve bu s�tundaki de�erlerin ka� defa tekrarland���n� sayan bir sayac� (rn) i�erir.(row number)
			FROM [dbo].[sales_data_sample]
			WHERE STATUS = 'Shipped'
			GROUP BY ORDERNUMBER
			)m--olu�turulan ge�ici tabloya bir takma ad (alias) verir
		WHERE rn = 2--(yani, iki farkl� �r�n i�eren sipari�ler)
		)
		FOR XML PATH(''))
		,1,1,'')



--NEXTTT
SELECT DISTINCT ORDERNUMBER, STUFF(
	(SELECT ',' + PRODUCTCODE
	 FROM [dbo].[sales_data_sample] p
	 WHERE ORDERNUMBER IN
	      (
		   SELECT ORDERNUMBER 
		   FROM(
			   SELECT ORDERNUMBER, count(*) rn-- ORDERNUMBER s�tununu ve bu s�tundaki de�erlerin ka� defa tekrarland���n� sayan bir sayac� (rn) i�erir.(row number)
			   FROM [dbo].[sales_data_sample]
			   WHERE STATUS = 'Shipped'
			   GROUP BY ORDERNUMBER
			    )m--olu�turulan ge�ici tabloya bir takma ad (alias) verir
		   WHERE rn = 2
		  )
	  AND p.ORDERNUMBER = s.ORDERNUMBER
	  FOR XML PATH(''))
		,1,1,'') ProductCodes
FROM [dbo].[sales_data_sample] s
ORDER BY 2 DESC



-----EXTRAs----
--What city has the highest number of sales in a specific country
select CITY, sum (sales) Revenue
from [dbo].[sales_data_sample]
where country = 'UK'
group by CITY
order by 2 desc



---What is the best product in United States?
select country, YEAR_ID, PRODUCTLINE, sum(sales) Revenue
from [dbo].[sales_data_sample]
where country = 'USA'
group by  country, YEAR_ID, PRODUCTLINE
order by 4 desc


select * from sales_data_sample
--En Fazla �r�n �e�idi Sat�n Alan M��teriler:
SELECT
    CUSTOMERNAME,
    COUNT(DISTINCT PRODUCTCODE) AS UniqueProductsCount
FROM [dbo].[sales_data_sample]
GROUP BY CUSTOMERNAME
ORDER BY UniqueProductsCount DESC;


--Her M��teri ��in En Y�ksek Tutarl� Sipari�:
SELECT 
    CUSTOMERNAME,
    ORDERNUMBER,
    MAX(sales) AS MaxOrderAmount
FROM [dbo].[sales_data_sample]
GROUP BY CUSTOMERNAME, ORDERNUMBER
ORDER BY MaxOrderAmount DESC;


---Bu sorgu, her bir ay�n alt�nda farkl� �r�n kategorileri ve bu kategorilere ait toplam sat��lar� i�eren bir pivot tablosu olu�turur. 
WITH OrderCategoryTotals AS --ge�ici bir tablo (CTE) olu�turulur. Bu tablo, sipari� tarihlerini y�l ve ay d�zeyinde grupland�r�r
                             --ve her bir �r�n kategorisi i�in toplam sat�� miktar�n� hesaplar.
  (
	SELECT
        CONVERT(VARCHAR(7), ORDERDATE, 120) AS OrderMonth,--VARCHAR(7): Bu, d�n��t�r�len karakter dizisinin maksimum uzunlu�unu belirtir.
		                                                  --Yani, en fazla 7 karakter uzunlu�unda bir karakter dizisi olu�turulacakt�r.
														  --120: Bu, tarih ve saat bi�imini belirten bir stil kodudur. 120 stili, 
														  --"yyyy-mm" y�l ve ay format�ndaki bir tarih bi�imini ifade eder.
        PRODUCTLINE,
        SUM(SALES) AS TotalSales
    FROM [dbo].[sales_data_sample]
    GROUP BY CONVERT(VARCHAR(7), ORDERDATE, 120), PRODUCTLINE
  )

SELECT
    *
FROM
    (
        SELECT 
            OrderMonth,
            PRODUCTLINE,
            TotalSales
        FROM OrderCategoryTotals
    ) AS SourceTable
PIVOT
(
    SUM(TotalSales)
    FOR PRODUCTLINE IN ([Classic Cars], [Trucks and Buses], [Planes], [Vintage Cars], [Motorcycles], [Ships], [Trains])
) AS PivotTable
ORDER BY OrderMonth;


--PRODUCTLINE'a g�re toplam sat��lar� ve y�llara g�re bu toplamlar� i�eren bir tablo olacakt�r. 
SELECT
    *
FROM 
    (
        SELECT 
            YEAR_ID,
            PRODUCTLINE,
            SALES
        FROM sales_data_sample
    ) AS DENEME
PIVOT
   (
    SUM(SALES)
    FOR YEAR_ID IN ([2003], [2004], [2005])
  )
 AS PivotTable
ORDER BY 2 DESC;


